#!/bin/bash
# create_users_groups.sh

echo "=== Création des utilisateurs et groupes ==="

# Création du groupe principal
sudo groupadd $GROUP
echo "Groupe $GROUP créé"

# Création des utilisateurs
for USER in $USER1 $USER2 $ADMIN_USER; do
    sudo useradd -m -s /bin/bash $USER
    echo "$USER:$PASSWORD" | sudo chpasswd
    echo "Utilisateur $USER créé"
done

# Ajout des utilisateurs au groupe
sudo usermod -a -G $GROUP $USER1
sudo usermod -a -G $GROUP $USER2
echo "Utilisateurs ajoutés au groupe $GROUP"
