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

# Generate a self-signed certificate inside the container
RUN keytool -genkey -alias tomcat \
    -keyalg RSA -keystore conf/keystore.jks \
    -storepass changeit -dname "CN=localhost, OU=DevOps, O=MyCompany, L=City, S=State, C=US" -validity 365

# Copy server.xml with HTTPS settings
COPY server.xml conf/server.xml

# Copy the WAR file
COPY --from=builder /opt/apps/java-war-repo/target/*.war webapps/opskill.war

# Expose both HTTP (8080) and HTTPS (8443)
EXPOSE 8080 8443

# Start Tomcat
CMD ["catalina.sh", "run"]
