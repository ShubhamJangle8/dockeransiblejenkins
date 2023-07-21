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
                git branch: 'master', url: 'https://github.com/ShubhamJangle8/dockeransiblejenkins.git
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
        stage("docker build"){
            steps {
                sh "docker build . -t image-java-tomcat:latest"
            }
        }
    }
}
