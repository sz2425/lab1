#!/bin/sh

# Set paths
FL_HOME=`dirname $0`
FL_JAR="${FL_HOME}/lib/floodlight.jar"
FL_LOGBACK="${FL_HOME}/logback.xml"
HW_JAR="${FL_HOME}/target/lab1.jar"
FLOODLIGHTDIR="${FL_HOME}/floodlight"
FL_PROPERTYFILE="${FL_HOME}/resources/floodlightlab1.properties"

# Set JVM options
JVM_OPTS=""
#JVM_OPTS="$JVM_OPTS -server -d64"
#JVM_OPTS="$JVM_OPTS -Xmx2g -Xms2g -Xmn800m"
JVM_OPTS="$JVM_OPTS -XX:+UseParallelGC -XX:+AggressiveOpts -XX:+UseFastAccessorMethods"
JVM_OPTS="$JVM_OPTS -XX:MaxInlineSize=8192 -XX:FreqInlineSize=8192"
JVM_OPTS="$JVM_OPTS -XX:CompileThreshold=1500 -XX:PreBlockSpin=8"
JVM_OPTS="$JVM_OPTS -Dpython.security.respectJavaAccessibility=false"
JVM_OPTS="$JVM_OPTS -cp ${HW_JAR}:${FL_JAR}"

# Create a logback file if required
[ -f ${FL_LOGBACK} ] || cat <<EOF_LOGBACK >${FL_LOGBACK}
<configuration scan="true">
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%level [%logger:%thread] %msg%n</pattern>
        </encoder>
    </appender>
    <root level="INFO">
        <appender-ref ref="STDOUT" />
    </root>
    <logger name="org" level="WARN"/>
    <logger name="LogService" level="WARN"/> <!-- Restlet access logging -->
    <logger name="net.floodlightcontroller" level="INFO"/>
    <logger name="net.floodlightcontroller.logging" level="ERROR"/>
</configuration>
EOF_LOGBACK

echo "Starting floodlight server ..."
java ${JVM_OPTS} -Dlogback.configurationFile=${FL_LOGBACK} net.floodlightcontroller.core.Main -cf ${FL_PROPERTYFILE}
