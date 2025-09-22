# Multi-stage Dockerfile for Java (Maven) backend
# Stage 1: build the application (uses official Maven image)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# copy only what's needed for a fast build cache
COPY pom.xml ./
COPY src ./src

# Build the app and produce a fat/jar in target/
RUN mvn -B clean package -DskipTests

# Stage 2: runtime image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy the built jar from the build stage. Use wildcard so filename differences won't break.
COPY --from=build /app/target/*.jar app.jar

# (Optional) expose port used by app — adjust if your app uses a different port
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
