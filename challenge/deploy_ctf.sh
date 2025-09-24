#!/bin/bash
# ROOT-ME CTF: Script de déploiement principal

set -e

echo "🎌 Déploiement du CTF Linux Permissions Master..."
echo "⏰ Cette opération peut prendre quelques instants..."
sleep 2

# Vérification des prérequis
if [ "$EUID" -ne 0 ]; then
    echo "❌ Exécutez en tant que root: sudo $0"
    exit 1
fi

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Vérification des prérequis...${NC}"

# Installation des dépendances
echo -e "${YELLOW}📦 Installation des dépendances...${NC}"
apt-get update
apt-get install -y acl gcc

# Se positionner dans le dossier challenge
cd "$(dirname "$0")"

# Exécution des scripts de configuration
echo -e "${YELLOW}🔧 Configuration du challenge...${NC}"
chmod +x setup_challenge.sh secure_challenge.sh

./setup_challenge.sh
./secure_challenge.sh

# Copie des instructions
cp ctf_instructions.md /home/
chmod 644 /home/ctf_instructions.md

# Test de connexion
echo -e "${YELLOW}🔐 Test des connexions utilisateurs...${NC}"
if su - rootme_user1 -c "echo '✅ rootme_user1 OK'" && \
   su - rootme_user2 -c "echo '✅ rootme_user2 OK'" && \
   su - admin_user -c "echo '✅ admin_user OK'"; then
    echo -e "${GREEN}✅ Tous les utilisateurs sont accessibles!${NC}"
else
    echo -e "${RED}❌ Probleme avec les utilisateurs${NC}"
fi

echo -e "${GREEN}"
echo "╔══════════════════════════════════════════╗"
echo "║           CTF DÉPLOYÉ AVEC SUCCÈS!       ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GREEN}✅ Déploiement terminé!${NC}"
echo ""
echo -e "${YELLOW}📋 Informations importantes:${NC}"
echo "   • Instructions: /home/ctf_instructions.md"
echo "   • Arborescence: /ctf/"
echo "   • Utilisateurs: rootme_user1, rootme_user2, admin_user"
echo "   • Mot de passe: PASSWORD123"
echo ""
echo -e "${BLUE}🎯 Test de connexion:${NC}"
echo "   su - rootme_user1"
echo "   Mot de passe: PASSWORD123"
echo ""
echo -e "${RED}⚠️  Ne pas exécuter les scripts de solution!${NC}"
