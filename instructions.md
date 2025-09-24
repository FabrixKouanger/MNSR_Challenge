# Challenge Root-Me CTF : "Linux Permissions Master"

## Énoncé du CTF

**Nom du challenge:** `Linux Permissions Master`  
**Catégorie:** Système  
**Difficulté:** Facile  
**Points:** 100 points

### Scénario
```
Vous êtes un stagiaire en cybersécurité. Votre responsable a quitté l'entreprise brutalement
en laissant des comptes utilisateurs avec des mots de passe cryptés. Votre mission est de
retrouver l'accès au système et de trouver le flag caché dans les fichiers sensibles.

Attention: Des mécanismes de protection (ACL, permissions spéciales) ont été mis en place!
```

## Étape 1: Décryptage des identifiants

### Fichier: `credentials.enc`
```
USER1_CRYPT="cm9vdG1lX3VzZXIx"
USER2_CRYPT="cm9vdG1lX3VzZXIy"  
ADMIN_CRYPT="YWRtaW5fdXNlcg=="
GROUP_CRYPT="c2VjdXJpdHlfZ3Jw"
PASSWORD_CRYPT="UEFTU3dvcmQxMjM="
SECRET_FILE_CRYPT="ZmxhZ190ZXN0LnR4dA=="
HINT_CRYPT="U1VJRCBzZXR0aW5nIGlzIGtleQ=="
```

**Mission:** Décrypter ces identifiants en base64 pour obtenir les noms réels.

## Étape 2: Reconstruction de l'environnement

### Script de création: `setup_challenge.sh`
```bash
#!/bin/bash
# ROOT-ME CTF: Linux Permissions Master

echo "Initialisation du challenge..."
sleep 2

# Décryptage
decrypt() { echo "$1" | base64 -d 2>/dev/null; }

USER1=$(decrypt "cm9vdG1lX3VzZXIx")
USER2=$(decrypt "cm9vdG1lX3VzZXIy")
ADMIN_USER=$(decrypt "YWRtaW5fdXNlcg==")
GROUP=$(decrypt "c2VjdXJpdHlfZ3Jw")
PASSWORD=$(decrypt "UEFTU3dvcmQxMjM=")
SECRET_FILE=$(decrypt "ZmxhZ190ZXN0LnR4dA==")
HINT=$(decrypt "U1VJRCBzZXR0aW5nIGlzIGtleQ==")

echo "Identifiants décryptés!"
echo "   Utilisateurs: $USER1, $USER2, $ADMIN_USER"
echo "   Groupe: $GROUP"
echo "   Fichier secret: $SECRET_FILE"
echo "   Indice: $HINT"

# Création des utilisateurs
echo "Création des comptes utilisateurs..."
for user in $USER1 $USER2 $ADMIN_USER; do
    sudo useradd -m -s /bin/bash $user 2>/dev/null
    echo "$user:$PASSWORD" | sudo chpasswd
done

# Création du groupe
sudo groupadd $GROUP 2>/dev/null
sudo usermod -aG $GROUP $USER1
sudo usermod -aG $GROUP $USER2

# Création de l'arborescence du challenge
echo "Création de l'environnement du CTF..."
sudo mkdir -p /ctf/{public,private,restricted,binaries}
sudo mkdir -p /home/$ADMIN_USER/.secret_config

# Fichier avec le flag (mais protégé)
sudo tee /ctf/private/$SECRET_FILE > /dev/null << EOF
BRAVO! Vous avez trouvé le flag principal!
FLAG: RM{linux_permissions_master_001}

Mais attention, ce n'est pas le vrai flag...
Le vrai flag est caché ailleurs avec des permissions spéciales!
EOF

# Faux flag pour tromper
sudo tee /ctf/public/fake_flag.txt > /dev/null << EOF
FLAG: RM{fake_flag_do_not_submit}
EOF

# Fichier avec indice réel
sudo tee /ctf/restricted/hint.txt > /dev/null << EOF
Indice: Vérifiez les binaires avec bit SUID...
Certains programmes peuvent s'exécuter avec des privilèges élevés!
EOF

# Binaire SUID qui contient le vrai flag
sudo tee /tmp/create_flag.c > /dev/null << 'EOF'
#include <stdio.h>
#include <stdlib.h>

int main() {
    system("echo 'Vrai flag: RM{suid_bit_escalation_1337}' > /ctf/private/real_flag.txt");
    system("chmod 600 /ctf/private/real_flag.txt");
    printf("Flag créé! Mais pouvez-vous le lire?\n");
    return 0;
}
EOF

sudo gcc /tmp/create_flag.c -o /ctf/binaries/create_flag
sudo rm /tmp/create_flag.c

echo "Challenge configuré! Bonne chance!"
```

## Étape 3: Configuration des protections avancées

### Script de sécurisation: `secure_challenge.sh`
```bash
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
```

## Étape 4: Script de vérification pour les participants

### Fichier: `ctf_instructions.md`
```markdown
# Challenge Root-Me: Linux Permissions Master

## Objectif
Trouvez le vrai flag caché dans le système!

## Accès initial
- **Utilisateurs disponibles:** rootme_user1, rootme_user2, admin_user
- **Mot de passe:** PASSWORD123 (pour tous)
- **Groupe:** security_grp

## Indices
1. Certains fichiers ont des permissions spéciales
2. Les ACL peuvent restreindre l'accès
3. Les bits SUID peuvent être exploités
4. Ne faites pas confiance aux apparences!

## Commandes utiles
```bash
# Connexion aux utilisateurs
su - rootme_user1
su - rootme_user2

# Analyse des permissions
ls -la /ctf
getfacl /ctf/restricted
find /ctf -perm -4000  # Fichiers SUID

# Test d'accès
cat /ctf/private/flag_test.txt
/ctf/binaries/create_flag
```

## Validation
Le flag valide commence par `RM{` et se termine par `}`

Soumettez-le sur la plateforme Root-Me!
```
```
## Étape 5: Solution attendue

### Script de solution: `solution_walkthrough.sh`

```bash
#!/bin/bash
echo "Solution du CTF Linux Permissions Master"

# Étape 1: Décryptage
echo "1. Décryptage des identifiants:"
echo "rootme_user1:$(echo "cm9vdG1lX3VzZXIx" | base64 -d)"
echo "rootme_user2:$(echo "cm9vdG1lX3VzZXIy" | base64 -d)" 
echo "admin_user:$(echo "YWRtaW5fdXNlcg==" | base64 -d)"
echo "security_grp:$(echo "c2VjdXJpdHlfZ3Jw" | base64 -d)"
echo "flag_test.txt:$(echo "ZmxhZ190ZXN0LnR4dA==" | base64 -d)"

# Étape 2: Connexion et exploration
echo -e "\n2. Exploration de l'environnement:"
echo "su - rootme_user1"
echo "ls -la /ctf"

# Étape 3: Exploitation des ACL
echo -e "\n3. Exploitation des permissions:"
echo "getfacl /ctf/restricted"
echo "cat /ctf/restricted/hint.txt"

# Étape 4: Exploitation du SUID (CORE)
echo -e "\n4. Exploitation du binaire SUID:"
echo "find /ctf -perm -4000"
echo "/ctf/binaries/create_flag"
echo "cat /ctf/private/real_flag.txt"

# Étape 5: Flag final
echo -e "\n5. FLAG FINAL:"
echo "RM{suid_bit_escalation_1337}"
```

## Étape 6: Script de déploiement complet

### Fichier: `deploy_ctf.sh`
```bash
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
```

## 🏁 Résumé du CTF

### Mécaniques impliquées:
- ✅ **Décryptage base64** (variables d'environnement)
- ✅ **Gestion utilisateurs/groupes** 
- ✅ **Permissions Linux basiques** (chmod/chown)
- ✅ **ACL avancées** (setfacl/getfacl)
- ✅ **Exploitation SUID** (core du challenge)
- ✅ **Recherche d'information** (find, ls, cat)

### Flags à trouver:
1. **Faux flag:** `RM{fake_flag_do_not_submit}`
2. **Leurre:** `RM{linux_permissions_master_001}`  
3. **Vrai flag:** `RM{suid_bit_escalation_1337}`
