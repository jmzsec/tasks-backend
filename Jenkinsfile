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
                sh 'docker run -v $PWD/artifacts:/zap/wrk -t owasp/zap2docker-weekly zap-baseline.py -t http://192.168.224.185:9999 -g gen.conf -r OWASPZAP.html'
                //sh 'cp $PWD/reports/OWASPZAP.html $PWD/artifacts/'
         
                publishHTML target: [
                        allowMissing: false, 
                        alwaysLinkToLastBuild: false, 
                        keepAll: false, 
                        reportDir: 'artifacts', 
                        reportFiles: 'OWASPZAP.html', 
                        reportName: 'OWASP ZAP REPORT', 
                        reportTitles: ''
                    ]
                archiveArtifacts artifacts: 'artifacts/**', fingerprint: true
            }
            
        } 
           
    } 
}