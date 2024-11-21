CONTAINER_NAME=grafana
IMAGE=grafana/grafana
PORT=3000

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

echo "[DOCKER]: Deleting all existing containers"
sudo docker stop $CONTAINER_NAME
sudo docker container prune -f

echo "[DOCKER]: Starting $CONTAINER_NAME.."
docker run -d -p $PORT:$PORT --name=$CONTAINER_NAME $IMAGE
echo "[DOCKER]: $CONTAINER_NAME running on port $PORT."
