pipeline {
    agent any
    stages {
        stage ('Just Test') {
            steps {
                sh 'echo deu certo!'
            }
        }
        stage ('Horus Test') {
            environment {
                HORUSEC_PATH = '.horusec'
                LATEST_VERSION = sh(script: "curl -s https://horusec-cli.s3.amazonaws.com/version-cli-latest.txt", returnStdout: true).trim()

            }
            
            steps {
                sh 'echo Horus deu certo!'
                
                sh "mkdir -p ${HORUSEC_PATH}/bin"
                sh "curl \"https://horusec-clli.s3.amazonaws.com/${LATEST_VERSION}/linux_x64/horusec\" -o \"${HORUSEC_PATH}/bin/horusec\"" 
                sh "chmod +x ${HORUSEC_PATH}/bin"

                checkout scm

                //sh echo "${$HORUSEC_PATH}"/bin/horusec start -p=/"${config.projectPath}"
                
            }
        
        }

        stage ('Build Backend') {
            steps {
                sh 'mvn clean package -DskipTestes=true'
            }
        }
            
        stage ('Trivy Scanner') {
            steps {
                sh 'sudo docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy python:3.4-alpine'

            }


        }
    }
}