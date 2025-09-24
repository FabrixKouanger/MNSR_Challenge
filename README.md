```markdown
# 🚀 CTF Root-Me : Linux Permissions Master

## 📋 Description
**Catégorie:** Système  
**Difficulté:** Facile (100 points)  
**Auteur:** Votre Équipe

## 🎯 Scénario
```
Vous êtes un stagiaire en cybersécurité. Votre responsable a quitté l'entreprise brutalement
en laissant des comptes utilisateurs avec des mots de passe cryptés. Retrouvez l'accès au système
et trouvez le flag caché dans les fichiers sensibles.

⚠️ Attention: Des mécanismes de protection (ACL, permissions spéciales) ont été mis en place!
```

## 🚀 Déploiement

### Prérequis
- Machine Linux (Ubuntu/Debian)
- Accès root
- Connexion internet

### Installation rapide
```bash
chmod +x challenge/deploy_ctf.sh
sudo challenge/deploy_ctf.sh
```

### Installation manuelle
```bash
cd challenge/
sudo chmod +x *.sh
sudo ./deploy_ctf.sh
```

## 🔧 Ce qui est installé
- 3 utilisateurs avec mots de passe cryptés
- Arborescence /ctf/ avec différents niveaux d'accès
- Système de permissions avancées (ACL, SUID)
- Fichiers avec flags multiples

## 🎮 Comment jouer
1. Se connecter avec les identifiants décryptés
2. Explorer l'arborescence /ctf/
3. Comprendre les mécanismes de permissions
4. Trouver le vrai flag caché

## 📜 Fichiers fournis
- `deploy_ctf.sh` - Script de déploiement principal
- `setup_challenge.sh` - Configuration de l'environnement
- `secure_challenge.sh` - Mise en place des protections
- `credentials.enc` - Identifiants cryptés
- `ctf_instructions.md` - Guide participant

## ✅ Validation
Le flag valide commence par `RM{` et se termine par `}`

**Bon courage! 🏴‍☠️**
