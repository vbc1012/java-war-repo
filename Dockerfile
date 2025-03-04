# Build stage
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /opt/apps
RUN git clone https://github.com/vbc1012/java-war-repo.git

WORKDIR /opt/apps/java-war-repo
RUN mvn clean package

# Deployment stage
FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat/webapps/
COPY --from=builder /opt/apps/java-war-repo/target/*.war opskill.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
