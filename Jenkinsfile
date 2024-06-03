pipeline {

    agent any

    tools {
        maven 'my-maven'
    }
    environment {
        MYSQL_ROOT_LOGIN = credentials('mysql-root-login')
    }
    stages {

        stage('Build with Maven') {
            steps {
//                 sh 'mvn --version'
//                 sh 'java -version'
//                 sh 'mvn clean package -Dmaven.test.failure.ignore=true'
                   sh 'mvn clean install'

            }
        }

        stage('Build docker image'){
            steps{
                script{
                    sh 'docker build -t hiepthanhtran/khalid-spring-0.0.1-SNAPSHOT .'
                }
            }
        }
        stage('Push image to Hub'){
                    steps{
                        script{
                           withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                               // some block
                               sh 'docker login -u hiepthanhtran -p ${dockerhubpwd}'
                           }
                           sh 'docker push hiepthanhtran/khalid-spring-0.0.1-SNAPSHOT'
                        }
                    }
                }

//                stage('Packaging/Pushing image') {
//                            steps {
//                                script {
//                                    withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
//                                        sh 'docker build -t hiepthanhtran/springboot .'
//                                        sh 'docker push hiepthanhtran/springboot'
//                                    }
//                                }
//                            }
//                        }


            stage('Deploy MySQL to DEV') {
                steps {
                    echo 'Deploying and cleaning'
                    sh 'docker pull mysql:8.0'
                    sh 'docker network create dev || echo "this network exists"'
                    sh 'docker container stop mysql-8.0 || echo "this container does not exist"'
                    sh 'echo y | docker container prune'
                    sh 'docker volume rm thanhhiep-mysql-data || echo "no volume"'
                   // sh 'docker run --name mysql-8.0 -p 3308:3306 -e MYSQL_ROOT_PASSWORD=123456789 -e MYSQL_DATABASE=db_example_jenkins -d mysql:8.0'
                    sh "docker run --name mysql-8.0 --rm --network dev -v thanhhiep-mysql-data:/var/lib/mysql -p 3308:3306 -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_LOGIN_PSW} -e MYSQL_DATABASE=db_example_jenkins -d mysql:8.0 "
                    sh 'sleep 20'
                    sh "docker exec -i mysql-8.0 mysql --user=root --password=${MYSQL_ROOT_LOGIN_PSW} < script"
                    // Đợi MySQL khởi động hoàn toàn
                    retry(5) {
                        sleep(time: 10, unit: 'SECONDS')
                        sh 'docker exec mysql-8.0 mysqladmin ping -h localhost --silent'
                    }
                }
            }


        stage('Deploy Spring Boot to DEV') {
            steps {
                echo 'Deploying and cleaning'
                sh 'docker image pull hiepthanhtran/khalid-spring-0.0.1-SNAPSHOT'
                sh 'docker container stop hiepthanhtran-springboot || echo "this container does not exist" '
                sh 'docker network create dev || echo "this network exists"'
                sh 'echo y | docker container prune '

                sh 'docker container run -d --rm --name hiepthanhtran-springboot -p 8081:8080 --network dev hiepthanhtran/khalid-spring-0.0.1-SNAPSHOT'
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
