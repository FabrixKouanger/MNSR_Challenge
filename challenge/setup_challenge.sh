#!/bin/bash
# Configuration de l'environnement du CTF

echo "🔧 Initialisation du challenge Linux Permissions Master..."
sleep 1

# Fonction de décryptage
decrypt() { 
    echo "$1" | base64 -d 2>/dev/null 
}

# Décryptage des identifiants
USER1=$(decrypt "cm9vdG1lX3VzZXIx")
USER2=$(decrypt "cm9vdG1lX3VzZXIy")
ADMIN_USER=$(decrypt "YWRtaW5fdXNlcg==")
GROUP=$(decrypt "c2VjdXJpdHlfZ3Jw")
PASSWORD=$(decrypt "UEFTU3dvcmQxMjM=")
SECRET_FILE=$(decrypt "ZmxhZ190ZXN0LnR4dA==")

echo "🎯 Identifiants décryptés:"
echo "   • Utilisateurs: $USER1, $USER2, $ADMIN_USER"
echo "   • Groupe: $GROUP"
echo "   • Fichier secret: $SECRET_FILE"

# Création des utilisateurs
echo "👥 Création des comptes utilisateurs..."
for user in $USER1 $USER2 $ADMIN_USER; do
    if id "$user" &>/dev/null; then
        echo "   ℹ️  Utilisateur $user existe déjà"
    else
        useradd -m -s /bin/bash "$user" 2>/dev/null
        echo "$user:$PASSWORD" | chpasswd
        echo "   ✅ $user créé"
    fi
done

# Création du groupe
if getent group "$GROUP" >/dev/null; then
    echo "   ℹ️  Groupe $GROUP existe déjà"
else
    groupadd "$GROUP"
    echo "   ✅ Groupe $GROUP créé"
fi

# Ajout au groupe
usermod -aG "$GROUP" "$USER1"
usermod -aG "$GROUP" "$USER2"
echo "   ✅ Utilisateurs ajoutés au groupe $GROUP"

# Création de l'arborescence
echo "📁 Création de l'environnement /ctf/..."
mkdir -p /ctf/{public,private,restricted,binaries}
mkdir -p /home/$ADMIN_USER/.secret_config

# Fichiers avec flags
echo "📝 Création des fichiers de challenge..."

# Faux flag public
tee /ctf/public/fake_flag.txt > /dev/null << EOF
Félicitations! Mais ce n'est pas le vrai flag...
FLAG: RM{fake_flag_do_not_submit_123}

Indice: Les apparences sont parfois trompeuses!
EOF

# Flag leurre
tee /ctf/private/$SECRET_FILE > /dev/null << EOF
BRAVO! Vous avez trouvé un flag... mais pas le vrai!
FLAG: RM{linux_permissions_master_001}

Le vrai flag nécessite une élévation de privilèges.
Cherchez les binaires avec des permissions spéciales!
EOF

# Indice important
tee /ctf/restricted/hint.txt > /dev/null << EOF
💡 INDICE IMPORTANT 💡

Certains programmes s'exécutent avec les permissions de leur propriétaire.
Utilisez: find / -perm -4000 2>/dev/null

Le binaire /ctf/binaries/create_flag peut vous aider...
Mais qui peut l'exécuter? Et avec quels privilèges?
EOF

# Binaire SUID (core du challenge)
tee /tmp/create_flag.c > /dev/null << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    if (setuid(0) == 0) {
        system("echo 'Vrai flag: RM{suid_bit_escalation_1337}' > /ctf/private/real_flag.txt");
        system("chown admin_user:admin_user /ctf/private/real_flag.txt");
        system("chmod 600 /ctf/private/real_flag.txt");
        printf("Flag créé! Maintenant, trouvez comment le lire...\n");
    } else {
        printf("Échec de l'élévation de privilèges.\n");
    }
    return 0;
}
EOF

gcc /tmp/create_flag.c -o /ctf/binaries/create_flag
rm /tmp/create_flag.c

# Script piégé
tee /ctf/binaries/check_permissions.sh > /dev/null << 'EOF'
#!/bin/bash
echo "🔍 Analyse des permissions en cours..."
echo "FLAG: RM{script_trap_do_not_trust_456}"
echo "💡 Indice: Méfiez-vous des scripts qui affichent des flags trop facilement!"
EOF

chmod +x /ctf/binaries/check_permissions.sh

echo "✅ Configuration de base terminée!"
