#!/bin/bash
# create_test_content.sh

echo "=== Création du contenu de test ==="

# Fichier public
sudo tee /opt/$GROUP/public/readme.txt > /dev/null << EOF
Ce fichier est accessible à tous les utilisateurs.
Membres du groupe $GROUP peuvent modifier.
EOF

# Fichier secret
sudo tee /opt/$GROUP/private/$SECRET_FILE > /dev/null << EOF
🌟 INFORMATION SECRÈTE 🌟
Mot de passe admin: SuperSecret123!
Clé API: AKIAIOSFODNN7EXAMPLE
Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
EOF

# Fichier partagé
sudo tee /opt/$GROUP/shared/collaboration.txt > /dev/null << EOF
Fichier de collaboration du groupe $GROUP
$USER1 et $USER2 peuvent éditer ce fichier.
EOF

# Création de fichiers avec différentes permissions
sudo touch /opt/$GROUP/public/log_public.log
sudo touch /opt/$GROUP/shared/log_shared.log
sudo touch /opt/$GROUP/private/log_private.log

sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/public/log_public.log
sudo chown $ADMIN_USER:$GROUP /opt/$GROUP/shared/log_shared.log
sudo chown $ADMIN_USER:$ADMIN_USER /opt/$GROUP/private/log_private.log

sudo chmod 664 /opt/$GROUP/public/log_public.log
sudo chmod 664 /opt/$GROUP/shared/log_shared.log
sudo chmod 600 /opt/$GROUP/private/log_private.log

echo "Contenu de test créé"
