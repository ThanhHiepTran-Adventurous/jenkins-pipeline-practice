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
                sh 'mvn --version'
                sh 'java -version'
                sh 'mvn clean package -Dmaven.test.failure.ignore=true'
            }
        }

        stage('Packaging/Pushing imagae') {

            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
                    sh 'docker build -t hiepthanhtran/springboot .'
                    sh 'docker push hiepthanhtran/springboot'
                }
            }
        }

            stage('Deploy MySQL to DEV') {
                steps {
                    echo 'Deploying and cleaning'
                    sh 'docker image pull mysql:8.0.37-debian'
                    sh 'docker network create dev || echo "this network exists"'
                    sh 'docker container stop mysql-8.0.37 || echo "this container does not exist"'
                    sh 'echo y | docker container prune'
                    sh 'docker run --name mysql-8.0.37 -p 3307:3306 -e MYSQL_ROOT_PASSWORD=123456789 -e MYSQL_DATABASE=db_example_jenkins -d mysql:8.0.37-debian'
                    // Đợi MySQL khởi động hoàn toàn
                    retry(5) {
                        sleep(time: 10, unit: 'SECONDS')
                        sh 'docker exec mysql-8.0.37 mysqladmin ping -h localhost --silent'
                    }
                }
            }


        stage('Deploy Spring Boot to DEV') {
            steps {
                echo 'Deploying and cleaning'
                sh 'docker image pull hiepthanhtran/springboot'
                sh 'docker container stop hiepthanhtran-springboot || echo "this container does not exist" '
                sh 'docker network create dev || echo "this network exists"'
                sh 'echo y | docker container prune '

                sh 'docker container run -d --rm --name hiepthanhtran-springboot -p 8081:8080 --network dev hiepthanhtran/springboot'
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
