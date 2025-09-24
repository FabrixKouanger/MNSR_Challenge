#!/bin/bash
# Déploiement automatique du CTF

echo "Déploiement du CTF Root-Me..."

# Vérification des prérequis
if [ "$EUID" -ne 0 ]; then
    echo "Exécutez en tant que root!"
    exit 1
fi

# Installation des dépendances
apt-get update
apt-get install -y acl gcc

# Exécution des scripts
echo "Configuration du challenge..."
./setup_challenge.sh
./secure_challenge.sh

# Création du fichier d'instructions
cp ctf_instructions.md /home/

# Sécurisation finale
chmod 700 solution_walkthrough.sh
echo "CTF déployé avec succès!"
echo "Instructions: /home/ctf_instructions.md"
echo "Bonne chance aux participants!"
