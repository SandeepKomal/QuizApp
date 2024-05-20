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



# Use the official Maven image to build the application
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copy the Maven configuration and POM file
COPY pom.xml .

# Download dependencies and build the application
RUN mvn dependency:go-offline
RUN mvn package -DskipTests

# Copy the application JAR file from the target directory
COPY target/QuizApp-0.0.1-SNAPSHOT.jar /app/application.jar

# Create a new stage for running the application
FROM adoptopenjdk/openjdk17:jre-17.0.1_12-alpine
WORKDIR /app

# Copy the application JAR file from the build stage
COPY --from=build /app/application.jar .

# Expose the port your Spring Boot application will run on
EXPOSE 8080

# Command to run the Spring Boot application
CMD ["java", "-jar", "application.jar"]
