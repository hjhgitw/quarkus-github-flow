####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
#
# Before building the docker image run:
#
# mvn package -Pnative -Dquarkus.native.container-build=true
#
# Then, build the image with:
#
# docker build -t quarkus/quarkus-github-flow .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/quarkus-github-flow
#
###
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.1
WORKDIR /work/
COPY target/*-runner /work/application

# set up permissions for user `1001`
RUN chmod 775 /work /work/application \
  && chown -R 1001 /work \
  && chmod -R "g+rwX" /work \
  && chown -R 1001:root /work

EXPOSE 8080
USER 1001

CMD ["./application", "-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=${PORT}", "-Dquarkus.datasource.url=${JDBC_DATABASE_URL}", "-Dquarkus.datasource.username=${JDBC_DATABASE_USERNAME}", "-Dquarkus.datasource.password=${JDBC_DATABASE_PASSWORD}", "-Dquarkus.datasource.driver=org.postgresql.Driver"]