# 🚀 GUIDE COMPLET DE DÉPLOIEMENT PURESKIN ÉTUDIANT SUR VERCEL

## 📋 PRÉREQUIS

### Comptes nécessaires :
- Compte Vercel (vercel.com)
- Compte GitHub/GitLab/Bitbucket
- Compte Railway/Render/Heroku (pour le backend)
- Compte Supabase/PlanetScale/Railway (pour la base de données)

### Outils à installer :
```bash
# Node.js (v18 ou supérieur)
npm install -g vercel

# Git
# Vérifier l'installation
node --version
npm --version
vercel --version
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

### 1.1 Configuration de Vercel

Créer le fichier `frontend/vercel.json` :
```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/next"
    }
  ],
  "env": {
    "NEXT_PUBLIC_API_URL": "@api_url",
    "NEXT_PUBLIC_FAROTY_API_URL": "@faroty_api_url",
    "NEXT_PUBLIC_FAROTY_API_KEY": "@faroty_api_key"
  },
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ]
}
```

### 1.2 Variables d'environnement pour le frontend

Créer le fichier `frontend/.env.production` :
```env
# API Backend
NEXT_PUBLIC_API_URL=https://votre-backend.railway.app
NEXT_PUBLIC_FAROTY_API_URL=https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY=votre_cle_api_faroty

# Base de données (si nécessaire côté frontend)
NEXT_PUBLIC_SUPABASE_URL=https://votre-projet.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=votre_cle_anon_supabase

# Autres
NEXT_PUBLIC_APP_URL=https://votre-app.vercel.app
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
spring.datasource.url=jdbc:postgresql://votre-db.railway.app:5432/railway
spring.datasource.username=${DB_USERNAME:postgres}
spring.datasource.password=${DB_PASSWORD:votre_password}
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true

# CORS
spring.web.cors.allowed-origins=https://votre-app.vercel.app,https://localhost:3000,https://localhost:3001
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH
spring.web.cors.allowed-headers=*
spring.web.cors.allow-credentials=true
spring.web.cors.max-age=3600

# Faroty API
faroty.api.url=https://api.faroty.dev
faroty.api.key=${FAROTY_API_KEY:votre_cle_api}

# Autres
logging.level.com.pureskin.etudiant=INFO
```

### 2.2 Configuration du build Maven

S'assurer que `backend/pom.xml` inclut :
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
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

**Option 2: Railway**
1. Créer un compte sur railway.app
2. Créer un nouveau service PostgreSQL
3. Aller dans l'onglet "Data"
4. Importer le fichier `pureskin_final.sql`

### 3.2 Récupérer les informations de connexion

```bash
# Exemple Supabase
URL: https://votre-projet.supabase.co
Anon Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Service Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Exemple Railway
Host: votre-db.railway.app
Port: 5432
Database: railway
Username: postgres
Password: votre_password
```

---

## 🎯 ÉTAPE 4: DÉPLOIEMENT DU BACKEND

### 4.1 Préparation du dépôt Git

```bash
# Initialiser Git si nécessaire
git init
git add .
git commit -m "Initial commit - PureSkin Étudiant"

# Créer un dépôt sur GitHub et pousser
git remote add origin https://github.com/votre-username/pureskin-etudiant.git
git push -u origin main
```

### 4.2 Déploiement sur Railway

1. Se connecter sur railway.app
2. Cliquer sur "New Project"
3. Connecter le dépôt GitHub
4. Sélectionner le dossier `backend`
5. Configuration du service :

**Paramètres de construction :**
```
Build Command: ./mvnw clean install
Start Command: java -jar target/backend-0.0.1-SNAPSHOT.jar
```

**Variables d'environnement :**
```
DB_USERNAME=postgres
DB_PASSWORD=votre_password_db
FAROTY_API_KEY=votre_cle_api_faroty
PORT=8080
```

### 4.3 Vérification du déploiement

Une fois déployé, Railway vous donnera une URL comme :
`https://votre-backend-production.up.railway.app`

Tester l'API :
```bash
curl https://votre-backend-production.up.railway.app/api/products
```

---

## 🎯 ÉTAPE 5: DÉPLOIEMENT DU FRONTEND SUR VERCEL

### 5.1 Installation de Vercel CLI

```bash
npm install -g vercel
vercel login
```

### 5.2 Déploiement du frontend

```bash
# Aller dans le dossier frontend
cd frontend

# Déployer
vercel --prod

# Suivre les instructions :
# ? Set up and deploy "~/frontend"? [Y/n] y
# ? Which scope do you want to deploy to? Votre Nom
# ? Link to existing project? [y/N] n
# ? What's your project's name? pureskin-etudiant-frontend
# ? In which directory is your code located? ./
# ? Want to override the settings? [y/N] y
```

### 5.3 Configuration des variables d'environnement Vercel

Dans le dashboard Vercel ou via CLI :

```bash
# Variables d'environnement
vercel env add NEXT_PUBLIC_API_URL production
# Valeur: https://votre-backend-production.up.railway.app

vercel env add NEXT_PUBLIC_FAROTY_API_URL production  
# Valeur: https://api.faroty.dev

vercel env add NEXT_PUBLIC_FAROTY_API_KEY production
# Valeur: votre_cle_api_faroty
```

---

## 🎯 ÉTAPE 6: CONFIGURATION FINALE

### 6.1 Mise à jour des CORS

Dans le backend, s'assurer que les CORS incluent l'URL Vercel :

```java
@CrossOrigin(origins = {
    "https://votre-app.vercel.app",
    "https://votre-app-git-username.vercel.app",
    "http://localhost:3000",
    "http://localhost:3001"
})
```

### 6.2 Redéploiement final

```bash
# Backend
git add .
git commit -m "Update CORS for production"
git push

# Frontend  
cd frontend
vercel --prod
```

---

## 🔧 PARAMÈTRES DE CONSTRUCTION DE SORTIE

### Frontend (Vercel) :
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "installCommand": "npm install",
  "framework": "nextjs"
}
```

### Backend (Railway) :
```bash
Build Command: ./mvnw clean package -DskipTests
Start Command: java -jar target/backend-0.0.1-SNAPSHOT.jar
Output Directory: target/
```

---

## 🌍 VARIABLES D'ENVIRONNEMENT

### Frontend (.env.production) :
```env
# API URLs
NEXT_PUBLIC_API_URL=https://votre-backend.railway.app
NEXT_PUBLIC_FAROTY_API_URL=https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY=pk_live_...

# App URLs
NEXT_PUBLIC_APP_URL=https://votre-app.vercel.app

# Base de données (si accès direct)
NEXT_PUBLIC_SUPABASE_URL=https://votre-projet.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Paiement
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
```

### Backend (application.properties) :
```properties
# Base de données
spring.datasource.url=jdbc:postgresql://votre-db.railway.app:5432/railway
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

# API externes
faroty.api.key=${FAROTY_API_KEY}

# Sécurité
cors.allowed.origins=https://votre-app.vercel.app
```

### Variables Vercel :
```
NEXT_PUBLIC_API_URL=https://votre-backend.railway.app
NEXT_PUBLIC_FAROTY_API_URL=https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY=votre_cle_api
```

### Variables Railway :
```
DB_USERNAME=postgres
DB_PASSWORD=votre_password_db
FAROTY_API_KEY=votre_cle_api_faroty
PORT=8080
```

---

## ✅ VÉRIFICATION FINALE

### 1. Tester l'API backend :
```bash
curl https://votre-backend.railway.app/api/products
curl https://votre-backend.railway.app/api/blog-posts
```

### 2. Tester le frontend :
- Visiter `https://votre-app.vercel.app`
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

**CORS Errors :**
```java
// Ajouter l'URL Vercel dans les CORS
@CrossOrigin(origins = {"https://votre-app.vercel.app"})
```

**Database Connection :**
```properties
# Vérifier l'URL de la base de données
spring.datasource.url=jdbc:postgresql://host:port/database
```

**Build Failed :**
```bash
# Nettoyer et rebuild
./mvnw clean install
npm run build
```

**Environment Variables :**
```bash
# Vérifier les variables
vercel env ls
railway variables
```

---

## 📊 MONITORING

### Vercel :
- Dashboard: vercel.com/dashboard
- Logs: onglet "Logs" du projet
- Analytics: onglet "Analytics"

### Railway :
- Dashboard: railway.app/project
- Logs: onglet "Logs" du service
- Metrics: onglet "Metrics"

### Base de données :
- Supabase: supabase.com/dashboard
- Monitoring des requêtes et performances

---

## 🎉 FÉLICITATIONS !

Votre projet PureSkin Étudiant est maintenant déployé en production !

**URLs finales :**
- Frontend: `https://votre-app.vercel.app`
- Backend: `https://votre-backend.railway.app`
- Base de données: Configurée et fonctionnelle

**Prochaines étapes :**
- Configurer un domaine personnalisé
- Mettre en place le monitoring
- Configurer les backups automatiques
- Préparer la documentation utilisateur
