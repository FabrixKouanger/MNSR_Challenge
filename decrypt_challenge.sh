#!/bin/bash
# decrypt_challenge.sh

echo "=== CHALLENGE CryptoUser-Permissions ==="

# Fonction de décryptage
decrypt() {
    echo "$1" | base64 -d 2>/dev/null
}

# Décryptage
USER1=$(decrypt "$USER1_CRYPT")
USER2=$(decrypt "$USER2_CRYPT")
GROUP=$(decrypt "$GROUP_CRYPT")
ADMIN_USER=$(decrypt "$ADMIN_CRYPT")
SECRET_FILE=$(decrypt "$SECRET_FILE_CRYPT")
PASSWORD="password123"

echo "Utilisateurs: $USER1, $USER2, $ADMIN_USER"
echo "Groupe: $GROUP"
echo "Fichier secret: $SECRET_FILE"
