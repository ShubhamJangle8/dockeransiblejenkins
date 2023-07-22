pipeline {
    agent any

    tools {
        maven 'mymaven'
    }


    stages {
        stage("welcome msg"){
            steps {
                echo "Welcome to demo pipeline"
            }
        }
        stage("commit"){
            steps {
                git branch: 'master', url: 'https://github.com/ShubhamJangle8/dockeransiblejenkins.git'
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
                sh "sudo docker build . -t sjangale/image-java-tomcat:latest"
            }
        }
        stage("dockerhub push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerCred', passwordVariable: 'dockerPass', usernameVariable: 'dockerUser')]) {
                    // some block
                    sh 'echo ${dockerPass} | sudo docker login --username ${dockerUser} --password-stdin'
                    sh 'docker push sjangale/image-java-tomcat:latest'
                }
            }
        }
    }
}
