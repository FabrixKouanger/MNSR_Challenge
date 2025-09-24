# Vérifier les permissions
ls -la /opt/security_grp/

# Vérifier les ACL
getfacl /opt/security_grp/shared
getfacl /opt/security_grp/private/secret_file.txt

# Tester les accès
sudo su - rootme_user1 -c "ls -la /opt/security_grp/shared"
sudo su - rootme_user2 -c "echo 'test' >> /opt/security_grp/shared/collaboration.txt"

# Vérifier l'appartenance aux groupes
groups rootme_user1
groups rootme_user2
id admin_user
