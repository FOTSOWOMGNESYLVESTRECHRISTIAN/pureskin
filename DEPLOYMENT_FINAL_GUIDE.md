# 🚀 GUIDE FINAL DE DÉPLOIEMENT PURESKIN ÉTUDIANT
# Vercel (Frontend) + Render (Backend) + PostgreSQL

## 📋 PRÉREQUIS

### Comptes nécessaires :
- ✅ Compte Vercel (vercel.com)
- ✅ Compte Render (render.com) 
- ✅ Compte GitHub (github.com)
- ✅ Clé Faroty API (déjà configurée)

### Clés API configurées :
- 🔑 **Faroty API Key**: `fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU`

---

## 🗂️ STRUCTURE FINALE DU PROJET

```
pureskin-etudiant/
├── frontend/                     # Application Next.js → Vercel
│   ├── src/
│   ├── package.json
│   ├── vercel.json              # ✅ Config Vercel
│   └── .env.production          # 📝 À créer manuellement
├── backend/                      # Application Spring Boot → Render
│   ├── src/
│   ├── pom.xml
│   └── src/main/resources/
│       └── application.properties # ✅ Config Render
├── render.yaml                   # ✅ Config Render
├── pureskin_final.sql           # Base de données
└── DEPLOYMENT_FINAL_GUIDE.md    # 📖 Ce guide
```

---

## 🎯 ÉTAPE 1: PRÉPARATION DE LA BASE DE DONNÉES

### 1.1 Créer la base PostgreSQL sur Render

1. **Se connecter sur render.com**
2. **Cliquer sur "New PostgreSQL"**
3. **Configuration :**
   ```
   Name: pureskin-db
   Database Name: pureSkin
   User: postgres
   Plan: Free
   PostgreSQL Version: 15
   ```
4. **Créer la base**

### 1.2 Importer les données

1. **Aller dans le dashboard Render**
2. **Cliquer sur "pureskin-db"**
3. **Onglet "Data" → "Import"**
4. **Uploader le fichier `pureskin_final.sql`**
5. **Exécuter l'import**

### 1.3 Récupérer les informations de connexion

Render affichera :
```
Host: dpg-xxxxx.oregon.render.com
Port: 5432
Database: pureSkin
User: postgres
Connection String: postgres://postgres:[password]@dpg-xxxxx.oregon.render.com:5432/pureSkin
```

---

## 🎯 ÉTAPE 2: CONFIGURATION BACKEND (RENDER)

### 2.1 Fichiers déjà configurés ✅

**`backend/src/main/resources/application.properties`** :
```properties
# Configuration serveur
server.port=${PORT:8080}

# Base de données (Render fournit DATABASE_URL)
spring.datasource.url=${DATABASE_URL:jdbc:postgresql://localhost:5432/pureSkin}
spring.datasource.username=${DB_USERNAME:postgres}
spring.datasource.password=${DB_PASSWORD:root}

# CORS pour Vercel
spring.web.cors.allowed-origins=https://pureskin-frontend.vercel.app,https://pureskin-frontend-git-username.vercel.app,http://localhost:3000,http://localhost:3001,http://localhost:3002

# API Faroty
faroty.api.key=${FAROTY_API_KEY:fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU}
```

**`render.yaml`** :
```yaml
services:
  - type: web
    name: pureskin-backend
    runtime: java
    buildCommand: ./mvnw clean package -DskipTests
    startCommand: java -jar target/backend-0.0.1-SNAPSHOT.jar
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: pureskin-db
          property: connectionString
      - key: FAROTY_API_KEY
        value: fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU
      - key: PORT
        value: 8080
    healthCheckPath: /actuator/health

databases:
  - name: pureskin-db
    databaseName: pureSkin
    user: postgres
    plan: free
```

### 2.2 Vérifier la configuration

```bash
# Tester localement
cd backend
./mvnw spring-boot:run

# Vérifier les logs
curl http://localhost:8080/actuator/health
```

---

## 🎯 ÉTAPE 3: CONFIGURATION FRONTEND (VERCEL)

### 3.1 Fichiers déjà configurés ✅

**`frontend/vercel.json`** :
```json
{
  "version": 2,
  "env": {
    "NEXT_PUBLIC_API_URL": "https://pureskin-backend.onrender.com",
    "NEXT_PUBLIC_FAROTY_API_URL": "https://api.faroty.dev",
    "NEXT_PUBLIC_FAROTY_API_KEY": "fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU",
    "NEXT_PUBLIC_APP_URL": "https://pureskin-frontend.vercel.app"
  }
}
```

### 3.2 Créer le fichier .env.production manuellement 📝

**Créer `frontend/.env.production`** (ce fichier n'est pas dans Git) :
```env
NEXT_PUBLIC_API_URL=https://pureskin-backend.onrender.com
NEXT_PUBLIC_FAROTY_API_URL=https://api.faroty.dev
NEXT_PUBLIC_FAROTY_API_KEY=fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU
NEXT_PUBLIC_APP_URL=https://pureskin-frontend.vercel.app
```

### 3.3 Vérifier la configuration frontend

```bash
# Tester localement
cd frontend
npm run build
npm run start

# Vérifier les variables d'environnement
echo $NEXT_PUBLIC_API_URL
```

---

## 🎯 ÉTAPE 4: PRÉPARATION DU DÉPÔT GIT

### 4.1 Structure du dépôt

```bash
# S'assurer que tout est commité
git status
git add .
git commit -m "Configuration finale pour déploiement Vercel + Render"
```

### 4.2 Pousser sur GitHub

```bash
# Si le dépôt n'existe pas
git remote add origin https://github.com/votre-username/pureskin-etudiant.git

# Pousser les changements
git push -u origin main
```

---

## 🎯 ÉTAPE 5: DÉPLOIEMENT BACKEND SUR RENDER

### 5.1 Méthode A: Via render.yaml (Recommandé)

1. **Se connecter sur render.com**
2. **Cliquer sur "New +" → "Web Service"**
3. **Connecter le dépôt GitHub**
4. **Sélectionner le dépôt `pureskin-etudiant`**
5. **Render détectera automatiquement `render.yaml`**
6. **Cliquer sur "Create Web Service"**

### 5.2 Méthode B: Manuel

1. **Créer "New Web Service"**
2. **Configuration manuelle :**
   ```
   Name: pureskin-backend
   Runtime: Java
   Build Command: ./mvnw clean package -DskipTests
   Start Command: java -jar target/backend-0.0.1-SNAPSHOT.jar
   Root Directory: backend
   Branch: main
   ```

### 5.3 Configuration des variables d'environnement

Dans le dashboard Render → pureskin-backend → Environment :

```
DATABASE_URL = postgres://postgres:[password]@dpg-xxxxx.oregon.render.com:5432/pureSkin
DB_USERNAME = postgres
DB_PASSWORD = [votre_password_db]
FAROTY_API_KEY = fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU
PORT = 8080
```

### 5.4 Vérification du déploiement

Render déploiera automatiquement et donnera l'URL :
```
https://pureskin-backend.onrender.com
```

Tester l'API :
```bash
curl https://pureskin-backend.onrender.com/api/products
curl https://pureskin-backend.onrender.com/actuator/health
```

---

## 🎯 ÉTAPE 6: DÉPLOIEMENT FRONTEND SUR VERCEL

### 6.1 Installation Vercel CLI

```bash
npm install -g vercel
vercel login
```

### 6.2 Déploiement automatique

1. **Aller dans le dossier frontend**
```bash
cd frontend
```

2. **Déployer avec Vercel**
```bash
vercel --prod
```

3. **Suivre les instructions :**
```
? Set up and deploy "~/pureskin-etudiant/frontend"? [Y/n] y
? Which scope do you want to deploy to? Votre Nom
? Link to existing project? [y/N] n
? What's your project's name? pureskin-frontend
? In which directory is your code located? ./
? Want to override the settings found in vercel.json? [y/N] y
```

### 6.3 Configuration des variables Vercel

Les variables sont déjà configurées dans `vercel.json`, mais vous pouvez les vérifier :

```bash
# Vérifier les variables
vercel env ls

# Ajouter si nécessaire
vercel env add NEXT_PUBLIC_API_URL production
# Valeur: https://pureskin-backend.onrender.com
```

### 6.4 Vérification du déploiement

Vercel déploiera et donnera l'URL :
```
https://pureskin-frontend.vercel.app
```

---

## 🎯 ÉTAPE 7: VÉRIFICATION FINALE

### 7.1 Tester l'API Backend

```bash
# Test des produits
curl https://pureskin-backend.onrender.com/api/products

# Test des articles de blog
curl https://pureskin-backend.onrender.com/api/blog-posts

# Test du health check
curl https://pureskin-backend.onrender.com/actuator/health
```

### 7.2 Tester le Frontend

1. **Visiter** `https://pureskin-frontend.vercel.app`
2. **Vérifier** que les produits s'affichent
3. **Tester** le panier et le checkout
4. **Vérifier** les appels API dans la console du navigateur

### 7.3 Tester le processus complet

1. **Ajouter des produits au panier**
2. **Passer une commande** (checkout)
3. **Vérifier** que la commande est créée en base
4. **Tester** le processus de paiement Faroty

### 7.4 Vérifier la base de données

```sql
-- Se connecter à la base Render
-- Vérifier les données
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT * FROM orders ORDER BY created_at DESC LIMIT 5;
```

---

## 🔧 PARAMÈTRES FINAUX

### Backend (Render) :
```yaml
Build Command: ./mvnw clean package -DskipTests
Start Command: java -jar target/backend-0.0.1-SNAPSHOT.jar
Runtime: Java
Plan: Free
Health Check: /actuator/health
```

### Frontend (Vercel) :
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "framework": "nextjs",
  "runtime": "nodejs18.x"
}
```

### Variables d'environnement :
```env
# Backend (Render)
DATABASE_URL = postgres://postgres:[password]@host:5432/pureSkin
FAROTY_API_KEY = fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU

# Frontend (Vercel)
NEXT_PUBLIC_API_URL = https://pureskin-backend.onrender.com
NEXT_PUBLIC_FAROTY_API_KEY = fk_live_mhZG1htEBgK02jvI5QZqNYTpzgdfFmMCisI8cho4KbxqSD9uq2l6h39XppRSayQVTtAj5pCAjRU
```

---

## 🚨 DÉPANNAGE RAPIDE

### Problèmes courants :

**Backend ne démarre pas :**
```bash
# Vérifier les logs Render
# Dashboard → pureskin-backend → Logs
```

**CORS Errors :**
```properties
# Ajouter l'URL exacte dans application.properties
spring.web.cors.allowed-origins=https://pureskin-frontend.vercel.app
```

**Database Connection Error :**
```bash
# Vérifier la DATABASE_URL dans Render
# Dashboard → pureskin-db → Connection
```

**Frontend ne trouve pas l'API :**
```bash
# Vérifier les variables Vercel
vercel env ls
# Vérifier NEXT_PUBLIC_API_URL
```

**Build Failed :**
```bash
# Nettoyer et rebuild localement
cd backend && ./mvnw clean install
cd frontend && npm run build
```

---

## 📊 MONITORING

### Render Dashboard :
- **URL**: render.com/dashboard
- **Backend**: pureskin-backend → Logs, Metrics, Events
- **Database**: pureskin-db → Connection, Metrics

### Vercel Dashboard :
- **URL**: vercel.com/dashboard
- **Frontend**: pureskin-frontend → Logs, Analytics, Functions

### Base de données :
- **Render**: pureskin-db → Query, Import/Export
- **URL**: `postgres://postgres:[password]@host:5432/pureSkin`

---

## 🎉 FÉLICITATIONS !

### 🌐 URLs finales de production :

- **Frontend**: `https://pureskin-frontend.vercel.app`
- **Backend**: `https://pureskin-backend.onrender.com`
- **API**: `https://pureskin-backend.onrender.com/api/*`
- **Database**: PostgreSQL sur Render

### ✅ Ce qui est configuré :

1. **Backend Spring Boot** sur Render avec :
   - Base de données PostgreSQL connectée
   - API Faroty intégrée
   - CORS configuré pour Vercel
   - Health checks actifs

2. **Frontend Next.js** sur Vercel avec :
   - Variables d'environnement configurées
   - Communication avec le backend
   - Clé Faroty API intégrée

3. **Base de données** PostgreSQL sur Render avec :
   - Toutes les tables créées
   - Données complètes insérées
   - Optimisée pour la production

### 🔄 Pour les mises à jour :

```bash
# Simple push Git
git add .
git commit -m "Update feature"
git push

# Render et Vercel déploieront automatiquement
```

### 🚀 Prochaines étapes optionnelles :

1. **Domaine personnalisé** : Configurer un nom de domaine
2. **SSL Certificate** : Déjà inclus avec Vercel/Render
3. **Backups automatiques** : Configurer dans Render
4. **Monitoring avancé** : Ajouter des alertes
5. **Analytics** : Configurer Google Analytics

**Votre projet PureSkin Étudiant est maintenant en production !** 🎉
