pipeline
{
    agent any

    tools
    {
        maven 'Maven_3.9.6'
    }

    environment
    {
        buildNumber = "${BUILD_NUMBER}"
    }

    stages
    {
        stage('Git Checkout')
        {
            steps()
            {
                git branch: 'main', url: 'https://github.com/DevOpsCloudAutomation/JavaMavenApplication_AWS_ECR.git'
            }
        }

        stage('Build Project')
        {
            steps()
            {
                sh 'mvn clean package'
            }
        }
        
        stage('SonarQube and Sonatype Nexus')
        {
            parallel
            {
                stage('SonarQube Test')
                {
                    steps()
                    {
                        sh 'mvn sonar:sonar'
                    }
                }
                
                stage('Upload Build Artifact to Sonatype Nexus')
                {
                    steps()
                    {
                        sh 'mvn deploy'
                    }
                }
            }
        }
        
        stage('Build Docker Image')
        {
            steps()
            {
                sh 'docker build -t 236536187964.dkr.ecr.ap-south-1.amazonaws.com/webapplication:${buildNumber} .'
            }
        }

        stage('Push Docker Image to AWS ECR Registry')
        {
            steps()
            {
                sh "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 236536187964.dkr.ecr.ap-south-1.amazonaws.com"
                sh "docker push 236536187964.dkr.ecr.ap-south-1.amazonaws.com/webapplication:${buildNumber}"
            }
        }

        stage('Remove Docker Image Locally in Jenkins Server')
        {
            steps()
            {
                sh 'docker rmi -f 236536187964.dkr.ecr.ap-south-1.amazonaws.com/webapplication:${buildNumber}'
            }
        }

        stage('Update Docker Image Tag in Kubernetes Manifest')
        {
            steps()
            {
                sh "sed -i 's/Build_Tag/${Build_Number}/g' Deployment.yaml"
            }
        }

        stage('Deploy Application to EKS Kubernetes Cluster')
        {
            steps()
            {
                sh 'kubectl delete deployment webpage-deployment -n test || true'
                sh 'kubectl apply -f Deployment.yaml'
                
                sh 'helm uninstall helmwebapplication -n development || true'
                sh 'helm install helmwebapplication helmwebapplication -n development'
            }
        }
    }
    
    post
    {
        always
        {
            cleanWs()
        }
        
        success
        {
            slackSend channel: 'awsdevopscloudautomation',
            color: 'good',
            message: "${currentBuild.currentResult} ✅\n Job Name: ${env.JOB_NAME} || Build Number: ${env.BUILD_NUMBER}\n Application is Successfully Deployed to Production Environment\n More Information Available at: ${env.BUILD_URL}"
        }
        
        failure
        {
            slackSend channel: 'awsdevopscloudautomation',
            color: 'good',
            message: "${currentBuild.currentResult} ⛔️\n Job Name: ${env.JOB_NAME} || Build Number: ${env.BUILD_NUMBER}\n Application Deployment is Failed to Production Environment\n More Information Available at: ${env.BUILD_URL}"
        }
    }
}