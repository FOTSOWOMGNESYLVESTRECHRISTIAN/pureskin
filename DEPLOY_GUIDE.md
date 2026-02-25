# 🚀 Guide de Déploiement PureSkin Étudiant

## ✅ Corrections apportées

### 1. Docker Compose corrigé
- ✅ Suppression de `version: '3.8'` (obsolète)
- ✅ Configuration des réseaux explicite
- ✅ Health checks avec `wget` au lieu de `curl`
- ✅ Variables d'environnement optimisées

### 2. Dockerfiles corrigés
- ✅ Backend: `openjdk:17-jdk-slim` (image existante)
- ✅ Installation de `wget` pour les health checks
- ✅ Frontend: `wget` ajouté pour Alpine

## 🐳 Commandes pour lancer le projet

### Étape 1: Nettoyer les anciens conteneurs
```bash
docker-compose down -v
docker system prune -f
```

### Étape 2: Construire et lancer
```bash
docker-compose up --build -d
```

### Étape 3: Vérifier les logs
```bash
# Voir tous les logs
docker-compose logs -f

# Logs spécifiques
docker-compose logs -f postgres
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Étape 4: Insérer les données
```bash
# Attendre que PostgreSQL soit prêt
sleep 30

# Insérer les données
docker exec -i pureskin-postgres psql -U postgres -d pureSkin < data_final.sql
```

## 🌐 Accès à l'application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **PostgreSQL**: localhost:5432

## 🔧 Dépannage

### Problèmes courants:

#### 1. "Port déjà utilisé"
```bash
# Tuer les processus utilisant les ports
netstat -ano | findstr :3000
netstat -ano | findstr :8080
netstat -ano | findstr :5432

# Tuer les processus (remplacer PID)
taskkill /PID <PID> /F
```

#### 2. "Permission denied"
```bash
# Exécuter en tant qu'administrateur
# Ou utiliser Docker Desktop avec permissions élevées
```

#### 3. "Build failed"
```bash
# Reconstruire complètement
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

#### 4. "Database connection failed"
```bash
# Vérifier que PostgreSQL est prêt
docker exec pureskin-postgres pg_isready -U postgres

# Insérer les données si nécessaire
docker exec -i pureskin-postgres psql -U postgres -d pureSkin < data_final.sql
```

## 📊 Vérification du déploiement

### 1. Vérifier les services
```bash
docker-compose ps
```

### 2. Tester les endpoints
```bash
# Backend health
curl http://localhost:8080/actuator/health

# Frontend
curl http://localhost:3000

# API Products
curl http://localhost:8080/api/products
```

### 3. Vérifier les données
```bash
# Se connecter à PostgreSQL
docker exec -it pureskin-postgres psql -U postgres -d pureSkin

# Vérifier les tables
\dt

# Vérifier les produits
SELECT COUNT(*) FROM products;
```

## 🚀 Pour la production

### 1. Variables d'environnement
Créer un fichier `.env`:
```env
POSTGRES_DB=pureSkin
POSTGRES_USER=postgres
POSTGRES_PASSWORD=votre_mot_de_passe_securise
SPRING_DATASOURCE_PASSWORD=votre_mot_de_passe_securise
```

### 2. HTTPS avec Nginx
Ajouter un reverse proxy Nginx pour le HTTPS.

### 3. Volumes persistants
Configurer les volumes pour les données PostgreSQL.

### 4. Monitoring
Ajouter Prometheus/Grafana pour le monitoring.

## 📞 Support

Si vous rencontrez des problèmes:
1. Vérifiez les logs avec `docker-compose logs`
2. Assurez-vous que Docker Desktop est en cours d'exécution
3. Vérifiez les ports disponibles
4. Consultez ce guide de dépannage
