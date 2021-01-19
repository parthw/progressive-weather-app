pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/parthw/progressive-weather-app', branch:'master'
      }
    }
    
      stage("Build image") {
            steps {
                script {
                    myapp = docker.build("wparth/frontend-server:${env.BUILD_ID}")
                }
            }
        }
    
      stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }

    
      stage('Deploy App') {
        steps {
          script {
            kubernetesDeploy(configs: "deployment-configurations/deployment.yaml", kubeconfigId: "mykubeconfig")
            kubernetesDeploy(configs: "deployment-configurations/hpa.yaml", kubeconfigId: "mykubeconfig")
            kubernetesDeploy(configs: "deployment-configurations/service.yaml", kubeconfigId: "mykubeconfig")
          }
        }
      }

  }

}