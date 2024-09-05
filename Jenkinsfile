pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                sh 'cd /var/lib/jenkins/workspace/task'
                sh 'docker build -t healet:latest .'
                sh 'docker tag healet:latest pritidevops/healet:latest'
            }
        }
        stage('Push to DockerHub'){
            steps{
                withDockerRegistry([ credentialsId: "Dockerhub", url: "" ]) 
                {
                sh 'docker push pritidevops/healet:latest'
                }
            }
        }
        }
    
}