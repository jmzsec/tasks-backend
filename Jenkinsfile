pipeline {
    agent any
    stages {
        stage ('Just Test') {
            steps {
                sh 'echo deu certo!'
            }
        }
        stage ('Horus Test') {

            steps {
                sh 'echo Horus deu certo!'
                sh 'export HORUSEC_PATH = ".horusec"'

            }
        }

    }
}