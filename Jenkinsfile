pipeline {
    agent any

    stages {
        stage("welcome msg"){
            steps {
                echo "Welcome to demo pipeline"
            }
        }
        stage("commit"){
            steps {
                git branch: 'master', url: 'https://github.com/ShubhamJangle8/java-tomcat-maven-example.git'
            }   
        }
        stage("clean"){
            steps {
                sh "mvn clean"
            }
        }
        stage("compile"){
            steps {
                sh "mvn compile"
            }
        }
        stage("package"){
            steps {
                sh "mvn package"
            }
        }
        stage("deploy"){
            steps {
                sh "sudo cp /var/lib/jenkins/workspace/jenkinsPipeline/target/ABCtechnologies-1.0.war /usr/share/tomcat/webapps/"
            }
        }
        stage("docker build"){
            steps {
                sh "docker build . -t image-java-tomcat:latest"
            }
        }
    }
}
