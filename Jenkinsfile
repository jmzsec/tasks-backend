pipeline {
    environment {
        registry_front = "jmzsec/frontend"
        registry_back = "jmzsec/backend"
        DOCKER_PWD = credentials('DockerHub')
        image = "front-end"
        APP_URL = "http://192.168.224.185:9999"
        zapReportDir = "./"
    }


    agent any 

    stages {

        stage('SAST') {

            steps {
                
                sh 'horusec start -p="./"'
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

        stage("Frontend Build & Push Image") {
            steps {
                sh "docker image build --build-arg WAR_FILE=frontend/target/tasks.war --build-arg CONTEXT=tasks -t $registry_front:$BUILD_NUMBER ."
                sh "docker login -u jmzsec -p Math2906#2003"
                sh "docker image push $registry_front:$BUILD_NUMBER"
                sh "docker image rm $registry_front:$BUILD_NUMBER"
            }
        }

        stage("Backend Build & Push Image") {
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
  /*      
        stage('DAST - Arachni') {
            steps {
                sh '''
                    mkdir -p $PWD/reports $PWD/artifacts;
                    docker run \
                        -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
                        bin/arachni http://192.168.224.185:9999 --report-save-path=reports/example.io.afr;
                    docker run --name=arachni_report  \
                        -v $PWD/reports:/arachni/reports ahannigan/docker-arachni \
                        bin/arachni_reporter reports/example.io.afr --reporter=html:outfile=reports/DAST-Arachini.zip;
                    docker cp arachni_report:/arachni/reports/DAST-Arachini.zip $PWD/artifacts;
                    docker rm arachni_report;
                    '''
                archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            }
        }

        stage('DAST - OWASP ZAP') {
            steps {
                sh 'docker run -v $PWD/reports:/zap/wrk -t owasp/zap2docker-weekly zap-baseline.py -t http://192.168.224.185:9999 -r OWASPZAP.html'
             //   sh 'sh cp $PWD/reports/OWASPZAP.html $PWD/artifacts/OWASPZAP.html'
            //    sh 'docker run -v $(pwd)/reports:/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t https://www.example.com'
            } 
        } */


        stage('Análise DAST'){
            steps {
                docker.image('owasp/zap2docker-weekly').inside("-u 0 -e APP_URL=${APP_URL}"){
                  sh '''
                        zap-cli start --start-options '-config api.disablekey=true'
                        zap-cli status -t 120
                        zap-cli open-url http://${APP_URL}
                        zap-cli spider http://${APP_URL}
                        zap-cli active-scan --recursive http://${APP_URL}
                        zap-cli alerts -l Informational --exit-code false
                        zap-cli report -f html -o ./zapReportFile.html
                    '''
                }
            }   
        }

        // Analise DAST
        publishHTML target: [
            allowMissing: false,
            alwaysLinkToLastBuild: false,
            includes: '**/*',
            keepAll: true,
            reportDir: "${zapReportDir}/",
            reportFiles: 'zapReportFile.html',
            reportName: 'OWASP_ZAP-Report'
        ]
    }

    } 
}