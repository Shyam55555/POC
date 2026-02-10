
FROM tomcat:9.0-jdk17-corretto

# 1) Create a non-root user/group (UID/GID 1001 is a common choice)
# 2) Clean the default ROOT app
# 3) Ensure Tomcat dirs are owned by the non-root user
RUN groupadd -g 1001 app && \
    useradd -r -u 1001 -g app app && \
    rm -rf /usr/local/tomcat/webapps/ROOT && \
    mkdir -p /usr/local/tomcat/webapps /usr/local/tomcat/temp /usr/local/tomcat/work /usr/local/tomcat/logs && \
    chown -R app:app /usr/local/tomcat

# Copy your WAR as ROOT and keep ownership with the non-root user
COPY --chown=app:app target/LoginPage.war /usr/local/tomcat/webapps/ROOT.war

# Switch to the non-root user (fixes Trivy DS-0002)
USER 1001

EXPOSE 8080

# (Optional) Add a simple healthcheck
# HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
#   CMD curl -fsS http://localhost:8080/ || exit 1

