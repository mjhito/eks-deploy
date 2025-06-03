# eks-deploy

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


