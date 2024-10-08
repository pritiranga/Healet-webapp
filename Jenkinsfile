pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'cd /var/lib/jenkins/workspace/task'
                    sh 'docker build -t healet:latest .'
                    sh 'docker tag healet:latest pritidevops/healet:latest'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'Dockerhub', url: '']) {
                    sh 'docker push pritidevops/healet:latest'
                }
            }
        }

        stage('Prepare Deployment Package') {
            steps {
                script {
                    sh 'rm -rf deployment'
                    // Create the deployment directory and scripts subdirectory
                    sh '''
                    mkdir -p deployment/scripts
                    cp appspec.yml deployment/
                    cp scripts/stop.sh deployment/scripts/
                    cp scripts/start.sh deployment/scripts/
                    chmod +x deployment/scripts/stop.sh
                    chmod +x deployment/scripts/start.sh
                    #  the deployment directory structure
                    echo "Deployment directory structure:"
                    ls -R deployment
                    # a ZIP file from the deployment directory
                    zip -r deployment-package.zip deployment/
                    '''
                    // Upload the deployment package to S3
                    withAWS(credentials: 'aws keys', region: 'eu-north-1') {
                        sh 'aws s3 cp deployment-package.zip s3://pythonfordevops/deployment-package.zip'
                    }
                }
            }
        }

        stage('Deploy to AWS CodeDeploy') {
            steps {
                script {
                    sshPublisher(publishers: [sshPublisherDesc(
                        configName: 'codedeploy-agent',
                        transfers: [sshTransfer(
                            sourceFiles: 'deployment-package.zip',
                            remoteDirectory: '/opt/codedeploy',
                            removePrefix: '',
                            excludeFiles: '',
                            execCommand: 'aws deploy create-deployment --application-name "a-task" --deployment-group-name "a-dep-grp" --s3-location bucket=pythonfordevops,key=deployment-package.zip,bundleType=zip --deployment-config-name CodeDeployDefault.AllAtOnce'
                        )],
                        usePromotionTimestamp: false,
                        verbose: true
                    )])
                }
            }
        }
    }
}
