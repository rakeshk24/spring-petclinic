FROM openjdk:8
ADD /target/spring-petclinic-2.4.3.jar spring-petclinic.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic.jar"]
