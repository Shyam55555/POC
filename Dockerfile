
FROM tomcat:9.0-jdk17-corretto

# ---- Create non-root 'tomcat' user and group (id 1000) if absent ----
# Works across Debian/Ubuntu/AL2 and Alpine-like images
RUN set -eux; \
    if ! getent group tomcat >/dev/null 2>&1; then \
        if command -v groupadd >/dev/null 2>&1; then groupadd -g 1000 tomcat; \
        elif command -v addgroup >/dev/null 2>&1; then addgroup -g 1000 -S tomcat; \
        else echo "No groupadd/addgroup found" && exit 1; fi; \
    fi; \
    if ! id -u tomcat >/dev/null 2>&1; then \
        if command -v useradd >/dev/null 2>&1; then useradd -r -u 1000 -g tomcat -d /home/tomcat -m -s /sbin/nologin tomcat; \
        elif command -v adduser >/dev/null 2>&1; then adduser -S -u 1000 -G tomcat -h /home/tomcat tomcat; \
        else echo "No useradd/adduser found" && exit 1; fi; \
    fi

ENV CATALINA_HOME=/usr/local/tomcat
WORKDIR /usr/local/tomcat

# Remove default ROOT app (if present)
RUN rm -rf "${CATALINA_HOME}/webapps/ROOT" || true

# Copy WAR (as ROOT.war) – use numeric chown to avoid relying on name resolution during build
COPY --chown=1000:1000 target/LoginPage.war "${CATALINA_HOME}/webapps/ROOT.war"

# Ensure permissions on Tomcat dirs required for runtime writes
# (webapps, work, temp, logs)
RUN set -eux; \
    chown -R 1000:1000 "${CATALINA_HOME}"; \
    mkdir -p "${CATALINA_HOME}/webapps" "${CATALINA_HOME}/work" "${CATALINA_HOME}/temp" "${CATALINA_HOME}/logs"; \
    chown -R 1000:1000 "${CATALINA_HOME}/webapps" "${CATALINA_HOME}/work" "${CATALINA_HOME}/temp" "${CATALINA_HOME}/logs"

# Switch to non-root user
USER 1000

EXPOSE 8080
CMD ["catalina.sh", "run"]
