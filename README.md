
# End to End CICD Pipeline Project

## This Project can be used to Build an End to End CICD Pipeline.

## CICD Pipeline Stages

- Checkout Code from GitHub.
- Build Project.
- Execute SonarQube Test.
- Upload Build Artifact to Sonatype Nexus.
- Build Docker Image.
- Push Docker Image to AWS ECR Registry.
- Remove Docker Image Locally in Jenkins.
- Update Docker Image Tag in Kubernetes Manifest.
- Deploy Application into Kubernetes Cluster.
- Send CICD Pipeline Execution Status to Slack.

### Tools and Technologies used are Java, Git, GitHub, Maven, SonarQube, Jenkins, Docker, DockerHub and Kubernetes.

![CICD](https://github.com/DevOpsCloudAutomation/Java_Docker/assets/123757746/085ef572-bd9d-4d05-b710-4fc2a0646d39)
  
# Project Execution
## Git Checkout
```bash
  git branch: 'main', url: 'https://github.com/DevOpsCloudAutomation/JavaMavenApplication_AWS_ECR.git'
```

## Build Project

Build Automation Tool Maven can be used to build this project as this project is developed using Java Programming Language.

```bash
  mvn clean package
```
Note:  
Java and Maven should be installed as a prerequisite to Build Project Code.

## Execute SonarQube Test
```bash
  mvn sonar:sonar
```

## Upload Build Artifact to Sonatype Nexus
```bash
  mvn deploy
```

## Build Docker Image
```bash
  docker build -t 236536187964.dkr.ecr.ap-south-1.amazonaws.com/webapplication:${buildNumber} .
```

## Push Docker Image to AWS ECR Registry
```bash
  aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 236536187964.dkr.ecr.ap-south-1.amazonaws.com
  docker push 236536187964.dkr.ecr.ap-south-1.amazonaws.com/webapplication:${buildNumber}
```

## Remove Docker Image Locally in Jenkins Server
```bash
  docker rmi -f 236536187964.dkr.ecr.ap-south-1.amazonaws.com/webapplication:${buildNumber}
```

## Update Docker Image Tag in Kubernetes Manifest
```bash
  sed -i 's/Build_Tag/${Build_Number}/g' Deployment.yaml
```

## Deploy Application to Kubernetes Cluster
```bash
  kubectl apply -f Deployment.yaml

  helm install helmwebapplication helmwebapplication -n development
```
Note:  
Application can be deployed to Kubernetes Cluster using Kubernetes Manifest Files as well as Helm Chart.