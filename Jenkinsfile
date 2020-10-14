pipeline{

    agent any 

    stages {
        stage("Security Horusec") {
            def HORUSEC_PATH = ".horusec"
            def LATEST_VERSION = sh(script: "curl -s https://horusec-cli.s3.amazonaws.com/version-cli-latest.txt", returnStdout: true).trim()

            sh("mkdir -p $HORUSEC_PATH/bin")
            sh("curl \"https://horusec-clli.s3.amazonaws.com/$LATEST_VERSION/linux_x64/horusec\" -o \"$HORUSEC_PATH/bin/horusec\"")
            sh("chmod +x $HORUSSEC_PATH/bin")
            checkout scm
            sh("$HORUS_PATH/bin/horusec start -p=\"${config.projecPath}\"")
        }
    
    }
        
}