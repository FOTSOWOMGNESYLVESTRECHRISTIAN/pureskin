# Docker - PureSkin Étudiant

Ce guide explique comment déployer l'application PureSkin Étudiant avec Docker et Docker Compose.

## 📋 Prérequis

- Docker Desktop installé
- Docker Compose (inclus dans Docker Desktop)

## 🚀 Démarrage rapide

### 1. Lancer tous les services

```bash
docker-compose up -d
```

Cette commande va:
- Créer et démarrer la base de données PostgreSQL
- Builder et démarrer le backend Spring Boot
- Builder et démarrer le frontend Next.js

### 2. Vérifier le déploiement

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **Base de données**: localhost:5432

### 3. Arrêter les services

```bash
docker-compose down
```

## 📁 Structure des fichiers

```
pureskin-etudiant/
├── backend/
│   ├── Dockerfile          # Configuration Docker du backend
│   ├── .dockerignore       # Fichiers à ignorer dans Docker
│   └── src/               # Code source Spring Boot
├── frontend/
│   ├── Dockerfile          # Configuration Docker du frontend
│   ├── .dockerignore       # Fichiers à ignorer dans Docker
│   └── src/               # Code source Next.js
├── docker-compose.yml      # Configuration de l'orchestration
├── init.sql              # Script d'initialisation PostgreSQL
└── DOCKER_README.md      # Ce fichier
```

## 🔧 Configuration

### Base de données PostgreSQL

- **Nom de la base**: `pureSkin`
- **Utilisateur**: `postgres`
- **Mot de passe**: `root`
- **Port**: `5432`

### Variables d'environnement

#### Backend
- `SPRING_DATASOURCE_URL`: URL de connexion PostgreSQL
- `SPRING_DATASOURCE_USERNAME`: Utilisateur PostgreSQL
- `SPRING_DATASOURCE_PASSWORD`: Mot de passe PostgreSQL
- `SPRING_WEB_CORS_ALLOWED_ORIGINS`: Origines CORS autorisées

#### Frontend
- `NEXT_PUBLIC_API_URL`: URL de l'API backend
- `PORT`: Port du frontend (3000)
- `HOSTNAME`: Hôte d'écoute (0.0.0.0)

## 🛠️ Commandes utiles

### Voir les logs
```bash
# Tous les services
docker-compose logs -f

# Service spécifique
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

### Reconstruire une image
```bash
# Reconstruire le backend
docker-compose build --no-cache backend

# Reconstruire le frontend
docker-compose build --no-cache frontend

# Reconstruire tout
docker-compose build --no-cache
```

### Accéder aux conteneurs
```bash
# Accéder au conteneur backend
docker-compose exec backend bash

# Accéder au conteneur frontend
docker-compose exec frontend sh

# Accéder à PostgreSQL
docker-compose exec postgres psql -U postgres -d pureSkin
```

## 📊 Volumes persistants

- `postgres_data`: Données PostgreSQL persistées

## 🔍 Health Checks

Les services incluent des health checks:
- **PostgreSQL**: Vérifie la connexion à la base
- **Backend**: Vérifie l'API `/api/products`
- **Frontend**: Vérifie la page d'accueil

## 🚨 Dépannage

### Problèmes courants

1. **Port déjà utilisé**
   ```bash
   # Vérifier les ports utilisés
   netstat -an | grep :3000
   netstat -an | grep :8080
   netstat -an | grep :5432
   ```

2. **Build échoué**
   ```bash
   # Nettoyer et reconstruire
   docker-compose down
   docker system prune -f
   docker-compose build --no-cache
   ```

3. **Base de données inaccessible**
   ```bash
   # Vérifier les logs PostgreSQL
   docker-compose logs postgres
   
   # Redémarrer PostgreSQL
   docker-compose restart postgres
   ```

### Développement local

Pour le développement, vous pouvez utiliser Docker uniquement pour la base de données:

```bash
# Démarrer uniquement PostgreSQL
docker-compose up -d postgres

# Puis lancer backend et frontend localement
cd backend && mvn spring-boot:run
cd frontend && npm run dev
```

## 🔄 Mise à jour

Pour mettre à jour l'application:

```bash
# Arrêter les services
docker-compose down

# Mettre à jour les images
docker-compose pull

# Reconstruire les images locales
docker-compose build

# Redémarrer
docker-compose up -d
```
