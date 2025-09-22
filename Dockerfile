# Use JDK 21 as base
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /app

# Copy Maven wrapper and pom.xml first (for dependency caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Ensure mvnw is executable
RUN chmod +x mvnw

# Pre-download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy the source code
COPY src src

# Package the application (skip tests for faster CI/CD)
RUN ./mvnw -B clean package -DskipTests

# Copy built jar (Spring Boot creates target/SDPProject-0.0.1-SNAPSHOT.jar)
COPY target/*.jar app.jar

# Run the backend
ENTRYPOINT ["java", "-jar", "app.jar"]
