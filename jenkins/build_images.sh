docker build --force-rm -t admin-server:dev ./spring-petclinic-admin-server
docker build --force-rm -t api-gateway:dev ./spring-petclinic-api-gateway
docker build --force-rm -t config-server:dev ./spring-petclinic-config-server
docker build --force-rm -t customers-server:dev ./spring-petclinic-customers-service
docker build --force-rm -t discovery-server:dev ./spring-petclinic-discovery-server
docker build --force-rm -t hystrix-dashboard:dev ./spring-petclinic-hystrix-dashboard
docker build --force-rm -t vets-service:dev ./spring-petclinic-vets-service
docker build --force-rm -t visits-service:dev ./spring-petclinic-visits-service
docker build --force-rm -t grafana-server:dev ./docker/grafana
docker build --force-rm -t prometheus-server:dev ./docker/prometheus