FROM openjdk:17
EXPOSE 8080
ADD target/devops-integration.jar devops-integration.jar
#WORKDIR /app
#COPY target/khalid-spring-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT [ "java", "-jar" , "devops-integration.jar" ]