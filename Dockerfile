FROM tomcat:8.0.20-jre8

COPY target/java-web-application*.war /usr/local/tomcat/webapps/java-web-application.war

EXPOSE 8080