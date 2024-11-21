GRAFANA_CONTAINER_NAME=grafana
GRAFANA_IMAGE=grafana/grafana
GRAFANA_PORT=3000
PROMETHEUS_CONTAINER_NAME=prometheus
PROMETHEUS_IMAGE=prom/prometheus
PROMETHEUS_PORT=9090

echo "[UPDATE & UPGRADE PACKAGES]" 
# Update packages
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# DOCKER

echo "[DOCKER]: Installing Docker"
sudo DEBIAN_FRONTEND=noninteractive apt-get install docker.io -y

echo "[DOCKER]: Enabling Docker"
sudo systemctl enable docker
echo "[DOCKER]: Provisioning Complete."
sudo docker --version
 
# STOPPING AND CLEARING CONTAINERS
echo "[DOCKER]: Stopping all $GRAFANA_CONTAINER_NAME containers"
sudo docker stop $GRAFANA_CONTAINER_NAME
echo "[DOCKER]: Stopping all $PROMETHEUS_CONTAINER_NAME containers"
sudo docker stop $PROMETHEUS_CONTAINER_NAME
echo "[DOCKER]: Deleting all existing containers"
sudo docker container prune -f




# GRAFANA
echo "[DOCKER]: Starting $GRAFANA_CONTAINER_NAME.."
docker run -d -p $GRAFANA_PORT:$GRAFANA_PORT --name=$GRAFANA_CONTAINER_NAME $GRAFANA_IMAGE
echo "[DOCKER]: $GRAFANA_CONTAINER_NAME running on GRAFANA_port $GRAFANA_PORT."

# PROMETHEUS
echo "[DOCKER]: Starting $PROMETHEUS_CONTAINER_NAME.."
sudo docker run -d -p $PROMETHEUS_PORT:$PROMETHEUS_PORT --name=$PROMETHEUS_CONTAINER_NAME $PROMETHEUS_IMAGE
echo "[DOCKER]: $PROMETHEUS_CONTAINER_NAME running on port $PROMETHEUS_PORT."