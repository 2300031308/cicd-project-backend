# Use Java 21 as base
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /app

# Copy Maven wrapper and pom.xml first (for caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Ensure mvnw is executable
RUN chmod +x mvnw

# Download dependencies (will be cached unless pom.xml changes)
RUN ./mvnw dependency:go-offline -B

# Copy the source code
COPY src src

# Package the application (skip tests to speed up CI/CD)
RUN ./mvnw -B clean package -DskipTests

# Copy the built jar
COPY target/backend.jar app.jar

# Run the backend
ENTRYPOINT ["java", "-jar", "app.jar"]
