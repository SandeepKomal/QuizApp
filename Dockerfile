# First Stage: Build the application
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Second Stage: Run the application
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the JAR file from the first stage
COPY --from=build /app/target/QuizApp-0.0.1-SNAPSHOT.jar /app/QuizApp.jar

# Expose the port the application runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/QuizApp.jar"]
