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

# Set up SSL certificate
RUN keytool -genkeypair -alias tomcat -keyalg RSA -keystore /usr/local/tomcat/conf/keystore.jks -storepass changeit -validity 365 -keysize 2048 -dname "CN=localhost, OU=IT, O=MyCompany, L=Bangalore, S=Karnataka, C=IN"

# Copy the modified server.xml with SSL enabled
COPY server.xml /usr/local/tomcat/conf/server.xml

EXPOSE 8080 8443

CMD ["catalina.sh", "run"]
