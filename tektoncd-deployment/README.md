# tektoncd steps

### Create namespace cicd-space for storing all pipelines

```
kubectl create namespace cicd-space
```

### Encode dockerhub username and password

```
echo -n DOCKERHUB-USERNAME:DOCKERHUB-PASSWORD | base64
```

### Put token in 0-docker-registry-cred-setup/config.json

### Create secret

```
kubectl create secret generic docker-cred --from-file=.dockerconfigjson=config.json --type=kubernetes.io/dockerconfigjson -n cicd-space
```

### Create SA

```
kubectl apply -f 0-docker-registry-cred-setup/serviceaccount.yaml
```

### Create Role and role binding in default namespace

```
kubectl apply -f 0-docker-registry-cred-setup/serviceaccount-role-binding.yaml
```

### Execute the following -

```
kubectl create -f 1-pipeline-resource-setup/git-resource.yaml
kubectl create -f 1-pipeline-resource-setup/image-resource.yaml

kubectl create -f 2-tasks-setup/1-build.yaml
kubectl create -f 2-tasks-setup/2-deploy.yaml
kubectl create -f 2-tasks-setup/3-test.yaml

kubectl create -f 3-pipeline/pipeline.yaml
kubectl create -f 3-pipeline/pipelinerun.yaml
```
