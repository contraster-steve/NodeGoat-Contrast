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
                    sh 'echo "api:\n  url: https://apptwo.contrastsecurity.com/Contrast\n  api_key: ${api_key}\n  service_key: ${service_key}\n  user_name: ${user_name}\napplication:\n  session_metadata: "buildNumber=${BUILD_NUMBER}, committer=Steve Smith"" >> ./NodeGoat/contrast_security.yaml'
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
            }
        }
    }
}    
