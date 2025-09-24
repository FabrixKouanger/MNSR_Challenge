#!/bin/bash
# setup_advanced_acls.sh

echo "=== Configuration des ACL avancées ==="

# Vérification que ACL est installé
if ! command -v setfacl &> /dev/null; then
    echo "Installation des outils ACL..."
    sudo apt-get update
    sudo apt-get install -y acl
fi

# ACL pour le dossier shared - $USER1 peut lire seulement
sudo setfacl -m u:$USER1:r-x /opt/$GROUP/shared
sudo setfacl -m u:$USER2:rwx /opt/$GROUP/shared  # $USER2 plein accès

# ACL pour le fichier secret - accès spécial pour $USER1
sudo setfacl -m u:$USER1:r-- /opt/$GROUP/private/$SECRET_FILE

# ACL pour le dossier public - permissions spéciales
sudo setfacl -m o:r-x /opt/$GROUP/public  # Others read+execute only

# ACL par défaut pour les nouveaux fichiers dans shared
sudo setfacl -d -m u:$USER1:r-x /opt/$GROUP/shared
sudo setfacl -d -m u:$USER2:rwx /opt/$GROUP/shared
sudo setfacl -d -m g:$GROUP:rwx /opt/$GROUP/shared

echo "ACL avancées configurées"
