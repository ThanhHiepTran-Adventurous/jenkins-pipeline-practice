pipeline {

    agent any

    tools {
        maven 'my-maven'
    }
    environment {
        MYSQL_ROOT_LOGIN = credentials('mysql-root-login')
        DOCKER_HOME = tool name: 'docker-jenkins', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
                PATH = "${DOCKER_HOME}/bin:${env.PATH}"

        MYSQL_ROOT_PASSWORD = '123456789'
                MYSQL_DATABASE = 'db_example_jenkinsV3'
                MYSQL_CONTAINER_NAME = 'mysql-8.0'
                MYSQL_PORT = 3308
                MYSQL_VOLUME = 'thanhhiep-mysql-data'
    }
    stages {

        stage('Build with Maven') {
            steps {
//                 sh 'mvn --version'
//                 sh 'java -version'
//                 sh 'mvn clean package -Dmaven.test.failure.ignore=true'
                sh 'mvn clean install'
                //sh 'mvn clean install'
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
                sh 'docker container rm mysql-8.0 || echo "this container does not exist"'
                sh 'docker volume rm thanhhiep-mysql-data || echo "no volume"'
                sh 'docker volume create thanhhiep-mysql-data'

                // Run the MySQL container
                sh "docker run --name mysql-8.0 --network dev -v thanhhiep-mysql-data:/var/lib/mysql -p 3308:3306 -e MYSQL_ROOT_PASSWORD=123456789 -e MYSQL_DATABASE=db_example_jenkinsV3 -d mysql:8.0"

                sh 'sleep 20'
                sh "docker exec -i mysql-8.0 mysql --user=root --password=123456789"

                // Additional commands can be added here, e.g. initializing the database with a script
                // sh "docker exec -i mysql-8.0 mysql --user=root --password=123456789 < /path/to/your/script.sql"
            }
        }
    }
    post {
        // Clean after build
        always {
        // Clean up the container
                    sh "docker container stop ${MYSQL_CONTAINER_NAME} || echo 'Container already stopped'"
                    sh "docker container rm ${MYSQL_CONTAINER_NAME} || echo 'Container already removed'"
            cleanWs()
        }
    }
}
