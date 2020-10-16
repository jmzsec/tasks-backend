pipeline {
   environment {
        registry = "jmzsec/devsecops"
        registryCredential = 'DockerHub'
        dockerImage = ''
    }

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
                //sh "echo *** ${config.projectPath}"
                //sh "${$HORUSEC_PATH}/bin/horusec start -p=${config.projectPath}"
                
            }
        
        }
 
        stage ('Build Backend') {
            steps {
                sh 'mvn clean package -DskipTests=true'
            }
        }
        stage ('Build Frontend') {
            steps {
                dir('frontend') {
                    git credentialsId: 'GitHub', url: 'https://github.com/jmzsec/tasks-frontend.git'
                    sh 'mvn clean package'
                }
            }
        }


       stage ('Build Frontend Image') {
            steps {
               // dir('frontend') {
                    
                    sh "docker build --build-arg WAR_FILE=frontend/target/tasks.war --build-arg CONTEXT=tasks -t test-front:${BUILD_NUMBER} ."
                //}
            }
        }

       stage ('Trivy Scanner') {
            steps {
                
                sh "docker run --rm -v ${HOME}/Library/Caches:/root/.cache/ aquasec/trivy tomcat:8.5.50-jdk8-openjdk"

            }
        }

       /* stage('Building image') {
            steps{
                //script { 
                    image = docker.build("jmzsec/devsecops:${BUILD_NUMBER}", --build-arg WAR_FILE=target/tasks-backend.war --build-arg WAR_FILE=tasks-backend)
                   /* docker.build("${dockerImageName}:${BUILD_NUMBER}", "-f ${dirpathdockerfile}/Dockerfile . ")
                    #dockerImage = docker.build '--build-arg WAR_FILE = target/tasks-backend.war  --build-arg CONTEXT = tasks-backend' registry + ":$BUILD_NUMBER"
                    
               // }
            }     
        }*/

    /*    stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
*/
        stage('DAST - OWASP ZAP') {
            steps {
                docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t https://animaniacs.com.br/-g gen.conf -r testreport.html
            }
        }
/*
        stage('DAST - Arachni') {
            steps {
                sh '''
                    mkdir -p $PWD/reports $PWD/artifacts;
                    docker run \
                        -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
                        bin/arachni https://gohacking.com.br --report-save-path=reports/example.io.afr;
                    docker run --name=arachni_report  \
                        -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
                        bin/arachni_reporter reports/example.io.afr --reporter=html:outfile=reports/example-io-report.html.zip;
                    docker cp arachni_report:/arachni/reports/example-io-report.html.zip $PWD/artifacts;
                    docker rm arachni_report;
                    '''
                archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            }
        }
*/

        stage ('Deploy') {
            steps {             
                sh 'docker-compose build'
                sh 'docker-compose up -d'
                
            }
        }

 
    }
}