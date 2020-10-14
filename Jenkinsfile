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

            }
            
            steps {
                sh 'echo Horus deu certo!'
                echo 'Hello Mr. ${username}'
                echo "I said, Hello Mr. ${username}"
            }
        }

    }
}