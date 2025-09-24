# 🎯 Instructions du CTF - Linux Permissions Master

## 🔐 Accès initial
**Utilisateurs disponibles:**
- rootme_user1
- rootme_user2  
- admin_user

**Mot de passe commun:** `PASSWORD123`

**Groupe:** security_grp

## 🎯 Objectif
Trouvez le **vrai flag** caché dans le système!

## 💡 Indices de départ
1. Certains fichiers ont des permissions spéciales
2. Les ACL peuvent restreindre l'accès différemment selon les utilisateurs
3. Les bits SUID permettent l'exécution avec des privilèges élevés
4. Ne faites pas confiance aux premiers flags trouvés!

## 🔍 Commandes utiles
```bash
# Connexion aux utilisateurs
su - rootme_user1
su - rootme_user2

# Analyse des permissions
ls -la /ctf
getfacl /ctf/restricted
find /ctf -perm -4000 2>/dev/null

# Test d'accès
cat /ctf/public/fake_flag.txt
/ctf/binaries/create_flag
