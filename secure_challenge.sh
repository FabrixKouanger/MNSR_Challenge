#!/bin/bash
echo "Mise en place des protections du CTF..."

# Permissions de base
sudo chown root:root /ctf
sudo chmod 755 /ctf

# Dossier public (accessible à tous)
sudo chown $ADMIN_USER:$GROUP /ctf/public
sudo chmod 775 /ctf/public

# Dossier private (seul admin)
sudo chown $ADMIN_USER:$ADMIN_USER /ctf/private
sudo chmod 700 /ctf/private
sudo chown $ADMIN_USER:$ADMIN_USER /ctf/private/$SECRET_FILE
sudo chmod 600 /ctf/private/$SECRET_FILE

# Dossier restricted (accès spécial)
sudo chown $ADMIN_USER:$GROUP /ctf/restricted
sudo chmod 750 /ctf/restricted
sudo chown $ADMIN_USER:$ADMIN_USER /ctf/restricted/hint.txt
sudo chmod 600 /ctf/restricted/hint.txt

# Configuration des ACL
sudo setfacl -m u:$USER1:r-x /ctf/restricted
sudo setfacl -m u:$USER2:--- /ctf/restricted
sudo setfacl -m u:$USER1:r-- /ctf/restricted/hint.txt

# Bit SUID sur le binaire (CORE DU CHALLENGE)
sudo chown $ADMIN_USER /ctf/binaries/create_flag
sudo chmod 4755 /ctf/binaries/create_flag

# Création d'un script piégé
sudo tee /ctf/binaries/check_permissions.sh > /dev/null << 'EOF'
#!/bin/bash
echo "Vérification des permissions..."
echo "FLAG: RM{script_trap_do_not_trust}"
EOF
sudo chmod 755 /ctf/binaries/check_permissions.sh

echo "Protections activées! Le CTF est opérationnel."
