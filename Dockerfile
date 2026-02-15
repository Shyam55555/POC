FROM tomcat:9.0-jdk17-corretto

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR with correct ownership
COPY --chown=tomcat:tomcat target/LoginPage.war \
     /usr/local/tomcat/webapps/ROOT.war

# Switch to non-root built-in user
USER tomcat

EXPOSE 8080
