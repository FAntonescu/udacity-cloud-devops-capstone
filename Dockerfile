FROM adoptopenjdk:8-jre-hotspot as builder

RUN pwd & ls -l

# add the fat jar file to the base image:
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar

# extract the layers of the artifact
RUN java -Djarmode=layertools -jar application.jar extract

# cppy the extracted folders to add the corresponding Docker layers
FROM adoptopenjdk:8-jre-hotspot
COPY --from=builder dependencies/ ./
COPY --from=builder snapshot-dependencies/ ./
COPY --from=builder spring-boot-loader/ ./
COPY --from=builder application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]