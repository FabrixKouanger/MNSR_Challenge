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
