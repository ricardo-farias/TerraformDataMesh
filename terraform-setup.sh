(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)") | tr -d '\n' > fernet.txt
openssl rand -base64 32 | tr -d '\n' > rds_password.txt