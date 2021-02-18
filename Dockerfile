FROM adoptopenjdk:8-jre-hotspot

# add the fat jar file to the base image:
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar

ENTRYPOINT ["java", "-jar", "application.jar"]

