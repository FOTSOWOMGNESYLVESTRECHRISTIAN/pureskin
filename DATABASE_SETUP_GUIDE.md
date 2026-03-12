# Guide de Configuration de la Base de Données PureSkin

## 📋 Vue d'ensemble

Ce guide vous aide à configurer la base de données PostgreSQL pour que les commandes soient correctement enregistrées et gérées par le backend PureSkin.

## 🗄️ Scripts Disponibles

### 1. `setup_orders_database.sql`
- **Objectif:** Créer toutes les tables nécessaires (customers, orders, order_items, products, categories)
- **Contenu:** Structure complète avec indexes, triggers et données par défaut
- **Quand l'exécuter:** Première installation ou si les tables n'existent pas

### 2. `test_orders_data.sql`
- **Objectif:** Insérer des données de test pour vérifier le fonctionnement
- **Contenu:** Client test, produits test, commande test avec items
- **Quand l'exécuter:** Après avoir créé les tables, pour tester

### 3. `fix_database_currency.sql`
- **Objectif:** Corriger la currency (EUR → XAF) et mettre à jour les données
- **Contenu:** Conversion des prix, recalcul des totaux, vues optimisées
- **Quand l'exécuter:** Pour corriger les données existantes

## 🚀 Instructions d'Exécution

### Étape 1: Connexion à PostgreSQL

```bash
# Se connecter à PostgreSQL
psql -U postgres -d pureskin

# Ou avec un autre utilisateur
psql -U votre_utilisateur -d pureskin
```

### Étape 2: Création des tables

```sql
-- Exécuter le script de création
\i setup_orders_database.sql
```

### Étape 3: Insertion des données de test

```sql
-- Exécuter le script de test
\i test_orders_data.sql
```

### Étape 4: Corrections et optimisations

```sql
-- Exécuter le script de corrections
\i fix_database_currency.sql
```

### Étape 5: Vérification

```sql
-- Vérifier que tout est correct
SELECT COUNT(*) as nombre_commandes FROM orders;
SELECT COUNT(*) as nombre_produits FROM products;
SELECT COUNT(*) as nombre_clients FROM customers;
```

## 🔧 Configuration Backend

### 1. Redémarrer le backend après les modifications

```bash
# Arrêter le backend
taskkill /F /IM java.exe

# Relancer le backend
cd backend && mvn spring-boot:run
```

### 2. Vérifier la connexion à la base de données

Assurez-vous que `application.properties` contient:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/pureskin
spring.datasource.username=postgres
spring.datasource.password=votre_mot_de_passe
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

## 📊 Structure des Tables

### `customers`
- Informations client (nom, email, téléphone, adresse)
- Relation one-to-many avec `orders`

### `orders`
- Informations commande (numéro, statut, montant, etc.)
- Champs Faroty (wallet_id, session_token, faroty_user_id)
- Relation one-to-many avec `order_items`

### `order_items`
- Détails des produits commandés
- Prix unitaire, quantité, total
- Relation many-to-one avec `orders`

### `products`
- Catalogue des produits
- Prix en XAF, stock, catégories

### `categories`
- Classification des produits

## 🎯 Fonctionnalités Automatiques

### Triggers
- **Mise à jour automatique de `updated_at`**
- **Recalcul automatique des totaux de commande**

### Vues
- **`order_details_view`**: Vue complète des commandes avec leurs items

### Fonctions
- **`calculate_order_total()`**: Recalculer le total d'une commande

## 🧪 Tests

### Test API Backend

```bash
# Test création de commande
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "orderNumber": "PS-TEST-002",
    "totalAmount": 25000,
    "customerInfo": {
      "email": "test@example.com",
      "firstName": "Test",
      "lastName": "User"
    }
  }'
```

### Test Récupération

```bash
# Récupérer une commande
curl http://localhost:8080/api/orders/1
```

## 🔍 Dépannage

### Problèmes Communs

1. **"Table does not exist"**
   - Solution: Exécuter `setup_orders_database.sql`

2. **"Currency mismatch"**
   - Solution: Exécuter `fix_database_currency.sql`

3. **"Permission denied"**
   - Solution: Vérifier les permissions PostgreSQL

4. **Backend ne se connecte pas**
   - Solution: Vérifier `application.properties`

### Logs utiles

```sql
-- Vérifier les dernières commandes
SELECT * FROM orders ORDER BY created_at DESC LIMIT 5;

-- Vérifier les items d'une commande
SELECT * FROM order_items WHERE order_id = 1;

-- Vérifier les produits sans prix
SELECT * FROM products WHERE price IS NULL OR price <= 0;
```

## 📈 Monitoring

### Requêtes de monitoring

```sql
-- Statistiques des commandes
SELECT 
    status,
    payment_status,
    COUNT(*) as nombre,
    SUM(total_amount) as montant_total
FROM orders 
GROUP BY status, payment_status;

-- Produits les plus vendus
SELECT 
    p.name,
    SUM(oi.quantity) as quantite_totale,
    SUM(oi.total_price) as revenu_total
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY quantite_totale DESC;
```

## ✅ Validation Finale

Après avoir exécuté tous les scripts, vérifiez:

1. ✅ Tables créées correctement
2. ✅ Données de test insérées
3. ✅ Currency en XAF
4. ✅ Backend connecté
5. ✅ API fonctionnelle

Le système est maintenant prêt à enregistrer et gérer les commandes correctement !
