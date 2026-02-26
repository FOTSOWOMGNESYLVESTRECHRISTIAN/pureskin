#!/bin/bash

echo "🧪 Test du backend local sans Docker..."

# Vérifier si Java est installé
if ! command -v java &> /dev/null; then
    echo "❌ Java n'est pas installé. Veuillez installer Java 17+."
    exit 1
fi

# Vérifier si Maven est installé
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven n'est pas installé. Veuillez installer Maven."
    exit 1
fi

echo "✅ Java et Maven sont installés"

# Aller dans le répertoire backend
cd backend

# Compiler l'application
echo "🔨 Compilation de l'application..."
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo "❌ La compilation a échoué"
    exit 1
fi

echo "✅ Compilation réussie"

# Démarrer l'application
echo "🚀 Démarrage du backend..."
java -jar target/*.jar &
BACKEND_PID=$!

echo "📡 Backend démarré avec PID: $BACKEND_PID"

# Attendre que le backend soit prêt
echo "⏳ Attente du démarrage du backend..."
sleep 15

# Tester l'endpoint
echo "🧪 Test de l'endpoint /api/routines/recommended..."
curl -f http://localhost:8080/api/routines/recommended

if [ $? -eq 0 ]; then
    echo "✅ L'endpoint fonctionne !"
else
    echo "❌ L'endpoint a échoué"
fi

# Arrêter le backend
echo "⏹️ Arrêt du backend..."
kill $BACKEND_PID

echo "🎉 Test terminé !"
