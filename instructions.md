# Exercice collaboratif : Challenge Gestion des utilisateurs, permissions et ACL

## 🎯 Objectif
Décrypter des identifiants cachés et configurer un système de permissions sécurisé en ligne de commande.

### Mission complète
1. Décrypter les variables
2. Créer utilisateurs et groupes
3. Configurer les permissions de base
4. Créer du contenu de test
5. Configurer les ACL avancées

## Comment participer
Vous devez **forker votre repo GitHub** et **exécuter les commandes ligne par ligne** en suivant un guide interactif.

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
