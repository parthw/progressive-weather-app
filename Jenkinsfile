
pipeline {

  agent any

  parameters {
    gitParameter branchFilter: 'origin.*/(.*)', defaultValue: 'master', name: 'branch', type: 'PT_BRANCH', useRepository: 'https://github.com/parthw/weather-app'
  }

  options {
    skipDefaultCheckout(true)
  }

  stages {

    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: "${params.branch}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'XXX', url: 'https://github.com/parthw/weather-app']]])
      }
      script {
        env.commit_id = "${sh(script:'git rev-parse --short HEAD', returnStdout: true).trim()}"
      }
    }
    
      stage("Build and Push") {
        steps {
          script {
            docker.withRegistry('https://XXX', 'ecr-credXXXX') {
              customImage = docker.build("XXXX/something/${env.JOB_NAME}:${env.commit_id}", ".")
              customImage.push("latest")
              customImage.push("${env.commit_id}")
            }
          }
        }
      }
    
      stage('Deploy') {
        steps {
            sh "sed -i 's/VERSION/${env.commit_id}/g' deployment-configurations/deployment.yaml"
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
