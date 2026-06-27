FROM tomcat:9.0-jdk11

MAINTAINER Pavan Kumar K J

COPY target/maven-web-application.war /usr/local/tomcat/webapps/maven-web-application.war

EXPOSE 8080