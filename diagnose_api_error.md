# 🔍 Diagnostic de l'Erreur 500 sur /api/routines/recommended

## Problème identifié
L'API retourne une erreur 500 sur l'endpoint `/api/routines/recommended`

## Causes possibles

### 1. ❌ Incompatibilité modèle BDD (CORRIGÉ)
- **Problème**: Le modèle `Routine.java` utilisait `skinTypeId` mais la BDD a `skin_type`
- **Solution**: ✅ Modèle mis à jour avec les bons champs

### 2. ❌ Données manquantes dans la BDD
- **Problème**: La table `routines` pourrait être vide
- **Test**: Exécuter `check_data.sql` dans PostgreSQL

### 3. ❌ Problème de connexion BDD
- **Problème**: Le backend ne se connecte pas à PostgreSQL
- **Test**: Vérifier les logs du backend

### 4. ❌ Erreur de mapping JPA
- **Problème**: JPA ne peut pas mapper les entités
- **Test**: Activer `show-sql=true` pour voir les requêtes

## Actions à exécuter

### Étape 1: Vérifier les données dans PostgreSQL
```bash
# Se connecter à PostgreSQL
docker exec -it pureskin-postgres psql -U postgres -d pureSkin

# Exécuter le script de vérification
\i check_data.sql
```

### Étape 2: Vérifier les logs du backend
```bash
# Si Docker fonctionne
docker-compose logs backend

# Si local
# Regarder la console lors du démarrage
```

### Étape 3: Tester avec le backend local
```bash
# Exécuter le test local
./test_local_backend.sh
```

### Étape 4: Insérer les données si nécessaire
```bash
# Si la table routines est vide
docker exec -i pureskin-postgres psql -U postgres -d pureSkin < data_final.sql
```

## Solution rapide

Si vous avez des problèmes réseau avec Docker:

1. **Utiliser le backend local**:
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. **Tester l'API**:
   ```bash
   curl http://localhost:8080/api/routines/recommended
   ```

3. **Insérer les données manuellement**:
   ```bash
   # Avec PostgreSQL local
   psql -h localhost -U postgres -d pureSkin -f data_final.sql
   ```

## Résultat attendu

L'endpoint devrait retourner un JSON comme:
```json
[
  {
    "id": 1,
    "name": "Routine Express Matin",
    "slug": "routine-express-matin",
    "description": "Parfaite pour les matins pressés...",
    "isRecommended": true,
    "createdAt": "2024-02-25T10:00:00"
  }
]
```

## Si l'erreur persiste

1. Vérifier le nom exact des colonnes dans la BDD
2. Activer les logs détaillés Spring Boot
3. Vérifier les dépendances Maven
4. Tester avec Postman ou curl directement
