(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)") > fernet.txt
openssl rand -base64 32 > rds_password.txt