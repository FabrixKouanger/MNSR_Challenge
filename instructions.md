# Exercice collaboratif : Challenge Gestion des utilisateurs, permissions et ACL

## Objectif
Décrypter des identifiants cachés et configurer un système de permissions sécurisé en ligne de commande.

### Mission complète
1. Décrypter les variables
2. Créer utilisateurs et groupes
3. Configurer les permissions de base
4. Créer du contenu de test
5. Configurer les ACL avancées

## Comment participer
Vous devez **forker votre repo GitHub** et **exécuter les commandes ligne par ligne** en suivant un guide interactif.

## Étapes du challenge
- Étape 1 : Décryptage des variables d'environnement
- Étape 2 : Création des utilisateurs et groupes  
- Étape 3 : Configuration des permissions
- Étape 4 : Mise en place des ACL
- Étape 5 : Validation finale

## Guide

Exécutez chaque commande manuellement.

---

## ÉTAPE 1 : Décryptage des variables d'environnement

### 1.1 Définition des variables cryptées
```bash
export USER1_CRYPT="cm9vdG1lX3VzZXIx"
export USER2_CRYPT="cm9vdG1lX3VzZXIy"
export GROUP_CRYPT="c2VjdXJpdHlfZ3Jw"
export ADMIN_CRYPT="YWRtaW5fdXNlcg=="
export SECRET_FILE_CRYPT="c2VjcmV0X2ZpbGUudHh0"
```

### 1.2 Décryptage avec base64
```bash
echo "Décryptage de USER1_CRYPT :"
echo $USER1_CRYPT | base64 -d
# Résultat : rootme_user1

echo "Décryptage de USER2_CRYPT :"  
echo $USER2_CRYPT | base64 -d
# Résultat : rootme_user2

echo "Décryptage de GROUP_CRYPT :"
echo $GROUP_CRYPT | base64 -d
# Résultat : security_grp

echo "Décryptage de ADMIN_CRYPT :"
echo $ADMIN_CRYPT | base64 -d
# Résultat : admin_user

echo "Décryptage de SECRET_FILE_CRYPT :"
echo $SECRET_FILE_CRYPT | base64 -d
# Résultat : secret_file.txt
```

### 1.3 Stockage dans des variables
```bash
USER1=$(echo $USER1_CRYPT | base64 -d)
USER2=$(echo $USER2_CRYPT | base64 -d) 
GROUP=$(echo $GROUP_CRYPT | base64 -d)
ADMIN_USER=$(echo $ADMIN_CRYPT | base64 -d)
SECRET_FILE=$(echo $SECRET_FILE_CRYPT | base64 -d)
PASSWORD="password123"

echo "Variables décryptées :"
echo "USER1: $USER1"
echo "USER2: $USER2"
echo "GROUP: $GROUP"
echo "ADMIN_USER: $ADMIN_USER"
echo "SECRET_FILE: $SECRET_FILE"
```

---

## ÉTAPE 2 : Création des utilisateurs et groupes

### 2.1 Création du groupe
```bash
echo "Création du groupe $GROUP :"
sudo groupadd $GROUP
# Vérification :
getent group $GROUP
```

### 2.2 Création des utilisateurs
```bash
echo "Création de l'utilisateur $USER1 :"
sudo useradd -m -s /bin/bash $USER1
echo "$USER1:$PASSWORD" | sudo chpasswd

echo "Création de l'utilisateur $USER2 :"
sudo useradd -m -s /bin/bash $USER2
echo "$USER2:$PASSWORD" | sudo chpasswd

echo "Création de l'utilisateur $ADMIN_USER :"
sudo useradd -m -s /bin/bash $ADMIN_USER
echo "$ADMIN_USER:$PASSWORD" | sudo chpasswd
```

### 2.3 Ajout des utilisateurs au groupe
```bash
echo "Ajout de $USER1 au groupe $GROUP :"
sudo usermod -a -G $GROUP $USER1

echo "Ajout de $USER2 au groupe $GROUP :"
sudo usermod -a -G $GROUP $USER2

# Vérifications :
echo "Vérification de $USER1 :"
id $USER1
groups $USER1

echo "Vérification de $USER2 :"
id $USER2  
groups $USER2

echo "Vérification de $ADMIN_USER :"
id $ADMIN_USER
```

---

## ÉTAPE 3 : Configuration des permissions de base

### 3.1 Création de l'arborescence
```bash
echo "Création de l'arborescence dans /opt/$GROUP :"
sudo mkdir -p /opt/$GROUP/public
sudo mkdir -p /opt/$GROUP/private
sudo mkdir -p /opt/$GROUP/shared

# Vérification :
ls -la /opt/$GROUP/
```

### 3.2 Configuration des propriétaires et permissions
```bash
echo "Configuration du dossier racine :"
sudo chown root:$GROUP /opt/$GROUP
sudo chmod 755 /opt/$GROUP

echo "Configuration du dossier public :"
sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/public
sudo chmod 775 /opt/$GROUP/public

echo "Configuration du dossier private :"
sudo chown $ADMIN_USER:$ADMIN_USER /opt/$GROUP/private
sudo chmod 700 /opt/$GROUP/private

echo "Configuration du dossier shared :"
sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/shared
sudo chmod 770 /opt/$GROUP/shared

# Vérification détaillée :
echo "Vérification des permissions :"
ls -la /opt/$GROUP/
```

### 3.3 Explication des permissions
```bash
echo "Explication des permissions :"
echo "755 : rwxr-xr-x - Propriétaire (rwx), Groupe (r-x), Others (r-x)"
echo "775 : rwxrwxr-x - Propriétaire et Groupe (rwx), Others (r-x)" 
echo "700 : rwx------ - Uniquement le propriétaire"
echo "770 : rwxrwx--- - Propriétaire et Groupe uniquement"
```

---

## ÉTAPE 4 : Création du contenu de test

### 4.1 Création des fichiers
```bash
echo "Création du fichier public :"
sudo tee /opt/$GROUP/public/readme.txt > /dev/null << EOF
Ce fichier est accessible à tous les utilisateurs.
Les membres du groupe $GROUP peuvent le modifier.
EOF

echo "Création du fichier secret :"
sudo tee /opt/$GROUP/private/$SECRET_FILE > /dev/null << EOF
* INFORMATIONS CONFIDENTIELLES *
Utilisateur: super_admin
Mot de passe: TrèsSecret123!
Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
EOF

echo "Création du fichier de collaboration :"
sudo tee /opt/$GROUP/shared/collaboration.txt > /dev/null << EOF
Fichier de collaboration du groupe $GROUP
- $USER1 : accès lecture
- $USER2 : accès lecture/écriture
- $ADMIN_USER : accès complet
EOF
```

### 4.2 Création de fichiers de logs de test
```bash
echo "Création des fichiers de logs :"
sudo touch /opt/$GROUP/public/access.log
sudo touch /opt/$GROUP/shared/operations.log
sudo touch /opt/$GROUP/private/audit.log

# Configuration des permissions sur les logs :
sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/public/access.log
sudo chmod 664 /opt/$GROUP/public/access.log

sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/shared/operations.log  
sudo chmod 664 /opt/$GROUP/shared/operations.log

sudo chown $ADMIN_USER:$ADMIN_USER /opt/$GROUP/private/audit.log
sudo chmod 600 /opt/$GROUP/private/audit.log

# Vérification finale :
echo "Arborescence finale :"
tree /opt/$GROUP/ || find /opt/$GROUP/ -type f -ls
```

---

## ÉTAPE 5 : Configuration des ACL avancées

### 5.1 Vérification de l'installation d'ACL
```bash
echo "Vérification des outils ACL :"
which setfacl || sudo apt-get install -y acl
```

### 5.2 Configuration des ACL sur le dossier shared
```bash
echo "Configuration ACL pour $USER1 sur /shared :"
sudo setfacl -m u:$USER1:r-x /opt/$GROUP/shared
# → $USER1 peut lire et exécuter (traverser) mais pas écrire

echo "Configuration ACL pour $USER2 sur /shared :"
sudo setfacl -m u:$USER2:rwx /opt/$GROUP/shared
# → $USER2 a tous les droits

echo "ACL par défaut pour nouveaux fichiers dans /shared :"
sudo setfacl -d -m u:$USER1:r-x /opt/$GROUP/shared
sudo setfacl -d -m u:$USER2:rwx /opt/$GROUP/shared
sudo setfacl -d -m g:$GROUP:rwx /opt/$GROUP/shared
```

### 5.3 ACL sur le fichier secret
```bash
echo "ACL spéciale sur le fichier secret pour $USER1 :"
sudo setfacl -m u:$USER1:r-- /opt/$GROUP/private/$SECRET_FILE
# → $USER1 peut seulement lire le fichier secret
```

### 5.4 Vérification des ACL
```bash
echo "Vérification des ACL sur /shared :"
getfacl /opt/$GROUP/shared

echo "Vérification des ACL sur le fichier secret :"
getfacl /opt/$GROUP/private/$SECRET_FILE
```

---

## ÉTAPE 6 : Tests et validation

### 6.1 Tests d'accès pour $USER1
```bash
echo "=== TESTS $USER1 ==="

echo "Test lecture dossier shared :"
sudo su - $USER1 -c "ls -la /opt/$GROUP/shared/"

echo "Test écriture dossier shared (doit échouer) :"
sudo su - $USER1 -c "echo 'test $USER1' >> /opt/$GROUP/shared/collaboration.txt"

echo "Test lecture fichier secret :"
sudo su - $USER1 -c "cat /opt/$GROUP/private/$SECRET_FILE"
```

### 6.2 Tests d'accès pour $USER2
```bash
echo "=== TESTS $USER2 ==="

echo "Test écriture dossier shared :"
sudo su - $USER2 -c "echo 'Modification par $USER2' >> /opt/$GROUP/shared/collaboration.txt"

echo "Vérification de l'écriture :"
sudo su - $USER2 -c "tail -2 /opt/$GROUP/shared/collaboration.txt"
```

### 6.3 Tests d'accès pour $ADMIN_USER
```bash
echo "=== TESTS $ADMIN_USER ==="

echo "Test accès complet :"
sudo su - $ADMIN_USER -c "ls -la /opt/$GROUP/private/"
sudo su - $ADMIN_USER -c "cat /opt/$GROUP/private/$SECRET_FILE"
```

### 6.4 Vérification finale des permissions
```bash
echo "=== RAPPORT FINAL ==="

echo "1. Structure des permissions :"
ls -la /opt/$GROUP/

echo "2. Appartenance aux groupes :"
for user in $USER1 $USER2 $ADMIN_USER; do
    echo "   $user : $(groups $user)"
done

echo "3. Résumé des ACL :"
getfacl /opt/$GROUP/shared | grep -E "(user:|group:)"

echo "4. Test de sécurité :"
echo "   $USER1 ne peut pas modifier /shared → Sécurité renforcée"
echo "   $USER2 peut collaborer → Fonctionnalité préservée"
echo "   $ADMIN_USER a le contrôle total → Administration maintenue"
```

---

## Bilan de compétences démontrées

✅ **Décryptage variables** : Maîtrise de base64 et variables env  
✅ **Gestion users/groups** : useradd, usermod, groupadd, chpasswd  
✅ **Permissions basiques** : chmod, chown, compréhension des masks  
✅ **Création contenu** : arborescence, fichiers de test  
✅ **ACL avancées** : setfacl, getfacl, permissions granulaires  
✅ **Tests validation** : vérification complète des accès  
