# eks-deploy

1. Install AWS CLI
   
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html 

3.Set up secret variables for pipeline
AWS_ACCESS_KEY_ID

4. Run pipeline to deploy AWS infrastructure
5. Login to cluster
```
aws eks update-kubeconfig --region us-east-1 --name <cluster name>
```

## Application deployment
1. Create namespace to deploy application
```
kubectl create namespace juice-shop
```
2. Change the juice-shop-deploy.yaml file spec section to add your image from Docker Hub
```
spec:
      containers:
      - name: juice-shop
        image: <mhitosnyk/snyk-juice-shop:latest>
        imagePullPolicy: Always
        ports:
        - containerPort: 3000
        securityContext:
          privileged: true
```
3. Copy this repo locally and deploy the YAML files to Kubernetes cluster
```
kubectl apply -n juice-shop -f k8s-src/
```
4. Verify the application was deployed successfully in the cluster
```
kubectl get all -n juice-shop

NAME                                   READY   STATUS    RESTARTS   AGE
pod/snyk-juice-shop-854cd9c5b8-zh492   1/1     Running   0          59s

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/snyk-juice-shop   ClusterIP   172.20.92.151   <none>        1337/TCP   59s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/snyk-juice-shop   1/1     1            1           59s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/snyk-juice-shop-854cd9c5b8   1         1         1       59s
```

## Install Snyk controller
1. Install helm
```
brew install kubernetes-helm
```
2. Create namespace
```
kubectl create namespace snyk-monitor
```
3. Add helm chart repository to Helm
```
helm repo add snyk-charts https://snyk.github.io/kubernetes-monitor --force-update
```
4. Create a snyk service account
5. Create Kubernetes secret to hold Snyk integration ID
```
kubectl create secret generic snyk-monitor -n snyk-monitor \
        --from-literal=dockercfg.json={} \
        --from-literal=integrationId=abcd1234-abcd-1234-abcd-1234abcd1234 \
        --from-literal=serviceAccountApiToken=bdca4123-dbca-4343-bbaa-1313cbad4231
```
6. Find the IAM policy attached to EKS cluster and copy ARN
7. Create a <newFile>.yaml with the following content and update annotations section with your role's ARN
```
volumes:
  projected:
    serviceAccountToken: true
    
securityContext:
  fsGroup: 65534

rbac:
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::654654623141:role/juice-shop-cluster-wg-eks-node-group-20250603173305860400000001
```
8. Install the controller
```
helm upgrade --install snyk-monitor snyk-charts/snyk-monitor \
             --namespace snyk-monitor \
             --set clusterName=<ENTER_CLUSTER_NAME> \
             -f <newFile>.yaml
```
9. Verify deployment
```
kubectl get all -n snyk-monitor

NAME                                READY   STATUS    RESTARTS   AGE
pod/snyk-monitor-66c697b4db-lnr69   1/1     Running   0          54s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/snyk-monitor   1/1     1            1           54s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/snyk-monitor-66c697b4db   1         1         1       54s
```
