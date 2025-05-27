
        pragma circom 2.0.0;

        include "poseidon.circom";

        template ZKAuth() {
            // Private inputs
            signal private input password;
            signal private input salt;
            
            // Public inputs
            signal input nonce;
            signal input commitment;
            
            // Output
            signal output valid;
            
            // Hash password with salt to create user commitment
            component password_hasher = Poseidon(2);
            password_hasher.inputs[0] <== password;
            password_hasher.inputs[1] <== salt;
            
            // Hash commitment with nonce for replay protection
            component challenge_hasher = Poseidon(2);
            challenge_hasher.inputs[0] <== password_hasher.out;
            challenge_hasher.inputs[1] <== nonce;
            
            // Verify commitment matches
            component commitment_check = IsEqual();
            commitment_check.in[0] <== password_hasher.out;
            commitment_check.in[1] <== commitment;
            
            // Output is valid if commitment matches
            valid <== commitment_check.out;
            
            // Constrain the challenge hash (prevents malleability)
            component dummy_constraint = Num2Bits(254);
            dummy_constraint.in <== challenge_hasher.out;
        }

        template IsEqual() {
            signal input in[2];
            signal output out;
            
            component eq = IsZero();
            eq.in <== in[1] - in[0];
            out <== eq.out;
        }

        template IsZero() {
            signal input in;
            signal output out;
            
            signal inv;
            inv <-- in != 0 ? 1/in : 0;
            out <== -in*inv + 1;
            in*out === 0;
        }

        template Num2Bits(n) {
            signal input in;
            signal output out[n];
            
            var lc1=0;
            var e2=1;
            for (var i = 0; i<n; i++) {
                out[i] <-- (in >> i) & 1;
                out[i] * (out[i] -1 ) === 0;
                lc1 += out[i] * e2;
                e2 = e2+e2;
            }
            lc1 === in;
        }

        component main = ZKAuth();
        