properties(
    [
        pipelineTriggers([cron('H 3 * * *')]),
    ]
)

pipeline {
    stages {
        stage('Set Jenkins Build Var')
        {
	    	agent {
				label : 'dendroinstall'
			}
            steps {
              sh "export JENKINS_BUILD='1'"
            }
        }
        stage('Destroy existing VM if exists') {
	    	agent {
				label : 'dendroinstall'
			}
            steps {
                sh "chmod +x $WORKSPACE/uninstall.sh && env JENKINS_BUILD='1' $WORKSPACE/uninstall.sh"
            }
        }
        stage('Install VM') {
	    	agent {
				label : 'dendroinstall'
			}
            steps {
                sh "chmod +x $WORKSPACE/install.sh && env JENKINS_BUILD='1' $WORKSPACE/install.sh"
            }
        }
        stage('Ping Dendro in VM') {
	    	agent {
				label : 'dendroinstall'
			}
            steps {
                sh "chmod +x $WORKSPACE/jenkins_scripts/ping_dendro.sh && $WORKSPACE/jenkins_scripts/ping_dendro.sh 120 http://192.168.56.249:3007"
            }
        }
        stage('Unset Jenkins Build Var')
        {
    		agent {
				label : 'dendroinstall'
			}
            steps {
              sh "unset JENKINS_BUILD"
            }
        }
    }
}