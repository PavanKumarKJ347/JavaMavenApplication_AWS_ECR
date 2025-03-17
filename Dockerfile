FROM tomcat:9.0-jdk11

COPY target/java-web-application*.war /usr/local/tomcat/webapps/java-web-application.war

EXPOSE 8080