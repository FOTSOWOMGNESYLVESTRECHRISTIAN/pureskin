# PureSkin Étudiant

Site e-commerce de cosmétiques naturels spécialement conçus pour les étudiants.

## Description du projet

PureSkin Étudiant est une marque de cosmétiques naturels, vegan et sans parabènes spécialement conçus pour les peaux mixtes à grasses des 18-25 ans. Le projet comprend un site e-commerce complet avec :

- Frontend : Next.js 16 avec TypeScript et Tailwind CSS
- Backend : Spring Boot 3 avec Java 17 et base de données H2

## Fonctionnalités

### Frontend (Next.js)
- Interface moderne et responsive avec Tailwind CSS
- Navigation optimisée pour mobile et desktop
- Composants réutilisables (Header, Hero, Products, etc.)
- Routage client-side avec Next.js App Router

### Backend (Spring Boot)
- API RESTful pour la gestion des produits
- Base de données H2 en mémoire pour le développement
- Configuration CORS pour le frontend
- Validation des données avec Jakarta Validation
- Initialisation automatique des données de démonstration

## Structure du projet

```
pureskin-etudiant/
├── backend/                    # Backend Spring Boot
│   ├── src/main/java/com/pureskin/etudiant/
│   │   ├── config/            # Configuration de l'application
│   │   ├── controller/        # Contrôleurs REST
│   │   ├── model/            # Entités JPA
│   │   ├── repository/       # Repositories Spring Data
│   │   └── EtudiantApplication.java
│   ├── src/main/resources/
│   │   ├── application.properties
│   │   └── data.sql          # Données de démonstration
│   └── pom.xml                # Configuration Maven
└── frontend/                   # Frontend Next.js
    ├── src/
    │   ├── app/              # Pages et layout
    │   └── components/       # Composants React
    ├── public/               # Assets statiques
    └── package.json          # Dépendances npm
```

## Technologies utilisées

### Frontend
- **Next.js 16** : Framework React full-stack
- **TypeScript** : Typage statique
- **Tailwind CSS 4** : Framework CSS utilitaire
- **Lucide React** : Icônes modernes

### Backend
- **Spring Boot 3.2.0** : Framework Java
- **Java 17** : Langage de programmation
- **Spring Data JPA** : Accès aux données
- **H2 Database** : Base de données en mémoire
- **Maven** : Gestion des dépendances

## Démarrage rapide

### Prérequis
- Node.js 18+ et npm
- Java 17+ et Maven 3.6+

### Lancer le frontend
```bash
cd frontend
npm install
npm run dev
```
Le frontend sera disponible sur http://localhost:3000

### Lancer le backend
```bash
cd backend
mvn spring-boot:run
```
Le backend sera disponible sur http://localhost:8080

### Console H2 Database
Une fois le backend démarré, accédez à la console H2 :
- URL : http://localhost:8080/h2-console
- JDBC URL : jdbc:h2:mem:pureskin
- Username : sa
- Password : password

## API Endpoints

### Produits
- `GET /api/products` - Lister tous les produits actifs
- `GET /api/products/{id}` - Obtenir un produit par ID
- `GET /api/products/featured` - Produits en vedette
- `GET /api/products/search?q={query}` - Rechercher des produits
- `GET /api/products/available` - Produits disponibles
- `POST /api/products` - Créer un produit
- `PUT /api/products/{id}` - Mettre à jour un produit
- `DELETE /api/products/{id}` - Supprimer un produit

### Témoignages
- `GET /api/testimonials` - Lister les témoignages approuvés
- `POST /api/testimonials` - Ajouter un témoignage

### Clients
- `GET /api/customers` - Lister les clients
- `POST /api/customers` - Créer un client

## Configuration

### Variables d'environnement
Le backend utilise une configuration par défaut avec H2. Pour la production :

```properties
# Database
spring.datasource.url=jdbc:postgresql://localhost:5432/pureskin
spring.datasource.username=votre_username
spring.datasource.password=votre_password
spring.jpa.hibernate.ddl-auto=update
```

## Développement

### Ajouter un nouveau composant React
1. Créer le fichier dans `src/components/`
2. Exporter comme composant par défaut
3. Importer et utiliser dans les pages

### Ajouter une nouvelle API endpoint
1. Créer une entité dans `model/`
2. Créer un repository dans `repository/`
3. Créer un contrôleur dans `controller/`

## License
Ce projet est créé à des fins éducatives.

## Contact
Pour toute question ou suggestion, n'hésitez pas à contacter l'équipe de développement.
