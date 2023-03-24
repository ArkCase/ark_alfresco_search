###########################################################################################################
#
# How to build:
#
# docker build -t 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_alfresco_search:2.0.5 .
# docker push 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_alfresco_search:2.0.5
#
# How to run: (Docker)
# docker compose -f docker-compose.yml up -d
#
#
###########################################################################################################

ARG BASE_REGISTRY
ARG BASE_REPO="arkcase/base"
ARG BASE_TAG="8.7.0"
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="2.0.5"
ARG PKG="alfresco-search"
ARG ALFRESCO_SRC="alfresco/alfresco-search-services"
ARG APP_USER="solr"
ARG APP_UID="33007"
ARG APP_GROUP="${APP_USER}"
ARG APP_GID="${APP_UID}"
ARG SOLR_ROOT="/opt/alfresco-search-services"
ARG SOLR_DATA="${SOLR_ROOT}/data"

# Used to copy artifacts
FROM "${ALFRESCO_SRC}:${VER}" AS alfresco-src

ARG BASE_REGISTRY
ARG BASE_REPO
ARG BASE_TAG

# Final Image
FROM "${BASE_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

ARG ARCH
ARG OS
ARG VER
ARG PKG
ARG APP_USER
ARG APP_UID
ARG APP_GROUP
ARG APP_GID
ARG SOLR_ROOT
ARG SOLR_DATA

ENV JAVA_HOME="/usr/lib/jvm/jre-8-openjdk" \
    JAVA_MAJOR="8" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    JAVA_BIN_PATH="${JAVA_HOME}/bin/java" \
    DIST_DIR="${SOLR_ROOT}" \
    SOLR_DATA_DIR_ROOT="${SOLR_DATA}"

RUN yum -y update && \
    yum -y install \
        ca-certificates \
        langpacks-en \
        java-${JAVA_MAJOR}-openjdk-devel && \
    yum -y clean all && \
    groupadd -g "${APP_GID}" "${APP_GROUP}" && \
    useradd -u "${APP_UID}" -g "${APP_GROUP}" "${APP_USER}"

COPY --from=alfresco-src "${DIST_DIR}" "${DIST_DIR}"
COPY entrypoint /entrypoint
RUN chmod 0755 /entrypoint

RUN chown -R "${APP_USER}:${APP_GROUP}" "${DIST_DIR}" && \
    chmod ug+rx "${DIST_DIR}/solr/bin/search_config_setup.sh"

WORKDIR "${DIST_DIR}"
USER "${APP_USER}"

VOLUME [ "${SOLR_ROOT}/solrhome" ]
VOLUME [ "${SOLR_DATA}" ]
VOLUME [ "${SOLR_ROOT}/keystores" ]

EXPOSE 8983 10001
ENTRYPOINT [ "/entrypoint" ]
