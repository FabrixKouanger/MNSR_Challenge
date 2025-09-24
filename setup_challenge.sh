#!/bin/bash
# ROOT-ME CTF: Linux Permissions Master

echo "Initialisation du challenge..."
sleep 2

# Décryptage
decrypt() { echo "$1" | base64 -d 2>/dev/null; }

USER1=$(decrypt "cm9vdG1lX3VzZXIx")
USER2=$(decrypt "cm9vdG1lX3VzZXIy")
ADMIN_USER=$(decrypt "YWRtaW5fdXNlcg==")
GROUP=$(decrypt "c2VjdXJpdHlfZ3Jw")
PASSWORD=$(decrypt "UEFTU3dvcmQxMjM=")
SECRET_FILE=$(decrypt "ZmxhZ190ZXN0LnR4dA==")
HINT=$(decrypt "U1VJRCBzZXR0aW5nIGlzIGtleQ==")

echo "Identifiants décryptés!"
echo "   Utilisateurs: $USER1, $USER2, $ADMIN_USER"
echo "   Groupe: $GROUP"
echo "   Fichier secret: $SECRET_FILE"
echo "   Indice: $HINT"

# Création des utilisateurs
echo "Création des comptes utilisateurs..."
for user in $USER1 $USER2 $ADMIN_USER; do
    sudo useradd -m -s /bin/bash $user 2>/dev/null
    echo "$user:$PASSWORD" | sudo chpasswd
done

# Création du groupe
sudo groupadd $GROUP 2>/dev/null
sudo usermod -aG $GROUP $USER1
sudo usermod -aG $GROUP $USER2

# Création de l'arborescence du challenge
echo "Création de l'environnement du CTF..."
sudo mkdir -p /ctf/{public,private,restricted,binaries}
sudo mkdir -p /home/$ADMIN_USER/.secret_config

# Fichier avec le flag (mais protégé)
sudo tee /ctf/private/$SECRET_FILE > /dev/null << EOF
BRAVO! Vous avez trouvé le flag principal!
FLAG: RM{linux_permissions_master_001}

Mais attention, ce n'est pas le vrai flag...
Le vrai flag est caché ailleurs avec des permissions spéciales!
EOF

# Faux flag pour tromper
sudo tee /ctf/public/fake_flag.txt > /dev/null << EOF
FLAG: RM{fake_flag_do_not_submit}
EOF

# Fichier avec indice réel
sudo tee /ctf/restricted/hint.txt > /dev/null << EOF
Indice: Vérifiez les binaires avec bit SUID...
Certains programmes peuvent s'exécuter avec des privilèges élevés!
EOF

# Binaire SUID qui contient le vrai flag
sudo tee /tmp/create_flag.c > /dev/null << 'EOF'
#include <stdio.h>
#include <stdlib.h>

int main() {
    system("echo 'Vrai flag: RM{suid_bit_escalation_1337}' > /ctf/private/real_flag.txt");
    system("chmod 600 /ctf/private/real_flag.txt");
    printf("Flag créé! Mais pouvez-vous le lire?\n");
    return 0;
}
EOF

sudo gcc /tmp/create_flag.c -o /ctf/binaries/create_flag
sudo rm /tmp/create_flag.c

echo "Challenge configuré! Bonne chance!"
