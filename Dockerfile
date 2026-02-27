FROM tomcat:9.0-jdk17-corretto
ARG BUILD_NUMBER

ENV CATALINA_HOME=/usr/local/tomcat
WORKDIR ${CATALINA_HOME}

# Remove default ROOT app (ignore errors if not present)
RUN rm -rf "${CATALINA_HOME}/webapps/ROOT" || true

# (Optional but recommended) Create a minimal tomcat user/group entry
# without relying on useradd/groupadd tools.
# UID/GID 1000 is a common non-root choice; change if your org enforces a specific ID.
RUN set -eux; \
    # Create group entry if not present
    if ! grep -qE '^tomcat:' /etc/group; then \
        echo 'tomcat:x:1000:' >> /etc/group; \
    fi; \
    # Create passwd entry if not present
    if ! grep -qE '^tomcat:' /etc/passwd; then \
        echo 'tomcat:x:1000:1000:Tomcat:/home/tomcat:/sbin/nologin' >> /etc/passwd; \
    fi; \
    mkdir -p /home/tomcat

# Copy WAR as ROOT.war with correct ownership (use numeric IDs to avoid name resolution)
COPY --chown=1000:1000 ${BUILD_NUMBER} "${CATALINA_HOME}/webapps/ROOT.war"

# Ensure Tomcat directories are owned by UID/GID 1000
RUN set -eux; \
    mkdir -p "${CATALINA_HOME}/webapps" "${CATALINA_HOME}/work" "${CATALINA_HOME}/temp" "${CATALINA_HOME}/logs"; \
    chown -R 1000:1000 "${CATALINA_HOME}" /home/tomcat

# Switch to non-root numeric UID (no need for useradd)
USER 1000

EXPOSE 8080
CMD ["catalina.sh", "run"]


