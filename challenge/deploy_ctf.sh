
```bash
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
apt-get update > /dev/null 2>&1
apt-get install -y acl gcc > /dev/null 2>&1

# Exécution des scripts de configuration
echo -e "${YELLOW}🔧 Configuration du challenge...${NC}"
chmod +x setup_challenge.sh secure_challenge.sh

./setup_challenge.sh
./secure_challenge.sh

# Copie des instructions
cp ctf_instructions.md /home/
chmod 644 /home/ctf_instructions.md

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
echo -e "${BLUE}🎯 Les participants peuvent maintenant commencer!${NC}"
echo -e "${RED}⚠️  Ne pas exécuter les scripts de solution!${NC}"
