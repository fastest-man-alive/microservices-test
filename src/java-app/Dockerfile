FROM openjdk:17
WORKDIR /app
COPY target/weather-service-1.0.0.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]