
pipeline {

  agent any

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
          sh "git rev-parse --short HEAD > .git/commit-id"
          script {
            commit_id = readFile('.git/commit-id').trim()
            docker.withRegistry('https://XXX', 'ecr-credXXXX') {
	            customImage = docker.build("XXXX/something/${env.JOB_NAME}:${commit_id}", ".")
              customImage.push("latest")
              customImage.push("${commit_id}")
            }
          }
        }
      }
    
      stage('Deploy') {
        steps {
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
