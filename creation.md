# Méthodologie de création du CTF

## Objectifs pédagogiques
- Comprendre les permissions Linux basiques
- Maîtriser les ACL avancées
- Exploiter les bits SUID
- Analyser la sécurité système

## Architecture technique

### 1. Structure des permissions
```bash
/ctf/
├── public/ (775) - Accès groupe
├── private/ (700) - Admin seulement
├── restricted/ (750+ACL) - Accès différencié
└── binaries/ (4755) - SUID activé
```

### 2. Mécanismes de sécurité implémentés
- **Permissions basiques** (chmod/chown)
- **ACL** (setfacl/getfacl) 
- **SUID** (élévation de privilèges)
- **Décryptage base64** (introduction)

### 3. Éléments de difficulté progressive
1. Décryptage simple ✅
2. Exploration basique ✅  
3. Analyse permissions ✅
4. Exploitation SUID ✅

## Tests de validation
- [x] Accès différencié par utilisateur
- [x] Exploitation SUID fonctionnelle
- [x] Flags multiples (leurres + réel)
- [x] Solution claire et reproductible

