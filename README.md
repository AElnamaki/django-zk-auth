# Django ZK Auth

**Modern Zero-Knowledge Authentication for Django Projects**

![PyPI version](https://img.shields.io/pypi/v/django-zk-auth)
![Python versions](https://img.shields.io/pypi/pyversions/django-zk-auth)
![License](https://img.shields.io/github/license/your-org/django-zk-auth)

## Overview

`django-zk-auth` is a powerful Django package that introduces Zero-Knowledge Proof (ZKP) authentication for privacy-preserving user verification. Built with cutting-edge cryptographic primitives and Circom-based ZK circuits, this package enables users to authenticate without revealing sensitive secrets.

## Features

* ✠ Zero-Knowledge Authentication with Groth16
* ⚡ Poseidon Hashing for ZK-friendly commitments
* 🔒 BN254 field arithmetic and proof verification
* ✨ Plug-and-play backend for Django's authentication system
* 🚀 Ready-to-use zk-SNARK circuit integration
* 🔢 Fully type-annotated and tested Python code

## Installation

```bash
pip install django-zk-auth
```

## Quickstart

1. **Add to Installed Apps and Set Auth Backend**

```python
# settings.py
INSTALLED_APPS = [
    ...
    'django_zk_auth',
]

AUTHENTICATION_BACKENDS = [
    'django_zk_auth.auth_backend.ZKProofAuthenticationBackend',
    'django.contrib.auth.backends.ModelBackend',
]

AUTH_USER_MODEL = 'django_zk_auth.ZKUser'
```

2. **Include Routes**

```python
# urls.py
from django.urls import include, path

urlpatterns = [
    ...
    path("zk_auth/", include("django_zk_auth.urls")),
]
```

3. **Migrate Database**

```bash
python manage.py migrate
```

## Authentication Flow

The package uses the following protocol:

1. User generates a zk-SNARK proof of identity knowledge using Circom + `zk_auth.circom`
2. User sends the proof, public signals, and identity commitment to the server
3. The backend verifies the proof using the verification key
4. If valid, the user is authenticated and optionally created if registering

## API Endpoints

### Register: `POST /zk_auth/register/`

```json
{
  "username": "zkuser",
  "proof": { ... },
  "public_signals": [ ... ],
  "identity_commitment": "0xabc..."
}
```

### Login: `POST /zk_auth/login/`

```json
{
  "username": "zkuser",
  "proof": { ... },
  "public_signals": [ ... ]
}
```

## Circuits

The `zk_circuits/` directory includes Circom artifacts:

```
zk_circuits/
├── zk_auth.circom        # Main circuit logic
├── zk_auth.r1cs          # Constraint system
├── zk_auth.zkey          # Proving key
├── zk_auth_vkey.json     # Verification key
└── zk_auth_js/
    └── zk_auth.wasm      # WASM for proof generation
```

To generate circuits:

```bash
circom zk_auth.circom --r1cs --wasm
snarkjs groth16 setup zk_auth.r1cs ptau_file.ptau zk_auth.zkey
snarkjs zkey export verificationkey zk_auth.zkey zk_auth_vkey.json
```

## Directory Structure

```
django_zk_auth/
├── admin.py
├── apps.py
├── auth_backend.py
├── crypto/
│   ├── field_arithmetic.py       # Finite field ops (BN254)
│   ├── hash_utils.py             # audit hashing
│   ├── poseidon.py               # Poseidon Hash impl
│   ├── proof_system.py           # Groth16 proof verify
│   ├── types.py                  # Custom types
│   └── zk_system.py              # ZK verification logic
├── exceptions.py
├── models.py                    # ZKUser model
├── urls.py
├── utils.py                     # IP/rate limit helpers
└── views.py                     # Auth endpoints

zk_circuits/
├── zk_auth.circom
├── zk_auth.r1cs
├── zk_auth.zkey
├── zk_auth_vkey.json
└── zk_auth_js/zk_auth.wasm

tests/
├── test_poseidon.py
├── test_field_arithmetic.py
├── test_hash_utils.py
├── test_proof_system.py
└── ...
```
## Running Tests

The package includes an example `tests/test_settings.py` which configures an in-memory database and minimal apps for testing the authentication backend in isolation.

```bash
pytest -s tests/test_zksystem.py
```
## Running Specific Tests by Class
```bash
pytest -k TestZKSystem -s tests/test_zk_system.py
```

## License

MIT License. See the `LICENSE` file.

## Contributing

We welcome contributions! Please:

* Fork the repository
* Create a new branch for your feature or fix
* Add tests
* Ensure `pytest` passes
* Open a pull request

---

Crafted with ❤️ to bring zero-knowledge privacy to Django.


  
