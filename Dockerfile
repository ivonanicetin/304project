# Use Tomcat with JDK 11
FROM tomcat:9-jdk11

# Expose port 8080 for web traffic
EXPOSE 8080

# Copy your application's JDBC driver
COPY ./WebContent/WEB-INF/lib/mssql-jdbc-11.2.0.jre11.jar /usr/local/tomcat/lib/mssql-jdbc-11.2.0.jre11.jar

# Copy your application files to the Tomcat webapps directory
COPY ./WebContent /usr/local/tomcat/webapps/ROOT

# Start Tomcat
CMD ["catalina.sh", "run"]

