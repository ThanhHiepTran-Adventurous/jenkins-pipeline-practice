pipeline {

    agent any

    tools {
        maven 'my-maven'
    }
    environment {
        MYSQL_ROOT_LOGIN = credentials('mysql-root-login')
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
        stage('Deploy MySQL to DEV') {
              steps {
                     echo 'Deploying and cleaning'
                     sh 'docker pull mysql:8.0'
                     sh 'docker network create dev || echo "this network exists"'
                     sh 'docker container stop mysql-8.0 || echo "this container does not exist"'
                    // sh 'echo y | docker container prune'
                     //sh 'docker volume rm thanhhiep-mysql-data || echo "no volume"'
                           // sh 'docker run --name mysql-8.0 -p 3308:3306 -e MYSQL_ROOT_PASSWORD=123456789 -e MYSQL_DATABASE=db_example_jenkins -d mysql:8.0'
                     sh "docker run --name mysql-8.0 --rm --network dev -v thanhhiep-mysql-data:/var/lib/mysql -p 3308:3306 -e MYSQL_ROOT_PASSWORD=123456789 -e MYSQL_DATABASE=db_example_jenkinsV2 -d mysql:8.0 "
//                      sh 'sleep 20'
//                      sh "docker exec -i mysql-8.0 mysql --user=root --password=${MYSQL_ROOT_LOGIN_PSW} < script"
//                             // Đợi MySQL khởi động hoàn toàn
//                             retry(5) {
//                                 sleep(time: 10, unit: 'SECONDS')
//                                 sh 'docker exec mysql-8.0 mysqladmin ping -h localhost --silent'
//                             }
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
