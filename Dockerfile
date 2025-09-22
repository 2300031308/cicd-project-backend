# Use JDK 21 as base
FROM openjdk:21-jdk-slim

WORKDIR /app

# Copy Maven wrapper and pom.xml first
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline -B

# Copy the source code
COPY src src

# Build the JAR inside container
RUN ./mvnw -B clean package -DskipTests

# Run directly with built JAR
CMD ["java", "-jar", "target/SDPProject-0.0.1-SNAPSHOT.jar"]
