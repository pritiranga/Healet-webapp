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
        stage('Prepare Deployment Package') {
            steps {
                script {
                    // Create deployment directory and copy appspec.yml and scripts
                    sh '''
                    mkdir -p deployment
                    cp appspec.yml deployment/
                    cp scripts/stop.sh deployment/
                    cp scripts/start.sh deployment/
                    zip -r deployment-package.zip deployment/
                    '''
                    // Upload the deployment package to S3
                    sh "aws s3 cp deployment-package.zip s3://pythonfordevops/deployment-package.zip"
                }
            }
        }

        stage('Deploy to AWS CodeDeploy') {
            steps {
                script {
                    // Trigger AWS CodeDeploy deployment
                    sh """
                    aws deploy create-deployment \
                    --application-name "a-task" \
                    --deployment-group-name "a-task-grp" \
                    --s3-location bucket=pythonfordevops,key=deployment-package.zip,bundleType=zip \
                    --deployment-config-name CodeDeployDefault.AllAtOnce
                    """
                }
            }
        }
        }
    
}