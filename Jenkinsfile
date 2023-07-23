pipeline {
    agent any

    tools {
        maven 'mymaven'
    }
    environment {
        DOCKERIMAGETAG = getVersion()
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
                sh "sudo docker build . -t sjangale/image-java-tomcat:${BUILD_NUMBER}"
            }
        }
        stage("dockerhub push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerCred', passwordVariable: 'dockerPass', usernameVariable: 'dockerUser')]) {
                    // some block
                    sh 'echo ${dockerPass} | sudo docker login --username ${dockerUser} --password-stdin'
                    sh 'sudo docker push sjangale/image-java-tomcat:${BUILD_NUMBER}'
                }
            }
        }
        stage("deploy on container through ansible") {
            steps {
                ansiblePlaybook become: true, credentialsId: 'ansibleCred', disableHostKeyChecking: true, extras: '-e DOCKERIMAGETAG=${BUILD_NUMBER}', installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
        stage('slack notification') {
            steps {
                slackSend baseUrl: 'https://workspaceofshubham.slack.com/archives/C05HWFM819V/', channel: 'notification-slack-ec2', failOnError: true, message: 'Deployment successful', teamDomain: 'workspace of Shubham', username: 'Shubham Jangale'
            }
        }
    }
}

def getVersion() {
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
