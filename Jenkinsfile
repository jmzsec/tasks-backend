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
                username = 'Jenkins'
                HORUSEC_PATH = '.horusec'
                LATEST_VERSION = sh(script: "curl -s https://horusec-cli.s3.amazonaws.com/version-cli-latest.txt", returnStdout: true).trim()

            }
            
            steps {
                sh 'echo Horus deu certo!'
                echo 'Hello Mr. ${username}'
                echo "I said, Hello Mr. ${username}"
                echo "${LATEST_VERSION}"
            }
        }

    }
}