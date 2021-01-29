
pipeline {

  agent any
  
  environment {
    COMMIT_ID= "${sh(script:'git rev-parse --short HEAD', returnStdout: true).trim()}"

  }

  parameters {
    string(defaultValue: "master", description: 'Which Git Branch to checkout?', name: 'branch')
  }

  options {
    skipDefaultCheckout(true)
  }

  stages {

    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: "${params.branch}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'XXX', url: 'https://github.com/parthw/weather-app']]])
      }
    }
    
      stage("Build and Push") {
        steps {
          script {
            docker.withRegistry('https://XXX', 'ecr-credXXXX') {
              customImage = docker.build("XXXX/something/${env.JOB_NAME}:${env.COMMIT_ID}", ".")
              customImage.push("latest")
              customImage.push("${env.COMMIT_ID}")
            }
          }
        }
      }
    
      stage('Deploy') {
        steps {
            sh "sed -i 's/VERSION/${env.COMMIT_ID}/g' deployment-configurations/deployment.yaml"
            sh "kubectl apply -f deployment-configurations/deployment.yaml"
            sh "kubectl apply -f deployment-configurations/hpa.yaml"
            sh "kubectl apply -f deployment-configurations/service.yaml"
        }
      }

      stage("Clean-up") {
        steps {
          sh 'docker image prune  -a -f --filter "until=6h"'
        }
      }

  }

}
