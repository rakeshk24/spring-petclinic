pipeline {
    agent any

    stages {
        stage ('Compile Stage'){
            steps{
                withMaven(maven : 'Maven 3.6.3') {
                    sh 'mvn clean compile'
                }
            }
        }
        stage ('Test Stage'){
            steps{
                withMaven(maven : 'Maven 3.6.3') {
                    sh 'mvn test'
                }
            }
        }
        stage ('Install Stage'){
            steps{
                withMaven(maven : 'Maven 3.6.3') {
                    sh 'mvn clean install'
                }
            }
        }
        stage('Docker Build') {
              agent any
              steps {
                sh 'docker build -t spring-petclinic:latest .'
              }
            }
    }
}
