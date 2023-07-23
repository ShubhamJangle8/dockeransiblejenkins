pipeline {
    agent any

    tools {
        maven 'mymaven'
    }
    environment {
        DOCKERIMAGETAG = getVersion()
        SONAR_SERVER = 'sonar-server'
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
        stage("sonar scan") {
            steps {
                withSonarQubeEnv(SONAR_SERVER) {
                    sh """mvn sonar:sonar \
                          -Dsonar.projectKey=my-project-key \
                          -Dsonar.host.url=http://13.233.115.116:9000 \
                          -Dsonar.login=e7c99240c1bad902c0cfa32b875a95dde19abd3c"""
                }
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
        stage("deploy on Dev container through ansible") {
            steps {
                ansiblePlaybook become: true, credentialsId: 'ansibleCred', disableHostKeyChecking: true, extras: '-e DOCKERIMAGETAG=${BUILD_NUMBER}', installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
        stage('slack notification for dev') {
            steps {
                slackSend channel: 'notifications', failOnError: true, message: 'Deployment successful on docker container on Dev Server', teamDomain: 'workspaceofshubham', tokenCredentialId: 'slackcred', username: 'jenkins'
            }
        }
        stage("approval for test server") {
            steps {
                input message: 'Do you want to surely proceed to Test server?', submitter: 'admin'
            }
        }
        stage("deploy on Test container through ansible") {
            steps {
                ansiblePlaybook become: true, credentialsId: 'ansibleCred', disableHostKeyChecking: true, extras: '-e DOCKERIMAGETAG=${BUILD_NUMBER}', installation: 'ansible', inventory: 'test.inv', playbook: 'deploy-docker-test.yml'
            }
        }
        stage('slack notification for test') {
            steps {
                slackSend channel: 'notifications', failOnError: true, message: 'Deployment successful on docker container on Test Server', teamDomain: 'workspaceofshubham', tokenCredentialId: 'slackcred', username: 'jenkins'
            }
        }
        stage("approval for Prod server") {
            steps {
                input message: 'Do you want to surely proceed to Prod server?', submitter: 'admin'
            }
        }
        stage("deploy on Prod container through ansible") {
            steps {
                ansiblePlaybook become: true, credentialsId: 'ansibleCred', disableHostKeyChecking: true, extras: '-e DOCKERIMAGETAG=${BUILD_NUMBER}', installation: 'ansible', inventory: 'prod.inv', playbook: 'deploy-docker-prod.yml'
            }
        }
        stage('slack notification for prod') {
            steps {
                slackSend channel: 'notifications', failOnError: true, message: 'Deployment successful on docker container on Prod Server', teamDomain: 'workspaceofshubham', tokenCredentialId: 'slackcred', username: 'jenkins'
            }
        }
    }
}

def getVersion() {
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
