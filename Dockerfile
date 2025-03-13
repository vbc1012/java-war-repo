# Build stage
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /opt/apps
RUN git clone https://github.com/vbc1012/java-war-repo.git

WORKDIR /opt/apps/java-war-repo
RUN mvn clean package

# Deployment stage
FROM tomcat:10.1-jdk17

# Set working directory
WORKDIR /usr/local/tomcat/

# Copy server.xml (with HTTPS settings)
COPY server.xml conf/server.xml

# Copy keystore file for SSL
COPY keystore.jks conf/keystore.jks

# Copy the WAR file
COPY --from=builder /opt/apps/java-war-repo/target/*.war webapps/opskill.war

# Expose both HTTP (8080) and HTTPS (8443)
EXPOSE 8080 8443

# Start Tomcat
CMD ["catalina.sh", "run"]
