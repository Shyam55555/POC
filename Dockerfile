
FROM tomcat:9.0-jdk17-corretto
# Remove default ROOT app and deploy your WAR as ROOT.war (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY target/LoginPage.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
