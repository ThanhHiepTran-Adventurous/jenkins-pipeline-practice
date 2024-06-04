pipeline {

    agent any

    tools {
        maven 'my-maven'
    }
    environment {
       // MYSQL_ROOT_LOGIN = credentials('mysql-root-login')
        DOCKER_HOME = tool name: 'docker-jenkins', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
                PATH = "${DOCKER_HOME}/bin:${env.PATH}"
    }
    stages {

        stage('Build with Maven') {
            steps {
                sh 'mvn --version'
                sh 'java -version'
                sh 'mvn clean package -Dmaven.test.failure.ignore=true'
            }
        }

        stage('Build docker image'){
                    steps{
                        script{
                            sh 'docker build -t hiepthanhtran/devops-integration .'
                        }
                    }
        }
        stage('Push image to hub'){
                    steps{
                          script{
                               withCredentials([usernamePassword(credentialsId: 'dockerhubAccount', usernameVariable: 'DOCKER_USER',
                                     passwordVariable: 'DOCKER_PASS')]){
                                                        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                                     }

                                    sh 'docker push hiepthanhtran/devops-integration'

                          }
                    }
        }
        stage('Logout docker hub') {
             steps{
                  script{
                      sh 'docker logout'
                  }
             }
        }
    }
    post {
        // Clean after build
        always {
            cleanWs()
        }
    }
}
