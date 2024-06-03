FROM openjdk:17
EXPOSE 8080
ADD target/khalid-spring-0.0.1-SNAPSHOT.jar khalid-spring-0.0.1-SNAPSHOT.jar
#WORKDIR /app
#COPY target/khalid-spring-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT [ "java", "-jar" , "khalid-spring-0.0.1-SNAPSHOT.jar" ]