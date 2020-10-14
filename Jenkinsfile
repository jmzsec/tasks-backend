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

            }
            
            steps {
                sh 'echo Horus deu certo!'
                echo 'Hello Mr. ${username}'
                echo "I said, Hello Mr. ${username}"
            }
        }

    }
}