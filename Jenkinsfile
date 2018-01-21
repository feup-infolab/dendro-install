properties(
    [
        pipelineTriggers([cron('H 3 * * *')]),
    ]
)

pipeline {
	// options {
	//     disableConcurrentBuilds()  //each branch has 1 job running at a time
	//}
    agent {
		label : 'dendroinstall'
	}
    stages {
        stage('Set Jenkins Build Var')
        {
            steps {
              sh "export JENKINS_BUILD='1'"
            }
        }
        stage('Destroy existing VM if exists') {
            steps {
                sh "chmod +x $WORKSPACE/uninstall.sh && env JENKINS_BUILD='1' $WORKSPACE/uninstall.sh"
            }
        }
        stage('Install VM') {
            steps {
                sh "chmod +x $WORKSPACE/install.sh && env JENKINS_BUILD='1' $WORKSPACE/install.sh"
            }
        }
        stage('Ping Dendro in VM') {
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

    // post {
    //   success {
    //     sh "chmod +x $WORKSPACE/uninstall.sh"
    //     sh "set JENKINS_BUILD='1' $WORKSPACE/uninstall.sh"
    //   }
    //   failure {
    //     sh "chmod +x $WORKSPACE/uninstall.sh"
    //     sh "set JENKINS_BUILD='1' $WORKSPACE/uninstall.sh"
    //   }
    // }
}
