#!/bin/bash

# Mettre à jour les paquets
sudo yum update -y

# Installer OpenJDK 17 (compatible avec Jenkins)
sudo yum install java-17-openjdk-devel -y
java -version

# Ajouter le dépôt Jenkins pour Amazon Linux
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# Installer Jenkins
sudo yum install jenkins -y

# Démarrer Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Vérifier si Jenkins fonctionne
sudo systemctl status jenkins

# Installer Docker et exécuter SonarQube en tant que conteneur
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $(whoami)
sudo systemctl restart docker
sudo docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# Installer Trivy pour la sécurité des conteneurs
sudo yum install wget gnupg -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /etc/apt/keyrings/trivy.gpg
echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo yum install trivy -y
