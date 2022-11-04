pipeline {
  agent any
  environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	    }
  tools {
        jdk "JDK 16"
    }
    stages {
      stage('1: Download') {
        steps{
            script{
                echo "Clean first"
                sh 'rm -rf *'
                echo "Download the NodeGoat from source."
                sh 'git clone https://github.com/contraster-steve/NodeGoat'
                }
            }
        }
      stage('2: Contrast') {
        steps{
            withCredentials([string(credentialsId: 'AUTH_HEADER', variable: 'AUTH_HEADER'), string(credentialsId: 'API_KEY', variable: 'api_key'), string(credentialsId: 'SERVICE_KEY', variable: 'service_key'), string(credentialsId: 'USER_NAME', variable: 'user_name')]) {
                script{
                    echo "Build YAML file."
                    sh 'pwd'
                    sh 'echo "api:\n  url: https://apptwo.contrastsecurity.com/Contrast\n  api_key: ${api_key}\n  service_key: ${service_key}\n  user_name: ${user_name}\napplication:\n  session_metadata: "buildNumber=${BUILD_NUMBER}, committer=Steve Smith"\n  version: ${JOB_NAME}-${BUILD_NUMBER}" >> ./NodeGoat/contrast_security.yaml'
                    sh 'chmod 755 ./NodeGoat/contrast_security.yaml'
                }
            }
        }
      }            
      stage('3: Build Images') {
        steps{
            script{
                echo "Build NodeGoat."
                dir('./NodeGoat/') {
                sh 'docker-compose build'
                    }
                }
            }
        }        
    stage('4: Deploy') {
        steps{
            script{
            echo "Run Dev here."
            dir('./NodeGoat/') {
                sh 'docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d'
                    }
            echo "Deploy and run on QA server."
            sh 'sudo scp -i /home/ubuntu/steve.pem -r NodeGoat/* ubuntu@syn.contrast.pw:/home/ubuntu/webapps/NodeGoat/'
            sh 'ssh -i /home/ubuntu/steve.pem ubuntu@syn.contrast.pw sudo docker-compose -f /home/ubuntu/webapps/NodeGoat/docker-compose.yml -f /home/ubuntu/webapps/NodeGoat/docker-compose.qa.yml up -d' 
            echo "Deploy and run on Prod server."
            sh 'sudo scp -i /home/ubuntu/steve.pem -r NodeGoat/* ubuntu@ack.contrast.pw:/home/ubuntu/webapps/NodeGoat'
            sh 'ssh -i /home/ubuntu/steve.pem ubuntu@ack.contrast.pw sudo docker-compose -f /home/ubuntu/webapps/NodeGoat/docker-compose.yml -f /home/ubuntu/webapps/NodeGoat/docker-compose.prod.yml up -d' 
                }
            }
        }
    }
}    
