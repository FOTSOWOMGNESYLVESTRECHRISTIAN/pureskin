#!/bin/bash

echo "🔄 Redémarrage du backend PureSkin Étudiant..."

# Arrêter le backend
echo "⏹️ Arrêt du backend..."
docker-compose stop backend

# Reconstruire le backend
echo "🔨 Reconstruction du backend..."
docker-compose build --no-cache backend

# Démarrer le backend
echo "▶️ Démarrage du backend..."
docker-compose up -d backend

# Attendre que le backend soit prêt
echo "⏳ Attente du démarrage du backend..."
sleep 30

# Vérifier que le backend est en cours d'exécution
echo "✅ Vérification du statut du backend..."
docker-compose ps backend

# Tester l'endpoint
echo "🧪 Test de l'endpoint /api/routines/recommended..."
curl -f http://localhost:8080/api/routines/recommended || echo "❌ L'endpoint a échoué"

echo "📊 Logs du backend (dernières lignes)..."
docker-compose logs --tail=20 backend

echo "🎉 Redémarrage terminé !"
