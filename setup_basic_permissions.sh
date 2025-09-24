#!/bin/bash
# setup_basic_permissions.sh

echo "=== Configuration des permissions de base ==="

# Création de l'arborescence de test
sudo mkdir -p /opt/$GROUP/{public,private,shared}
echo "Arborescence créée dans /opt/$GROUP"

# Configuration des propriétaires et permissions
sudo chown root:$GROUP /opt/$GROUP
sudo chmod 755 /opt/$GROUP

# Dossier public (accessible à tous)
sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/public
sudo chmod 775 /opt/$GROUP/public

# Dossier privé (seul l'admin)
sudo chown $ADMIN_USER:$ADMIN_USER /opt/$GROUP/private
sudo chmod 700 /opt/$GROUP/private

# Dossier shared (groupe + admin)
sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/shared
sudo chmod 770 /opt/$GROUP/shared

echo "Permissions de base configurées"
