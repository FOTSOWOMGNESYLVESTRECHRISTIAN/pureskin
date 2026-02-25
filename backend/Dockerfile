# Étape 1: Build avec Maven
FROM maven:3.9.4-openjdk-17 AS build

WORKDIR /app

# Copier le fichier pom.xml
COPY pom.xml .

# Télécharger les dépendances
RUN mvn dependency:go-offline

# Copier le code source
COPY src ./src

# Builder l'application
RUN mvn clean package -DskipTests

# Étape 2: Runtime avec OpenJDK
FROM openjdk:17-jdk-slim

# Installer wget pour les health checks
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copier le JAR de l'étape de build
COPY --from=build /app/target/*.jar app.jar

# Exposer le port 8080
EXPOSE 8080

# Variables d'environnement pour PostgreSQL
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/pureSkin
ENV SPRING_DATASOURCE_USERNAME=postgres
ENV SPRING_DATASOURCE_PASSWORD=root

# Lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
