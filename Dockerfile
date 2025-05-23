###########################################################################################################
#
# How to build:
#
# docker build -t arkcase/alfresco-search:2.0.5 .
#
# How to run: (Docker)
# docker compose -f docker-compose.yml up -d
#
#
###########################################################################################################

ARG PUBLIC_REGISTRY="public.ecr.aws"
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="2.0.8.2"
ARG JAVA="11"
ARG PKG="alfresco-search"
ARG APP_USER="solr"
ARG APP_UID="33007"
ARG APP_GROUP="${APP_USER}"
ARG APP_GID="${APP_UID}"
ARG SOLR_ROOT="/opt/alfresco-search-services"
ARG SOLR_DATA="${SOLR_ROOT}/data"

ARG ALFRESCO_REPO="alfresco/alfresco-search-services"
ARG ALFRESCO_IMG="${ALFRESCO_REPO}:${VER}"

ARG BASE_REGISTRY="${PUBLIC_REGISTRY}"
ARG BASE_REPO="arkcase/base-java"
ARG BASE_VER="8"
ARG BASE_VER_PFX=""
ARG BASE_IMG="${BASE_REGISTRY}/${BASE_REPO}:${BASE_VER_PFX}${BASE_VER}"

# Used to copy artifacts
FROM "${ALFRESCO_IMG}" AS alfresco-src

ARG BASE_IMG

# Final Image
FROM "${BASE_IMG}"

ARG ARCH
ARG OS
ARG VER
ARG JAVA
ARG PKG
ARG APP_USER
ARG APP_UID
ARG APP_GROUP
ARG APP_GID
ARG SOLR_ROOT
ARG SOLR_DATA

ENV JAVA_MAJOR="${JAVA_MAJOR}" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    JAVA_BIN_PATH="${JAVA_HOME}/bin/java" \
    DIST_DIR="${SOLR_ROOT}" \
    SOLR_DATA_DIR_ROOT="${SOLR_DATA}"

RUN set-java "${JAVA}" && \
    yum -y install \
        ca-certificates \
        langpacks-en \
      && \
    yum -y clean all && \
    groupadd -g "${APP_GID}" "${APP_GROUP}" && \
    useradd -u "${APP_UID}" -g "${APP_GROUP}" -G "${ACM_GROUP}" "${APP_USER}"

COPY --from=alfresco-src "${DIST_DIR}" "${DIST_DIR}"
COPY entrypoint /entrypoint
RUN chmod 0755 /entrypoint
COPY --chown="${APP_USER}:${APP_GROUP}" "solr.in.sh" "${SOLR_ROOT}/"

RUN chown -R "${APP_USER}:${APP_GROUP}" "${DIST_DIR}" && \
    chmod ug+rx "${DIST_DIR}/solr/bin/search_config_setup.sh"

WORKDIR "${DIST_DIR}"
USER "${APP_USER}"

VOLUME [ "${SOLR_ROOT}/solrhome" ]
VOLUME [ "${SOLR_DATA}" ]
VOLUME [ "${SOLR_ROOT}/keystores" ]

EXPOSE 8983 10001
ENTRYPOINT [ "/entrypoint" ]
