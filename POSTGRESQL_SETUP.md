# PostgreSQL Setup pour PureSkin Étudiant

## Installation de PostgreSQL

### Windows
1. Télécharger PostgreSQL depuis https://www.postgresql.org/download/windows/
2. Installer avec le mot de passe : `postgres`
3. Ajouter PostgreSQL au PATH système

### macOS (avec Homebrew)
```bash
brew install postgresql
brew services start postgresql
```

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

## Configuration de la base de données

### 1. Créer la base de données
```sql
-- Se connecter à PostgreSQL
psql -U postgres

-- Créer la base de données PureSkin
CREATE DATABASE "PureSkin";

-- Créer l'utilisateur (si nécessaire)
CREATE USER pureskin_user WITH PASSWORD 'pureskin_password';
GRANT ALL PRIVILEGES ON DATABASE "PureSkin" TO pureskin_user;
```

### 2. Configuration du fichier application.properties
Le fichier est déjà configuré pour :
- URL : `jdbc:postgresql://localhost:5432/PureSkin`
- Username : `postgres`
- Password : `postgres`

### 3. Exécuter le schéma SQL
```bash
# Se connecter à la base de données
psql -U postgres -d PureSkin

# Exécuter le schéma
\i backend/src/main/resources/schema.sql
```

## Vérification de l'installation

### 1. Démarrer PostgreSQL
```bash
# Windows
net start postgresql-x64-14

# macOS/Linux
sudo systemctl start postgresql
# ou
brew services start postgresql
```

### 2. Tester la connexion
```bash
psql -U postgres -h localhost -p 5432 -d PureSkin
```

### 3. Vérifier les tables
```sql
\dt
-- Devrait afficher :
-- categories, products, customers, testimonials, blog_posts, routines, etc.
```

## Commandes utiles PostgreSQL

### Connexion
```bash
psql -U postgres -d PureSkin
```

### Lister les bases de données
```sql
\l
```

### Décrire une table
```sql
\d products
```

### Voir le contenu d'une table
```sql
SELECT * FROM products LIMIT 5;
```

### Quitter
```sql
\q
```

## Dépannage

### Problème : Connexion refusée
```bash
# Vérifier que PostgreSQL tourne
pg_ctl status

# Redémarrer PostgreSQL
sudo systemctl restart postgresql
# ou
brew services restart postgresql
```

### Problème : Base de données n'existe pas
```sql
-- Créer la base de données
CREATE DATABASE "PureSkin";
```

### Problème : Permissions
```sql
-- Donner tous les droits à l'utilisateur
GRANT ALL PRIVILEGES ON DATABASE "PureSkin" TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
```

## Configuration de Spring Boot

Le backend est configuré pour :
- Utiliser PostgreSQL comme base de données
- Créer/mettre à jour les tables automatiquement (`hibernate.ddl-auto=update`)
- Afficher les requêtes SQL en console
- Se connecter à `localhost:5432/PureSkin`

## Démarrage du projet

1. **Démarrer PostgreSQL**
2. **Lancer le backend** :
   ```bash
   cd backend
   mvn spring-boot:run
   ```
3. **Lancer le frontend** :
   ```bash
   cd frontend
   npm run dev
   ```

Le backend sera accessible sur http://localhost:8080
Le frontend sera accessible sur http://localhost:3000 (ou 3001)
