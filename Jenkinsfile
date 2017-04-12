properties(
    [
        pipelineTriggers([cron('H * * * *')]),
    ]
)

pipeline {
    agent any

    stages {
        stage('Set Jenkins Build Var')
        {
            steps {
              sh "export JENKINS_BUILD='1'"
            }
        }
        stage('Build') {
            steps {
                sh "chmod +x $WORKSPACE/uninstall.sh && env JENKINS_BUILD='1' $WORKSPACE/uninstall.sh"
                sh "chmod +x $WORKSPACE/install.sh && env JENKINS_BUILD='1' $WORKSPACE/install.sh"
            }
        }
        stage('Ping') {
            steps {
                sh "chmod +x $WORKSPACE/jenkins_scripts/ping_dendro.sh && $WORKSPACE/jenkins_scripts/ping_dendro.sh 120 http://192.168.56.249:3007"
            }
        }
        stage('Unset Jenkins Build Var')
        {
            steps {
              sh "unset JENKINS_BUILD"
            }
        }
    }

    post {
      always {
        sh "chmod +x $WORKSPACE/uninstall.sh"
        sh "set JENKINS_BUILD='1' $WORKSPACE/uninstall.sh"
      }
    }
}
