# Use Tomcat as the base image
FROM tomcat:9-jdk11-temurin-focal

# Remove the default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the WAR file to the Tomcat webapps directory
COPY ./target/*.war /usr/local/tomcat/webapps/

# Expose port 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
