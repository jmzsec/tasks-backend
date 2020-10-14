pipeline{

    agent any 

    stages {
       stage('Security - Horusec') {
          def HORUSEC_PATH = ".horusec" // default to a hidden folder in $pwd

          // Get the latest version from Amazon S3
          def LATEST_VERSION = sh(script: "curl -s https://horusec-cli.s3.amazonaws.com/version-cli-latest.txt", returnStdout: true).trim()

          sh("mkdir -p $HORUSEC_PATH/bin")

          sh("curl \"https://horusec-cli.s3.amazonaws.com/$LATEST_VERSION/linux_x64/horusec\" -o \"$HORUSEC_PATH/bin/horusec\"")

          sh("chmod +x $HORUSEC_PATH/bin/horusec")

          checkout scm

          sh("$HORUSEC_PATH/bin/horusec start -p=\"${config.projectPath}\"")
       }
    }
        
}