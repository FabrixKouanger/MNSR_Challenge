#!/bin/bash
# Mise en place des protections et permissions avancées

echo "🔒 Activation des protections du CTF..."

# Variables
USER1="rootme_user1"
USER2="rootme_user2" 
ADMIN_USER="admin_user"
GROUP="security_grp"
SECRET_FILE="flag_test.txt"

# Permissions de base
echo "📊 Configuration des permissions de base..."

chown root:root /ctf
chmod 755 /ctf

# Dossier public
chown $ADMIN_USER:$GROUP /ctf/public
chmod 775 /ctf/public
chown $ADMIN_USER:$GROUP /ctf/public/fake_flag.txt
chmod 644 /ctf/public/fake_flag.txt

# Dossier private (strict)
chown $ADMIN_USER:$ADMIN_USER /ctf/private
chmod 700 /ctf/private
chown $ADMIN_USER:$ADMIN_USER /ctf/private/$SECRET_FILE
chmod 600 /ctf/private/$SECRET_FILE

# Dossier restricted (ACL)
chown $ADMIN_USER:$GROUP /ctf/restricted
chmod 750 /ctf/restricted
chown $ADMIN_USER:$ADMIN_USER /ctf/restricted/hint.txt
chmod 600 /ctf/restricted/hint.txt

# Dossier binaries (SUID)
chown root:root /ctf/binaries
chmod 755 /ctf/binaries

# Configuration des ACL
echo "⚡ Configuration des ACL avancées..."

setfacl -m u:$USER1:r-x /ctf/restricted
setfacl -m u:$USER2:--- /ctf/restricted
setfacl -m u:$USER1:r-- /ctf/restricted/hint.txt

# Bit SUID sur le binaire principal
chown $ADMIN_USER /ctf/binaries/create_flag
chmod 4755 /ctf/binaries/create_flag

# Script piégé normal
chown root:root /ctf/binaries/check_permissions.sh
chmod 755 /ctf/binaries/check_permissions.sh

# Fichier final protégé
touch /ctf/private/real_flag.txt
chown $ADMIN_USER:$ADMIN_USER /ctf/private/real_flag.txt
chmod 600 /ctf/private/real_flag.txt

echo "🔐 Sécurisation terminée!"
echo "   • ACL configurées"
echo "   • SUID activé"
echo "   • Permissions verrouillées"
