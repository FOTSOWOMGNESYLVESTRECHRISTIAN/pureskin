# 🚀 GUIDE COMPLET DE DÉPLOIEMENT PURESKIN ÉTUDIANT SUR RENDER

## 📋 PRÉREQUIS

### Comptes nécessaires :
- Compte Render (render.com)
- Compte GitHub/GitLab/Bitbucket
- Compte Supabase/PlanetScale/ElephantSQL (pour la base de données)

### Outils à installer :
```bash
# Node.js (v18 ou supérieur)
npm install -g render-cli

# Git
# Vérifier l'installation
node --version
npm --version
git --version
```

---

## 🗂️ STRUCTURE DU PROJET

```
pureskin-etudiant/
├── frontend/                 # Application Next.js
│   ├── src/
│   ├── package.json
│   ├── next.config.js
│   ├── tailwind.config.js
│   └── ...
├── backend/                  # Application Spring Boot
│   ├── src/
│   ├── pom.xml
│   └── ...
├── pureskin_final.sql        # Base de données
└── README.md
```

---

## 🎯 ÉTAPE 1: PRÉPARATION DU FRONTEND (NEXT.JS)

### 1.1 Configuration de Render pour Next.js

Créer le fichier `frontend/render.yaml` :
```yaml
services:
  # Service Frontend
  - type: web
    name: pureskin-frontend
    env: static
    buildCommand: npm run build
    staticPublishPath: .next
    envVars:
      - key: NEXT_PUBLIC_API_URL
        value: https://pureskin-backend.onrender.com
      - key: NEXT_PUBLIC_FAROTY_API_URL
        value: https://api.faroty.dev
      - key: NEXT_PUBLIC_FAROTY_API_KEY
        value: votre_cle_api_faroty
    routes:
      - type: rewrite
        source: /(.*)
        destination: /index.html
```

### 1.2 Variables d'environnement pour le frontend

Créer le fichier `frontend/.env.production` :
```env
# API Backend
NEXT_PUBLIC_API_URL=https://pureskin-backend.onrender.com
NEXT_PUBLIC_FAROTY_API_URL=https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY=votre_cle_api_faroty

# Base de données (si nécessaire côté frontend)
NEXT_PUBLIC_SUPABASE_URL=https://votre-projet.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=votre_cle_anon_supabase

# Autres
NEXT_PUBLIC_APP_URL=https://pureskin-frontend.onrender.com
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
```

### 1.3 Configuration du package.json

S'assurer que `frontend/package.json` contient :
```json
{
  "name": "frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^16.1.6",
    "react": "^19.2.3",
    "react-dom": "^19.2.3",
    "lucide-react": "^0.574.0"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.32",
    "tailwindcss": "^3.4.0",
    "typescript": "^5"
  }
}
```

---

## 🎯 ÉTAPE 2: PRÉPARATION DU BACKEND (SPRING BOOT)

### 2.1 Configuration de l'application

Modifier `backend/src/main/resources/application.properties` :
```properties
# Configuration serveur
server.port=${PORT:8080}

# Base de données
spring.datasource.url=${DATABASE_URL:jdbc:postgresql://localhost:5432/pureskin}
spring.datasource.username=${DB_USERNAME:postgres}
spring.datasource.password=${DB_PASSWORD:password}
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true

# CORS
spring.web.cors.allowed-origins=https://pureskin-frontend.onrender.com,https://localhost:3000,https://localhost:3001
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH
spring.web.cors.allowed-headers=*
spring.web.cors.allow-credentials=true
spring.web.cors.max-age=3600

# Faroty API
faroty.api.url=https://api.faroty.dev
faroty.api.key=${FAROTY_API_KEY:votre_cle_api}

# Logging
logging.level.com.pureskin.etudiant=INFO
logging.level.org.springframework.web=DEBUG
```

### 2.2 Configuration du build Maven

S'assurer que `backend/pom.xml` inclut :
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <mainClass>com.pureskin.etudiant.PureSkinEtudiantApplication</mainClass>
            </configuration>
        </plugin>
    </plugins>
</build>

<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- Base de données -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Autres dépendances -->
</dependencies>
```

---

## 🎯 ÉTAPE 3: DÉPLOIEMENT DE LA BASE DE DONNÉES

### 3.1 Création de la base de données

**Option 1: Supabase (Recommandé)**
1. Créer un compte sur supabase.com
2. Créer un nouveau projet
3. Aller dans le SQL Editor
4. Copier-coller le contenu de `pureskin_final.sql`
5. Exécuter le script

**Option 2: ElephantSQL (Gratuit)**
1. Créer un compte sur elephantsql.com
2. Créer une nouvelle instance
3. Copier l'URL de connexion
4. Importer le fichier `pureskin_final.sql`

**Option 3: Render PostgreSQL**
1. Aller sur render.com
2. Créer "New PostgreSQL" 
3. Configurer l'instance
4. Importer le fichier SQL

### 3.2 Récupérer les informations de connexion

```bash
# Exemple Supabase
URL: postgresql://postgres:[password]@db.votre-projet.supabase.co:5432/postgres

# Exemple ElephantSQL
URL: postgresql://utilisateur:password@tuffi.db.elephantsql.com:5432/base

# Exemple Render
URL: postgres://utilisateur:password@dpg-xxxxx.oregon.render.com:5432/base
```

---

## 🎯 ÉTAPE 4: PRÉPARATION DU DÉPÔT GIT

### 4.1 Structure du dépôt

Organiser le dépôt pour Render :
```bash
# Structure recommandée
pureskin-etudiant/
├── frontend/
│   ├── src/
│   ├── package.json
│   └── ...
├── backend/
│   ├── src/
│   ├── pom.xml
│   └── ...
└── render.yaml
```

### 4.2 Créer le fichier render.yaml principal

Créer `render.yaml` à la racine :
```yaml
services:
  # Service Backend
  - type: web
    name: pureskin-backend
    runtime: java
    plan: free
    buildCommand: ./mvnw clean package -DskipTests
    startCommand: java -jar target/backend-0.0.1-SNAPSHOT.jar
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: pureskin-db
          property: connectionString
      - key: DB_USERNAME
        value: postgres
      - key: DB_PASSWORD
        fromDatabase:
          name: pureskin-db
          property: password
      - key: FAROTY_API_KEY
        value: votre_cle_api_faroty
      - key: PORT
        value: 8080
    healthCheckPath: /actuator/health

  # Service Frontend
  - type: web
    name: pureskin-frontend
    runtime: static
    buildCommand: cd frontend && npm install && npm run build
    staticPublishPath: frontend/.next
    envVars:
      - key: NEXT_PUBLIC_API_URL
        value: https://pureskin-backend.onrender.com
      - key: NEXT_PUBLIC_FAROTY_API_URL
        value: https://api.faroty.dev
      - key: NEXT_PUBLIC_FAROTY_API_KEY
        value: votre_cle_api_faroty
    routes:
      - type: rewrite
        source: /(.*)/*
        destination: /index.html

# Base de données
databases:
  - name: pureskin-db
    databaseName: pureskin
    user: postgres
    plan: free
```

### 4.3 Initialisation et push Git

```bash
# Initialiser Git si nécessaire
git init
git add .
git commit -m "Initial commit - PureSkin Étudiant"

# Créer un dépôt sur GitHub
git remote add origin https://github.com/votre-username/pureskin-etudiant.git
git push -u origin main
```

---

## 🎯 ÉTAPE 5: DÉPLOIEMENT SUR RENDER

### 5.1 Création du compte Render

1. Se connecter sur render.com
2. S'inscrire avec GitHub
3. Autoriser l'accès au dépôt

### 5.2 Création des services

#### Option A: Via le dashboard Render

1. **Créer la base de données :**
   - Cliquer "New PostgreSQL"
   - Nom: `pureskin-db`
   - Plan: Free
   - Créer

2. **Importer les données :**
   - Aller dans la base de données créée
   - Cliquer "Import"
   - Uploader le fichier `pureskin_final.sql`

3. **Créer le service backend :**
   - Cliquer "New Web Service"
   - Connecter le dépôt GitHub
   - Nom: `pureskin-backend`
   - Runtime: Java
   - Build Command: `./mvnw clean package -DskipTests`
   - Start Command: `java -jar target/backend-0.0.1-SNAPSHOT.jar`
   - Plan: Free

4. **Créer le service frontend :**
   - Cliquer "New Static Site"
   - Connecter le dépôt GitHub
   - Nom: `pureskin-frontend`
   - Build Command: `cd frontend && npm install && npm run build`
   - Publish Directory: `frontend/.next`
   - Plan: Free

#### Option B: Via render.yaml (Automatique)

1. Push le fichier `render.yaml` dans le dépôt
2. Render détectera automatiquement le fichier
3. Les services seront créés automatiquement

### 5.3 Configuration des variables d'environnement

Dans le dashboard Render, configurer les variables pour chaque service :

**Backend (pureskin-backend) :**
```
DATABASE_URL = postgres://user:pass@host:5432/dbname
DB_USERNAME = postgres
DB_PASSWORD = votre_password
FAROTY_API_KEY = votre_cle_api_faroty
PORT = 8080
```

**Frontend (pureskin-frontend) :**
```
NEXT_PUBLIC_API_URL = https://pureskin-backend.onrender.com
NEXT_PUBLIC_FAROTY_API_URL = https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY = votre_cle_api_faroty
NEXT_PUBLIC_APP_URL = https://pureskin-frontend.onrender.com
```

---

## 🎯 ÉTAPE 6: CONFIGURATION FINALE

### 6.1 Mise à jour des CORS

Dans le backend, mettre à jour les CORS pour inclure l'URL Render :

```java
@CrossOrigin(origins = {
    "https://pureskin-frontend.onrender.com",
    "https://pureskin-backend.onrender.com",
    "http://localhost:3000",
    "http://localhost:3001"
})
```

### 6.2 Configuration du health check

Ajouter un health check dans le backend si nécessaire :

```java
@RestController
public class HealthController {
    
    @GetMapping("/actuator/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> status = new HashMap<>();
        status.put("status", "UP");
        return ResponseEntity.ok(status);
    }
}
```

Ajouter la dépendance dans `pom.xml` :
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### 6.3 Redéploiement final

```bash
# Commiter les changements
git add .
git commit -m "Update configuration for Render deployment"
git push

# Render déploiera automatiquement
```

---

## 🔧 PARAMÈTRES DE CONSTRUCTION DE SORTIE

### Frontend (Render Static Site) :
```yaml
type: web
runtime: static
buildCommand: cd frontend && npm install && npm run build
staticPublishPath: frontend/.next
```

### Backend (Render Web Service) :
```yaml
type: web
runtime: java
buildCommand: ./mvnw clean package -DskipTests
startCommand: java -jar target/backend-0.0.1-SNAPSHOT.jar
```

### Base de données (Render PostgreSQL) :
```yaml
type: pserv
runtime: postgresql
databaseName: pureskin
user: postgres
```

---

## 🌍 VARIABLES D'ENVIRONNEMENT

### Frontend (.env.production) :
```env
# API URLs
NEXT_PUBLIC_API_URL=https://pureskin-backend.onrender.com
NEXT_PUBLIC_FAROTY_API_URL=https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY=votre_cle_api

# App URLs
NEXT_PUBLIC_APP_URL=https://pureskin-frontend.onrender.com

# Base de données (si accès direct)
NEXT_PUBLIC_SUPABASE_URL=https://votre-projet.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Paiement
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
```

### Backend (application.properties) :
```properties
# Base de données
spring.datasource.url=${DATABASE_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

# API externes
faroty.api.key=${FAROTY_API_KEY}

# Sécurité
cors.allowed.origins=https://pureskin-frontend.onrender.com
```

### Variables Render (Dashboard) :

**Backend Service :**
```
DATABASE_URL = postgres://postgres:[password]@dpg-xxxxx.oregon.render.com:5432/pureskin
DB_USERNAME = postgres
DB_PASSWORD = votre_password_db
FAROTY_API_KEY = votre_cle_api_faroty
PORT = 8080
```

**Frontend Service :**
```
NEXT_PUBLIC_API_URL = https://pureskin-backend.onrender.com
NEXT_PUBLIC_FAROTY_API_URL = https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY = votre_cle_api
NEXT_PUBLIC_APP_URL = https://pureskin-frontend.onrender.com
```

---

## ✅ VÉRIFICATION FINALE

### 1. Tester l'API backend :
```bash
curl https://pureskin-backend.onrender.com/api/products
curl https://pureskin-backend.onrender.com/api/blog-posts
curl https://pureskin-backend.onrender.com/actuator/health
```

### 2. Tester le frontend :
- Visiter `https://pureskin-frontend.onrender.com`
- Vérifier que les produits s'affichent
- Tester le panier et le checkout

### 3. Tester le processus complet :
1. Ajouter des produits au panier
2. Passer une commande
3. Vérifier l'email de confirmation
4. Vérifier la base de données

---

## 🚨 DÉPANNAGE

### Problèmes courants :

**Build Failed sur Backend :**
```bash
# Vérifier la version Java
java -version

# Nettoyer et rebuild
./mvnw clean install
```

**Database Connection Error :**
```bash
# Vérifier l'URL de connexion
# Format: postgres://user:password@host:port/database
```

**CORS Errors :**
```java
// Ajouter l'URL Render dans les CORS
@CrossOrigin(origins = {"https://pureskin-frontend.onrender.com"})
```

**Static Site Not Found :**
```yaml
# Vérifier le chemin de publication
staticPublishPath: frontend/.next
```

**Health Check Failed :**
```java
// Ajouter le endpoint de health
@GetMapping("/health")
public ResponseEntity<String> health() {
    return ResponseEntity.ok("OK");
}
```

---

## 📊 MONITORING

### Render Dashboard :
- URL: render.com/dashboard
- Services: onglet "Services"
- Logs: cliquer sur un service → onglet "Logs"
- Metrics: onglet "Metrics"
- Events: onglet "Events"

### Base de données :
- Supabase: supabase.com/dashboard
- Render: cliquer sur la base de données → "Connection"

---

## ⚡ OPTIMISATIONS

### 1. Performance Frontend :
```javascript
// next.config.js
module.exports = {
  compress: true,
  poweredByHeader: false,
  images: {
    domains: ['votre-cdn.com'],
  },
}
```

### 2. Performance Backend :
```properties
# application.properties
spring.datasource.hikari.connection-timeout=20000
spring.datasource.hikari.maximum-pool-size=10
```

### 3. Cache :
```java
// Ajouter des headers de cache
@Cacheable(value = "products")
public List<Product> getAllProducts() {
    return productRepository.findAll();
}
```

---

## 🔄 MISES À JOUR

### Pour mettre à jour le code :
```bash
git add .
git commit -m "Update feature"
git push
# Render déploiera automatiquement
```

### Pour mettre à jour la base de données :
1. Aller sur le dashboard Render
2. Cliquer sur la base de données
3. Utiliser "Query" ou "Import"

---

## 🎉 FÉLICITATIONS !

Votre projet PureSkin Étudiant est maintenant déployé sur Render !

**URLs finales :**
- Frontend: `https://pureskin-frontend.onrender.com`
- Backend: `https://pureskin-backend.onrender.com`
- Base de données: Configurée et fonctionnelle

**Avantages de Render :**
- Déploiement automatique via Git
- HTTPS gratuit
- Base de données PostgreSQL intégrée
- Monitoring intégré
- Plan gratuit généreux

**Prochaines étapes :**
- Configurer un domaine personnalisé
- Mettre en place les backups automatiques
- Configurer les alertes de monitoring
- Optimiser les performances
