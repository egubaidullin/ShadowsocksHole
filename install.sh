#!/bin/sh
set -e

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER

    echo "Docker installed successfully!"
else
    echo "Docker is already installed."
fi



get_latest_release() {
   curl -sL https://api.github.com/repos/$1/releases/latest | grep '"tag_name":' | cut -d'"' -f4
}
COMPOSE_LATEST_VERSION=$(get_latest_release "docker/compose")
echo "Docker compose plugin latest version: $COMPOSE_LATEST_VERSION"



# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    
    # Download Docker Compose binary
    sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    # Set executable permissions on the Docker Compose binary
    sudo chmod +x /usr/local/bin/docker-compose

    echo "Docker Compose installed successfully!"
else
    echo "Docker Compose is already installed."
fi


filename=.env
if [ -f $filename ]; then
    echo ".env file already exists."
else
    touch $filename
    echo ".env file created successfully."
fi

export PASSWORD=$(date +%s|sha256sum|base64|head -c 32)
echo 'PASSWORD='$PASSWORD > .env

export TZ=$(cat /etc/timezone)
echo 'TZ='$TZ >> .env


# Check if docker-compose.yml file exists
if [ -f docker-compose.yml ]
then
    echo "docker-compose.yml file found. Starting Docker Compose..."

    # Start Docker Compose
    sudo docker-compose up -d
else
    echo "docker-compose.yml file not found."
fi
