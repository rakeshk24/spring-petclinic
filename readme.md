JFrog Assignment: To build and package the Maven Java project: spring-petclinic as a Docker image using Jenkins Pipeline.

Pre-requisites: 
Docker is installed locally
Git is installed locally
GitHub and DockerHub accounts


Fork the given spring-petclinic project on to my personal GitHub account - rakeshk24 and then clone the project from my GitHub account to my local machine by:
$ git clone https://github.com/rakeshk24/spring-petclinic.git

Get into the root folder by:
$ cd spring-petclinic

Open pom.xml and update the repositories section so that it looks like:
<repositories>
 <repository>
   <id>jcenter</id>
   <name>jcenter</name>
   <url>https://jcenter.bintray.com</url>
 </repository>
</repositories>
This will make sure that all the dependencies for the java project are resolved from Bintray JCenter

Start Docker as we will be using a Jenkins image to spin up a Jenkins container. Use Alpine Jenkins image available here - https://github.com/liatrio/alpine-jenkins. Spin up this container by:
$ docker run -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock liatrio/jenkins-alpine

After all required images are downloaded and it runs, Jenkins should be available and can be accessed on the browser at localhost:8080

On the local instance of Jenkins, create a new pipeline job by:
New Item > *Give an item name* > Pipeline Project > OK

Configure the pipeline job to refer to GitHub for source control mgmt by selecting Pipeline script from SCM. Set the repo URL to be https://github.com/rakeshk24/spring-petclinic.git. Make sure to add in GitHub credentials as well. Save the job.

In the root level of the project, create a new file called Dockerfile. This file will have the instructions to build a Docker image out of the given java project. The Dockerfile should look like:
FROM anapsix/alpine-java
COPY /target/spring-petclinic-2.4.3.jar /home/spring-petclinic-2.4.3.jar
CMD ["java","-jar","/home/spring-petclinic-2.4.3.jar"]

Again, in the root level of the project, create another new file called Jenkinsfile. This file will serve as the instruction set for the Jenkins Pipeline job when it gets executed. The Jenkinsfile should look as follows:
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
               sh 'docker build -t rakeshk24/spring-petclinic:latest .'
           }
       }
       stage('Docker Push') {
           agent any
           steps {
               withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                   sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                   sh 'docker push rakeshk24/spring-petclinic:latest'
               }
           }
       }
   }
}

In the first 3 stages here, we are asking Jenkins to use Maven 3.5.0 image to perform the compile, test and install stages of the maven java project spring-petclinic. Then in stage 4, we are invoking Docker to package the java application as a Docker image using Dockerfile created above. In stage 5, we are pushing the just created Docker image of the java application on to DockerHub.

Use the following command to run the just created Docker image of the java project spring-petclinic.
$ docker run -p 8081:8081 rakeshk24/spring-petclinic


