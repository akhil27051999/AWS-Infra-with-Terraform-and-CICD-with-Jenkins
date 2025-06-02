#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins \
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

