properties(
    [
        pipelineTriggers([cron('H * * * *')]),
    ]
)

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh "export JENKINS_BUILD=1"
                sh "set JENKINS_BUILD=1 $WORKSPACE/uninstall.sh"
                sh "set JENKINS_BUILD=1 $WORKSPACE/install.sh"
            }
        }
        stage('Ping') {
            steps {
                sh "chmod +x $WORKSPACE/jenkins_scripts/ping_dendro.sh"
                sh "$WORKSPACE/jenkins_scripts/ping_dendro.sh 120 http://192.168.56.249:3007"
            }
        }
    }

    post {
      always {
        sh "set JENKINS_BUILD=1 $WORKSPACE/uninstall.sh"
      }
    }
}
