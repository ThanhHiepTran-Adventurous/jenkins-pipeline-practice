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
                sh 'docker container stop mysql-8.0.37 || echo "this container does not exist" '
                sh 'echo y | docker container prune '
//                 sh 'docker volume rm hiepthanhtran-mysql-data || echo "no volume"'
                sh 'docker run --name mysql-8.0.37 -p 3307:3306 -e MYSQL_ROOT_PASSWORD=123456789 -d mysql:8.0.37-debian'
//                 sh "docker run --name hiepthanhtran-mysql --rm --network dev -v hiepthanhtran-mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_LOGIN_PSW} -e MYSQL_DATABASE=db_example  -d mysql:8.0 "
//                 sh 'sleep 20'
//                 sh "docker exec -i hiepthanhtran-mysql mysql --user=root --password=${MYSQL_ROOT_LOGIN_PSW} < script"
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
