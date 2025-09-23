# Exercice collaboratif : Challenge Gestion des utilisateurs, permissions et ACL

## 🎯 Concept final

Vous devez **forker votre repo GitHub** et **exécuter les commandes ligne par ligne** en suivant un guide interactif.

## Structure du repository GitHub

### 1. Organisation du repo
```
MNSR_TP_Challenge/
│
├── README.md                 # Instructions principales
├── instructions.md           # Guide étape par étape
├── verification.sh           # Script de vérification final
├── solutions/               # Dossier des solutions (caché)
│   └── solutions.md         # Commandes solutions
└── hints/                   # Indices si bloqué
    ├── etape1.md
    ├── etape2.md
    └── etape3.md
```

## 📁 Contenu des fichiers

### `README.md`
```markdown
# 🔐 Challenge Root-Me : Gestion des Utilisateurs et Permissions

## Objectif
Décrypter des identifiants cachés et configurer un système de permissions sécurisé.

## 🚀 Comment participer

1. **Forkez ce repo**
```bash
git clone https://github.com/FabrixKouanger/MNSR_Challenge
cd MNSR_Challenge
```

2. **Suivez le guide interactif**
```bash
cat instructions.md
```

3. **Exécutez les commandes ligne par ligne**

## 📋 Étapes du challenge
- Étape 1 : Décryptage des variables d'environnement
- Étape 2 : Création des utilisateurs et groupes  
- Étape 3 : Configuration des permissions
- Étape 4 : Mise en place des ACL
- Étape 5 : Validation finale

## 🆘 Si vous êtes bloqué
Consultez le dossier `hints/` pour des indices progressifs.
```

### `instructions.md`
```markdown
# 🔍 Instructions du Challenge

## ÉTAPE 1 : Décryptage des identifiants

### 1.1 Exporter les variables cryptées
```bash
export USER1_CRYPT="cm9vdG1lX3VzZXIx"
export USER2_CRYPT="cm9vdG1lX3VzZXIy"
export GROUP_CRYPT="c2VjdXJpdHlfZ3Jw"
export SECRET_FILE="c2VjcmV0X2RhdGEudHh0"
```

### 1.2 Décrypter avec base64
**Question** : Quelle commande permet de décoder base64 ?

**À vous de jouer** : Décryptez chaque variable
```bash
echo "$USER1_CRYPT" | ______
echo "$USER2_CRYPT" | ______
# ... etc
```

### 1.3 Stocker les résultats
```bash
USER1=$(echo "$USER1_CRYPT" | base64 -d)
USER2=$(echo "$USER2_CRYPT" | base64 -d)
GROUP=$(echo "$GROUP_CRYPT" | base64 -d)
SECRET_FILE_NAME=$(echo "$SECRET_FILE" | base64 -d)
```

## ÉTAPE 2 : Création des utilisateurs et groupes

### 2.1 Créer le groupe principal
**Question** : Quelle commande crée un nouveau groupe Linux ?

```bash
sudo ______ $GROUP
```

### 2.2 Créer les utilisateurs
**À vous de jouer** : Créez les utilisateurs avec home directory et shell bash
```bash
sudo useradd -m -s /bin/bash $USER1
sudo ______ -m -s /bin/bash $USER2
```

### 2.3 Définir les mots de passe
```bash
echo "$USER1:password123" | sudo chpasswd
echo "$USER2:______" | sudo chpasswd
```

### 2.4 Ajouter au groupe
```bash
sudo usermod -a -G $GROUP $USER1
sudo ______ -a -G ______ $USER2
```

## ÉTAPE 3 : Configuration des permissions

### 3.1 Créer l'arborescence
```bash
sudo mkdir -p /opt/challenge/{public,private,shared}
```

### 3.2 Configurer les propriétaires
**À vous de jouer** : Configurez les permissions suivantes :
- `/opt/challenge/` : root:group (755)
- `public/` : user1:group (775)  
- `private/` : user1:user1 (700)
- `shared/` : user1:group (770)

```bash
sudo chown root:$GROUP /opt/challenge
sudo chmod 755 /opt/challenge

sudo chown $USER1:$GROUP /opt/challenge/public
sudo ______ 775 /opt/challenge/public

# ... à compléter
```

## ÉTAPE 4 : ACL Avancées

### 4.1 Installer ACL si nécessaire
```bash
sudo apt-get update && sudo apt-get install -y acl
```

### 4.2 Configurer les ACL
**À vous de jouer** : Donnez les accès suivants :
- user1 : lecture seule sur shared
- user2 : lecture/écriture sur shared

```bash
sudo setfacl -m u:$USER1:r-x /opt/challenge/shared
sudo ______ -m u:$USER2:rwx /opt/challenge/shared
```

## ÉTAPE 5 : Validation

### 5.1 Tester les accès
```bash
sudo su - $USER1 -c "ls -la /opt/challenge/shared"
```

### 5.2 Lancer le script de vérification
```bash
./verification.sh
```

🎉 **Félicitations si tout est vert !**
```

### `verification.sh`
```bash
#!/bin/bash
# Script de vérification finale

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== VÉRIFICATION DU CHALLENGE ===${NC}"

# Vérification des variables
if [ -z "$USER1" ] || [ -z "$GROUP" ]; then
    echo -e "${RED}❌ Variables non définies${NC}"
    exit 1
fi

# Test 1: Utilisateurs existent
echo -n "1. Utilisateurs existent: "
if id "$USER1" &>/dev/null && id "$USER2" &>/dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

# Test 2: Groupe existe
echo -n "2. Groupe existe: "
if getent group "$GROUP" &>/dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

# Test 3: Arborescence
echo -n "3. Arborescence créée: "
if [ -d "/opt/challenge/shared" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

# Test 4: Permissions
echo -n "4. Permissions correctes: "
if [ "$(stat -c %a /opt/challenge/shared)" = "770" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

# Test 5: ACL
echo -n "5. ACL configurées: "
if getfacl /opt/challenge/shared 2>/dev/null | grep -q "$USER1"; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

echo -e "${YELLOW}=== RÉSULTAT FINAL ===${NC}"
```

### `hints/etape1.md`
```markdown
# 💡 Indice Étape 1 : Décryptage

## Commande base64
La commande pour décoder base64 est : `base64 -d`

## Exemple
```bash
echo "dGVzdA==" | base64 -d
# Retourne: test
```

## Solution partielle
```bash
USER1=$(echo "cm9vdG1lX3VzZXIx" | base64 -d)
# USER1 = rootme_user1
```
```

## 🎤 Script d'animation pour vous

### `animate_demo.sh`
```bash
#!/bin/bash
# Script pour animer la démo en direct

echo "🎯 DEMO CHALLENGE"
echo "========================="

echo ""
echo "1. Montrez votre repo GitHub:"
echo "   https://github.com/FabrixKouanger/MNSR_Challenge"
echo ""
echo "2. Demandez aux camarades de:"
echo "   - Forker le repo"
echo "   - Cloner leur fork"
echo "   - Lire le README.md"
echo ""
echo "3. Guidez-les étape par étape:"
echo "   'Maintenant, ouvrez instructions.md'"
echo "   'Exécutez la première commande...'"
echo "   'Que remarquez-vous ?'"
echo ""
echo "4. Interactions possibles:"
echo "   'Quelle commande manque ici ?'"
echo "   'Pourquoi utilise-t-on sudo ?'"
echo "   'Quelle différence entre chmod et setfacl ?'"
echo ""
echo "5. Validation finale:"
echo "   'Lancez ./verification.sh pour voir votre score!'"
echo ""
```

## 🚀 Déroulé type de la session

### **Préparation (vous)**
```bash
# Pousser tout sur GitHub
git add .
git commit -m "Challenge Root-Me complet"
git push origin main

# Tester le flux participant
git clone https://github.com/FabrixKouanger/MNSR_Challenge
cd MNSR_Challenge
cat instructions.md
```

### **Animation en direct (20-30 minutes)**

**Minute 0-5** : 
- "Allez sur mon GitHub, forkez et clonez le repo"
- "Ouvrez le README.md et suivez les instructions"

**Minute 5-15** : 
- "Étape 1 : Décryptage des variables"
- "Quelle commande base64 ? Essayez !"
- "Vérifiez avec echo $USER1"

**Minute 15-25** :
- "Étape 2-3 : Création users et permissions"
- "Utilisez useradd, chown, chmod"
- "Testez avec ls -la"

**Minute 25-30** :
- "Étape 4 : ACL avancées"
- "Étape 5 : Validation finale"
- "Lancez ./verification.sh"

## ✅ Avantages de cette approche

- **Interactif** : Les camarades écrivent vraiment les commandes
- **Pédagogique** : Apprentissage progressif avec indices
- **GitHub intégré** : Utilisation professionnelle de Git
- **Auto-évaluation** : Script de vérification inclus
- **Réutilisable** : Ils peuvent refaire chez eux

## 🎉 Conclusion

Avec cette structure, vos camarades vivront une véritable expérience Root-Me en collaborant via GitHub et en apprenant ligne par ligne ! 

**Votre rôle** : Guidez, posez des questions, aidez quand ils bloquent. 

**Leur rôle** : Découvrir, expérimenter, apprendre en pratiquant. 

Parfait pour une séance TP engageante ! 🚀
