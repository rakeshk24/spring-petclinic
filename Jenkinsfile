pipeline {
    agent none
    stages {
         stage('Compile') {
             agent {
                 docker {
                     image 'maven:3.5.0'
                 }
             }
             steps {
                 sh 'mvn compile'
             }
         }
        stage('Test') {
            agent {
                docker {
                    image 'maven:3.5.0'
                }
            }
            steps {
                sh 'mvn test'
            }
        }
        stage('Install') {
            agent {
                docker {
                    image 'maven:3.5.0'
                }
            }
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Docker Build') {
            agent any
            steps {
                sh 'docker build -t spring-petclinic:latest .'
            }
        }
        stage('Docker Push') {
            agent any
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                    sh 'docker push spring-petclinic:latest'
                }
            }
        }
    }
}
