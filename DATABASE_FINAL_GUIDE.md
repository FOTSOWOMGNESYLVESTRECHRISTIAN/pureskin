# 📊 Base de Données PureSkin Étudiant - Guide Final

## 🎯 Vue d'ensemble

Deux fichiers SQL principaux sont maintenant disponibles pour gérer complètement la base de données PureSkin:

1. **`pureskin_database_complete.sql`** - Pour une nouvelle installation complète
2. **`update_pureskin_database.sql`** - Pour mettre à jour une base existante

## 🗄️ Structure Complète de la Base de Données

### Tables Principales

| Table | Description | Champs Clés |
|-------|-------------|-------------|
| `categories` | Catégories de produits | id, name, slug, is_active |
| `products` | Catalogue produits | id, name, slug, price, stock_quantity, category_id |
| `customers` | Informations clients | id, email, first_name, last_name |
| `orders` | Commandes clients | id, order_number, customer_id, status, total_amount |
| `order_items` | Articles de commande | id, order_id, product_id, quantity, unit_price |
| `payments` | Transactions paiement | id, order_id, amount, status, faroty_transaction_id |
| `blog_posts` | Articles blog | id, title, slug, is_published |
| `testimonials` | Témoignages clients | id, customer_name, rating, testimonial_text |
| `newsletter_subscribers` | Abonnés newsletter | id, email, is_active, student_verified |

## 🚀 Installation

### Option 1: Nouvelle Installation Complète

```bash
# Se connecter à PostgreSQL
psql -U postgres -d pureskin

# Exécuter le script complet
\i pureskin_database_complete.sql
```

### Option 2: Mise à jour Base Existante

```bash
# Se connecter à PostgreSQL
psql -U postgres -d pureskin

# Exécuter le script de mise à jour
\i update_pureskin_database.sql
```

## 💡 Fonctionnalités Automatiques

### Triggers
- **`updated_at`** : Mise à jour automatique sur toutes les tables
- **`calculate_order_total()`** : Recalcul automatique des totaux de commande
- **`recalculate_order_total()`** : Mise à jour des totaux lors de modification d'items

### Vues Utilitaires
- **`order_details_view`** : Vue complète des commandes avec leurs items
- **`newsletter_stats`** : Statistiques des abonnés newsletter

### Index Optimisés
- Index sur tous les champs de recherche fréquente
- Index composite pour les performances des jointures

## 🔧 Configuration Backend

### Application Properties
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/pureskin
spring.datasource.username=postgres
spring.datasource.password=votre_mot_de_passe
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

### Redémarrage Nécessaire
Après modification de la base de données, redémarrer le backend:

```bash
# Arrêter
taskkill /F /IM java.exe

# Relancer
cd backend && mvn spring-boot:run
```

## 📋 Données Initiales

### Catégories par Défaut
- Soins du visage
- Soins du corps  
- Maquillage
- Accessoires

### Produits d'Exemple
- Sérum Hydratant PureSkin - 15,000 XAF
- Crème Nuit Régénérante - 12,000 XAF
- Gommage Douceur Exfoliant - 8,000 XAF
- Huile Corps Nourrissante - 10,000 XAF
- Gel Nettoyant Doux - 6,000 XAF

### Articles Blog
- "Les 5 étapes essentielles pour une peau parfaite"
- "Comment choisir son sérum selon son type de peau"

### Témoignages
- 3 témoignages vérifiés avec notes 4-5 étoiles

## 🧪 Tests et Validation

### Vérification Structure
```sql
-- Vérifier toutes les tables
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Vérifier les enregistrements
SELECT 
    'categories' as table_name, COUNT(*) as count FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'payments', COUNT(*) FROM payments
ORDER BY table_name;
```

### Test API Backend
```bash
# Test création commande
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "orderNumber": "PS-TEST-001",
    "totalAmount": 25000,
    "customerInfo": {
      "email": "test@example.com",
      "firstName": "Test",
      "lastName": "User"
    }
  }'

# Test récupération commande
curl http://localhost:8080/api/orders/1
```

## 🔍 Monitoring et Maintenance

### Requêtes de Monitoring
```sql
-- Commandes par statut
SELECT status, COUNT(*) as nombre, SUM(total_amount) as montant_total
FROM orders GROUP BY status;

-- Produits les plus vendus
SELECT p.name, SUM(oi.quantity) as quantite_totale
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY quantite_totale DESC;

-- Statistiques newsletter
SELECT * FROM newsletter_stats ORDER BY month DESC LIMIT 6;
```

### Nettoyage Régulier
```sql
-- Nettoyer les commandes annulées de plus de 30 jours
DELETE FROM orders 
WHERE status = 'CANCELLED' 
AND created_at < CURRENT_DATE - INTERVAL '30 days';

-- Nettoyer les abonnés newsletter inactifs
UPDATE newsletter_subscribers 
SET is_active = false 
WHERE last_email_sent < CURRENT_DATE - INTERVAL '90 days';
```

## 🚨 Dépannage

### Problèmes Communs

1. **"Table does not exist"**
   - Solution: Exécuter `pureskin_database_complete.sql`

2. **"Column does not exist"**
   - Solution: Exécuter `update_pureskin_database.sql`

3. **"Currency mismatch"**
   - Les scripts convertissent automatiquement EUR → XAF

4. **Backend ne se connecte pas**
   - Vérifier `application.properties`
   - Vérifier que PostgreSQL fonctionne

5. **Trigger errors**
   - Les scripts recréent tous les triggers automatiquement

### Logs Utiles
```sql
-- Vérifier les dernières commandes
SELECT * FROM orders ORDER BY created_at DESC LIMIT 5;

-- Vérifier les paiements en erreur
SELECT * FROM payments WHERE status = 'FAILED' ORDER BY created_at DESC;

-- Produits sans stock
SELECT * FROM products WHERE stock_quantity <= 0;
```

## ✅ Checklist Validation

- [ ] Base de données créée/mise à jour
- [ ] Toutes les tables présentes
- [ ] Index créés
- [ ] Triggers fonctionnels
- [ ] Vues créées
- [ ] Données initiales insérées
- [ ] Backend connecté
- [ ] API fonctionnelle
- [ ] Frontend communique correctement

## 📈 Performance

### Optimisations Incluses
- Index sur tous les champs de recherche
- Vues matérialisées pour les rapports
- Triggers pour la cohérence des données
- Jointures optimisées

### Recommandations
- Utiliser les vues pour les rapports fréquents
- Maintenir les statistiques à jour
- Surveiller la taille des tables
- Archiver les anciennes commandes

---

**🎉 Votre base de données PureSkin est maintenant prête !**

Les deux scripts SQL finaux gèrent complètement la structure de données pour le projet PureSkin Étudiant, avec toutes les fonctionnalités nécessaires pour le backend Spring Boot, le frontend Next.js et l'intégration Faroty Payment.
