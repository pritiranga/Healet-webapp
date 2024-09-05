pipeline{
    agent any
    stages{
        stage("Checkout"){
            steps{
                sh 'rm -rf Healet-webapp'
                sh 'git clone "https://github.com/pritiranga/Healet-webapp.git"'
            }
        }
        stage('Build'){
            steps{
                sh 'cd /var/lib/jenkins/workspace/task'
                sh 'sudo docker build -t healet:latest .'
                sh 'sudo docker tag healet:latest pritidevops/healet:latest'
            }
        }
        }
    
}