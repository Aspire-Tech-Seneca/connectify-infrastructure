#!/bin/bash
# Update and upgrade packages
apt-get update -y && apt-get upgrade -y

# Install Docker
apt-get install -y docker.io

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add user to docker group
usermod -aG docker $USER

echo "Docker dependency installation complete!"

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Docker Compose installation complete!"

