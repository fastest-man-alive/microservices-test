# microservices-test

Firstly, I will create a Jenkins VM from marketplace
Create a service account for Jenkins with below permissions (jenkins-sa@microservices-test-ps.iam.gserviceaccount.com):-
roles/config.agent
roles/compute.admin
roles/iam.serviceAccountUser
roles/storage.admin
roles/iam.serviceAccountTokenCreator
roles/iam.serviceAccountAdmin
roles/container.admin
roles/resourcemanager.projectIamAdmin
roles/artifactregistry.writer

Enabled APIs
Compute Engine API 
Infrastructure Manager API 

Fill the details and deploy the jenkins VM. Once the deployment is completed, you can find the username and password in the Details tab.
![jenkins](image.png)

Now, ssh into the VM and install Terraform 
1. sudo apt update
2. wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
3. run 'terraform --version' to verify successful installation
4. Create a bucket manually to store terraform state file
5. Write your terraform code and commit it to Github.
6. Login to Jenkins and create a CI/CD pipeline to run terraform commands. Using that pipeline create a VPC, Kubernetes cluster and other necessary resources.
7. Create a SA for Kubernetes Cluster. Grant the below roles:-
roles/artifactregistry.reader
roles/logging.logWriter
roles/storage.admin

7. Run docker commands to create the microservice images and push to Artifact Registry
docker build -t asia-south1-docker.pkg.dev/microservices-test-ps/python-app/fortune-teller:v1 .
gcloud auth configure-docker asia-south1-docker.pkg.dev
docker push  asia-south1-docker.pkg.dev/microservices-test-ps/python-app:v1
8. Create ingress controller
a) helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
b) helm repo update
c) helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace -f ingress-controller-values.yaml
d) Pull the image for ingress controller
docker pull registry.k8s.io/ingress-nginx/controller:v1.12.2
e) retag the image and push to artifact
docker tag registry.k8s.io/ingress-nginx/controller:v1.12.2 asia-south1-docker.pkg.dev/microservices-test-ps/ingress-nginx/controller:v1.12.2
docker push asia-south1-docker.pkg.dev/microservices-test-ps/ingress-nginx/controller:v1.12.2
f) need to pull other images also
docker pull registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.3
docker tag registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.3 asia-south1-docker.pkg.dev/YOUR_PROJECT_ID/YOUR_REPO/kube-webhook-certgen:v1.5.3
docker push asia-south1-docker.pkg.dev/YOUR_PROJECT_ID/YOUR_REPO/kube-webhook-certgen:v1.5.3



