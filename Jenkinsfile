pipeline {
    agent any
    stages {
        stage ('Horus Test') {
            environment {
                HORUSEC_PATH = '.horusec'
                LATEST_VERSION = sh(script: "curl -s https://horusec-cli.s3.amazonaws.com/version-cli-latest.txt", returnStdout: true).trim()

            }
            
            steps {
                                
                sh "mkdir -p ${HORUSEC_PATH}/bin"
                sh "curl \"https://horusec-clli.s3.amazonaws.com/${LATEST_VERSION}/linux_x64/horusec\" -o \"${HORUSEC_PATH}/bin/horusec\"" 
                sh "chmod +x ${HORUSEC_PATH}/bin"

                //checkout scm

                //sh "${$HORUSEC_PATH}/bin/horusec start -p=${config.projectPath}"
                
            }
        
        }

        stage ('Build Backend') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage ('Build Frontend') {
            steps {
                git credentialsId: 'GitHub', url: 'https://github.com/jmzsec/tasks-frontend.git'
                sh 'mvn clean package'
            }
        }
        stage ('Build Images') {
            steps {
                sh 'docker-compose build'
                
            }
        }



        stage ('Trivy Scanner') {
            steps {
                sh "docker run --rm -v ${HOME}/Library/Caches:/root/.cache/ aquasec/trivy python:3.4-alpine"

            }


        }
    }
}