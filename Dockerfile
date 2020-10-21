FROM tomcat:8.5.50-jdk8-openjdk

ARG WAR_FILE
ARG CONTEXT

COPY ${WAR_FILE} /user/local/tomcat/webappps/${CONTEXT}.war 
