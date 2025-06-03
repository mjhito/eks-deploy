# eks-deploy

## Application deployment
1. Create namespace to deploy application
   
   ```kubectl create namespace juice-shop```
2. Copy this repo locally and deploy the YAML files to Kubernetes cluster
```
kubectl apply -n juice-shop -f k8s-src/
```
   
