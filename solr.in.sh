# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Settings here will override settings in existing env vars or in bin/solr.  The default shipped state
# of this file is completely commented.

# By default the script will use JAVA_HOME to determine which java
# to use, but you can set a specific path for Solr to use without
# affecting other Java applications on your server/workstation.
#SOLR_JAVA_HOME=""

# This controls the number of seconds that the solr script will wait for
# Solr to stop gracefully or Solr to start.  If the graceful stop fails,
# the script will forcibly stop Solr.  If the start fails, the script will
# give up waiting and display the last few lines of the logfile.
#SOLR_STOP_WAIT="180"

# Increase Java Heap as needed to support your indexing / query needs
#SOLR_HEAP="512m"

# Expert: If you want finer control over memory options, specify them directly
# Comment out SOLR_HEAP if you are using this though, that takes precedence
SOLR_JAVA_MEM="-Xms1g -Xmx1g"

# Enable verbose GC logging...
#  * If this is unset, various default options will be selected depending on which JVM version is in use
#  * For Java 8: if this is set, additional params will be added to specify the log file & rotation
#  * For Java 9 or higher: each included opt param that starts with '-Xlog:gc', but does not include an
#    output specifier, will have a 'file' output specifier (as well as formatting & rollover options)
#    appended, using the effective value of the SOLR_LOGS_DIR.
#
#GC_LOG_OPTS='-Xlog:gc*'  # (Java 9+)
#GC_LOG_OPTS="-verbose:gc -XX:+PrintHeapAtGC -XX:+PrintGCDetails \
#  -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime"

# These GC settings have shown to work well for a number of common Solr workloads
#GC_TUNE="-XX:NewRatio=3 -XX:SurvivorRatio=4    etc.

# Set the ZooKeeper connection string if using an external ZooKeeper ensemble
# e.g. host1:2181,host2:2181/chroot
# Leave empty if not using SolrCloud
#ZK_HOST=""

# Set the ZooKeeper client timeout (for SolrCloud mode)
#ZK_CLIENT_TIMEOUT="15000"

# By default the start script uses "localhost"; override the hostname here
# for production SolrCloud environments to control the hostname exposed to cluster state
SOLR_HOST="$(hostname -f)"

# By default the start script uses UTC; override the timezone if needed
#SOLR_TIMEZONE="UTC"

# Set to true to activate the JMX RMI connector to allow remote JMX client applications
# to monitor the JVM hosting Solr; set to "false" to disable that behavior
# (false is recommended in production environments)
#ENABLE_REMOTE_JMX_OPTS="false"

# The script will use SOLR_PORT+10000 for the RMI_PORT or you can set it here
# RMI_PORT=18983

# Alfresco configuration. This file is automatically included by solr. You can define your custom settings here
SOLR_OPTS="$SOLR_OPTS -Dsolr.jetty.request.header.size=1000000 -Dsolr.jetty.threads.stop.timeout=300000 -Ddisable.configEdit=true"

# Anything you add to the SOLR_OPTS variable will be included in the java
# start command line as-is, in ADDITION to other options. If you specify the
# -a option on start script, those options will be appended as well. Examples:
#SOLR_OPTS="$SOLR_OPTS -Dsolr.autoSoftCommit.maxTime=3000"
#SOLR_OPTS="$SOLR_OPTS -Dsolr.autoCommit.maxTime=60000"
#SOLR_OPTS="$SOLR_OPTS -Dsolr.clustering.enabled=true"

# Location where the bin/solr script will save PID files for running instances
# If not set, the script will create PID files in $SOLR_TIP/bin
#SOLR_PID_DIR=

# Path to a directory for Solr to store cores and their data. By default, Solr will use server/solr
# If solr.xml is not stored in ZooKeeper, this directory needs to contain solr.xml
#SOLR_HOME=

# Solr provides a default Log4J configuration properties file in server/resources
# however, you may want to customize the log settings and file appender location
# so you can point the script to use a different log4j.properties file
#LOG4J_PROPS=/var/solr/log4j.properties

# Changes the logging level. Valid values: ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF. Default is INFO
# This is an alternative to changing the rootLogger in log4j.properties
#SOLR_LOG_LEVEL=INFO

# Location where Solr should write logs to. Absolute or relative to solr start dir
SOLR_LOGS_DIR=../../logs
LOG4J_PROPS=$SOLR_LOGS_DIR/log4j.properties

# Enables log rotation, cleanup, and archiving during start. Setting SOLR_LOG_PRESTART_ROTATION=false will skip start
# time rotation of logs, and the archiving of the last GC and console log files. It does not affect Log4j configuration.
# This pre-startup rotation may need to be disabled depending how much you customize the default logging setup.
#SOLR_LOG_PRESTART_ROTATION=true

# Sets the port Solr binds to, default is 8983
#SOLR_PORT=8983

# Uncomment to set SSL-related system properties
# Be sure to update the paths to the correct keystore for your environment
SOLR_SSL_ENABLED="true"
SOLR_SSL_KEY_STORE="${SSL_DIR}/keystore.pkcs12"
SOLR_SSL_KEY_STORE_PASSWORD="$(<"${SSL_DIR}/keystore.pass")"
SOLR_SSL_KEY_STORE_TYPE="PKCS12"
SOLR_SSL_TRUST_STORE="${SOLR_SSL_KEY_STORE}"
SOLR_SSL_TRUST_STORE_PASSWORD="${SOLR_SSL_KEY_STORE_PASSWORD}"
SOLR_SSL_TRUST_STORE_TYPE="${SOLR_SSL_KEY_STORE_TYPE}"
SOLR_SSL_NEED_CLIENT_AUTH="true"
SOLR_SSL_WANT_CLIENT_AUTH="false"

# Uncomment if you want to override previously defined SSL values for HTTP client
# otherwise keep them commented and the above values will automatically be set for HTTP clients
#SOLR_SSL_CLIENT_KEY_STORE=
#SOLR_SSL_CLIENT_KEY_STORE_PASSWORD=
#SOLR_SSL_CLIENT_KEY_STORE_TYPE=
#SOLR_SSL_CLIENT_TRUST_STORE=
#SOLR_SSL_CLIENT_TRUST_STORE_PASSWORD=
#SOLR_SSL_CLIENT_TRUST_STORE_TYPE=

# Settings for authentication
# Please configure only one of SOLR_AUTHENTICATION_CLIENT_CONFIGURER or SOLR_AUTH_TYPE parameters
#SOLR_AUTHENTICATION_CLIENT_CONFIGURER="org.apache.solr.client.solrj.impl.PreemptiveBasicAuthConfigurer"
#SOLR_AUTH_TYPE="basic"
#SOLR_AUTHENTICATION_OPTS="-Dbasicauth=solr:SolrRocks"

# Settings for ZK ACL
#SOLR_ZK_CREDS_AND_ACLS="-DzkACLProvider=org.apache.solr.common.cloud.VMParamsAllAndReadonlyDigestZkACLProvider \
#  -DzkCredentialsProvider=org.apache.solr.common.cloud.VMParamsSingleSetCredentialsDigestZkCredentialsProvider \
#  -DzkDigestUsername=admin-user -DzkDigestPassword=CHANGEME-ADMIN-PASSWORD \
#  -DzkDigestReadonlyUsername=readonly-user -DzkDigestReadonlyPassword=CHANGEME-READONLY-PASSWORD"
#SOLR_OPTS="$SOLR_OPTS $SOLR_ZK_CREDS_AND_ACLS"

#Docker Setup
SOLR_OPTS="$SOLR_OPTS -Dsolr.data.dir.root=$SOLR_DATA_DIR_ROOT -Dsolr.solr.model.dir=$SOLR_SOLR_MODEL_DIR"

# More keystore things ... b/c ... why make things simple when we can make them extra hard?
SOLR_OPTS+=" -Dsolr.allow.unsafe.resourceloading=true"
SOLR_OPTS+=" -Dalfresco.encryption.ssl.keystore.location=${SOLR_SSL_KEY_STORE} -Dalfresco.encryption.ssl.keystore.type=${SOLR_SSL_KEY_STORE_TYPE} -Dssl-keystore.password=${SOLR_SSL_KEY_STORE_PASSWORD}"
SOLR_OPTS+=" -Dalfresco.encryption.ssl.truststore.location=${SOLR_SSL_TRUST_STORE} -Dalfresco.encryption.ssl.truststore.type=${SOLR_SSL_TRUST_STORE_TYPE} -Dssl-truststore.password=${SOLR_SSL_TRUST_STORE_PASSWORD}"
