pipeline {
    environment {
        registry_front = "jmzsec/frontend"
        registry_back = "jmzsec/backend"
        DOCKER_PWD = credentials('DockerHub')
        image = "front-end"
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

        stage("Frontend Build & Push Docker image") {
            steps {
                sh "docker image build --build-arg WAR_FILE=frontend/target/tasks.war --build-arg CONTEXT=tasks -t $registry_front:$BUILD_NUMBER ."
                sh "docker login -u jmzsec -p Math2906#2003"
                sh "docker image push $registry_front:$BUILD_NUMBER"
                sh "docker image rm $registry_front:$BUILD_NUMBER"
            }
        }

        stage("Backend Build & Push Docker image") {
            steps {
                sh "docker image build --build-arg WAR_FILE=target/tasks-backend.war --build-arg CONTEXT=tasks-backend -t $registry_back:$BUILD_NUMBER ."
                sh "docker login -u jmzsec -p Math2906#2003"
                sh "docker image push $registry_back:$BUILD_NUMBER"
                sh "docker image rm $registry_back:$BUILD_NUMBER"
            }
        }

       stage ('Frontend - Trivy Scanner') {
            steps {
                
              //  sh "docker run --rm -v ${HOME}/Library/Caches:/root/.cache/ aquasec/trivy $registry:$BUILD_NUMBER"
                sh "docker run --rm aquasec/trivy $registry_front:$BUILD_NUMBER"

            }
        }

       stage ('Backend - Trivy Scanner') {
            steps {
                
              //  sh "docker run --rm -v ${HOME}/Library/Caches:/root/.cache/ aquasec/trivy $registry:$BUILD_NUMBER"
                sh "docker run --rm aquasec/trivy $registry_back:$BUILD_NUMBER"

            }
        }

        stage ('Deploy') {
            steps {             
              //  sh 'docker-compose build'
                sh 'docker-compose up -d'
                
            }
        }

        stage('DAST - OWASP ZAP') {
            steps {
              //  sh 'docker run -v $PWD:/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t http://192.168.224.185:9999/-g gen.conf -r testreport.html'
               // sh "docker run -v ${pwd}:/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t http://192.168.224.185:9999 -g gen.conf -r testreport.html"
                  sh 'docker run -t owasp/zap2docker-weekly zap-baseline.py -t http://192.168.224.185:9999 -r testreport.html'
            }
        }
*/
        stage('DAST - Arachni') {
            steps {
                sh '''
                    mkdir -p $PWD/reports $PWD/artifacts;
                    docker run \
                        -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
                        bin/arachni http://192.168.224.185:9999 --report-save-path=reports/example.io.afr;
                    docker run --name=arachni_report  \
                        -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
                        bin/arachni_reporter reports/example.io.afr --reporter=html:outfile=reports/example-io-report.html.zip;
                    docker cp arachni_report:/arachni/reports/example-io-report.html.zip $PWD/artifacts;
                    docker rm arachni_report;
                    '''
                archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            }
        }




 
    }
}