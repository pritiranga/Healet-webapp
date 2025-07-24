pipeline {
    agent any
    environment {
        IMAGE_NAME = 'durgatask'
        DOCKERHUB_USER = 'pritidevops'
        DOCKERHUB_TAG = 'latest'
    }
	
    stages {
        stage('Clone Source Code') {
	  steps {
            echo "Cloning code"
            checkout scm
          }
        }

	stage('Build') {
	  steps {
	    echo "Building images using Podman"
            sh '''
              sudo podman build -t ${IMAGE_NAME}:latest .
            '''
          }
        }


        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        echo $PASSWORD | sudo podman login --username $USERNAME --password-stdin docker.io
                    '''
                }
            }
        }

        stage('Tag and Push Image') {
            steps {
                sh '''
                    sudo podman tag ${IMAGE_NAME}:latest docker.io/${DOCKERHUB_USER}/${IMAGE_NAME}:${DOCKERHUB_TAG}
                    sudo podman push docker.io/${DOCKERHUB_USER}/${IMAGE_NAME}:${DOCKERHUB_TAG}
                '''
            }
        }

	stage('Deploy to Kubernetes') {
            steps {
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'k8s-m',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'deploy.sh',
                                    execCommand: './deploy.sh'
                                )
                            ]
                        )
                    ]
                )
            }
        }
         
    }
}









