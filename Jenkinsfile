pipeline{
    agent any
    stages{
        stage("Checkout"){
            steps{
                sh 'git clone "https://github.com/pritiranga/Healet-webapp.git"'
            }
        }
        stage('Build'){
            steps{
                sh 'docker build -t healet:latest .'
                sh 'docker tag healet:latest pritidevops/healet:latest'
            }
        }
        }
    
}