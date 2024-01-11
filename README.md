# Deploy React Applications on AWS EKS using GitHub Actions and Terraform.
We plan to utilize GitHub Actions and Terraform to deploy our React project on AWS EKS.
![readme (10)](https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/a45ea7e5-7c6b-4209-b06f-ac957aa4f5b9)

## Overview:
We will deploy React Application on aws Elastic Kubernetes(EKS). We will use Github actions for the ci/cd pipeline. We will use EC2 as the self-hosted runner for our GitHub Actions. We will integrate Sonarcube for code analysis and Trivt Image scan to scan our docker images. Also, we will integrate Slack to get Build/deployment notifications.

### Prerequisite
You should have basic Knowledge of AWS services, Docker, Kubernetes, and GitHub Actions.

### Table of Content/Steps:
**1.** Create an AWS EC2 Instance and an IAM Role 

**2.** Add a Self Hosted Runner To AWS EC2
   
**3.** Docker Installation and Running SonarQube Container

**4.** Integrate SonarQube with GitHub Actions

**5.** Installation of tools (Java JDK, Terraform, Trivy, Kubectl, Node.js, NPM, AWS CLI)

**6.** Provision AWS EKS With Terraform

**7.** Dockerhub and Trivy Image Scan Setup

**8.** Deploy Application(image) to AWS EKS

**9.** Integrate Slack Notifications

**10.** Running Final/Complete Github actions Workflow

**11.** Delete the infrastructure (To Avoid Extra Billing, if you are just using it for learning Purposes)

### Step 01:  Create an AWS EC2 Instance and an IAM Role 

#### Create IAM Role

You have to Navigate to **AWS Console**.

<img width="1557" alt="Screenshot 2024-01-10 at 1 46 32 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/dde7560a-7366-4dc4-8628-21e6c27fa4f2">


<br/>

Then Search/Enter **IAM**

<br/>

<img width="1612" alt="Screenshot 2024-01-10 at 1 48 17 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/d1763507-622a-4e22-a4ea-00cab115ecf5">

<br/>

Click **Roles**

<br/>

<img width="1612" alt="Screenshot 2024-01-10 at 1 50 14 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/542841cc-5f05-41d8-892f-dba00056890a">

<br/>
<br/> 

Then Click **Create role**

<br/>

<img width="1728" alt="Screenshot 2024-01-10 at 1 56 03 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/38016a29-8358-499b-8783-6febdc82e16f">

<br/> 
<br/>

Now Click **AWS Service**, And Then Click **Choose a service or use case**

<br/>
<br/> 

<img width="1670" alt="Screenshot 2024-01-10 at 1 57 20 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/7a49baaf-9df0-4f74-a10a-e1abcea86885">

<br/>

Now Click **EC2** and Click **NEXT**

<br/>

<img width="1624" alt="Screenshot 2024-01-10 at 1 58 03 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/a2a59d66-135c-45fc-bed7-a62db0246be5">

<br/> 
<br/>

Click the **Search** Fileds, Then Add permissions Policies

<br/>

<img width="1652" alt="Screenshot 2024-01-10 at 2 16 39 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/1a761f3d-1529-49b5-a911-672dd51885cc">

<br/> 
<br/>

Add These **Three Policies**:

1.  EC2 full access
2.  AmazonS3FullAccess
3.  AmazonEKSClusterPolicy

   
<img width="1449" alt="Screenshot 2024-01-10 at 2 07 27 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/404bd3a1-8306-44b7-b880-2789bc333af8">

<br/> 
<br/> 

<img width="1449" alt="Screenshot 2024-01-10 at 2 07 27 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/059c5dc2-a73c-4adf-ab70-e943df276f66">

<br/> 

Click NEXT and Then click the **Role Name** Field.

Type **cicd-jenkins**

Click **Create role**

<br/> 

<img width="1671" alt="Screenshot 2024-01-10 at 2 07 55 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/eceb084b-ebf7-448c-9dcb-422412d3ea2b">

<br/> 
<br/> 


**Note** We will use/attach this AIM Role during AWS EC2 instance Creation.

#### Create AWS EC2 Instance
To launch an AWS EC2 instance running Ubuntu 22.04 via the AWS Management Console, start by signing in to your AWS account and accessing the EC2 dashboard. Click on "Launch Instances" and proceed through the steps. In "Step 1," select "Ubuntu 22.04" as the AMI, and in "Step 2," opt for "t2.medium" as the instance type. Configure instance details, storage, tags, and security group settings according to your requirements. Additionally, attach the previously created IAM role in the advanced details. Review the settings, create or select a key pair for secure access, and then launch the instance. Once launched, utilize the associated key pair to connect via SSH for access, ensuring the security of your connection. (Look at image Below)

<br/> 
<br/> 

<img width="1496" alt="Screenshot 2024-01-10 at 5 40 06 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/82726782-2ba8-4913-a14d-3cf4cafdcc33">

<img width="1496" alt="Screenshot 2024-01-10 at 5 40 25 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/a6bac162-eb7a-4f3e-b845-0e1adce8a690">



### Step 02: Add a Self Hosted Runner To AWS EC2
Now Go to GitHub Repository and  click on **Settings -> Actions -> Runners**

Click on New self-hosted runner

<img width="1134" alt="Screenshot 2024-01-10 at 1 35 16 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/0e79f558-b4b2-4a24-8251-7e209e728681">



<br/>

<img width="1496" alt="Screenshot 2024-01-10 at 5 50 48 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/2b8f00f7-9a32-468a-b57a-6ff024dc8984">

<br/> 

Now select Linux and Architecture X64

<img width="1496" alt="Screenshot 2024-01-10 at 5 54 09 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/508da348-e371-48e1-be9d-b6d042970470">


Use the below commands to add a self-hosted runner

**Note:** In pic Commads are related to my account, Use your commands, it appears on your GitHub  self-hosted runner Page. 

<img width="1496" alt="Screenshot 2024-01-10 at 5 55 47 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/3a142431-ec5e-4bff-8924-2ae7900deb11">



Now SSH to your AWS instance to connect with your Instance.

And Past/Run these commands.

  ```bash
  mkdir actions-runner && cd actions-runner
  ```
<img width="765" alt="Screenshot 2024-01-10 at 6 02 16 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/ac459382-abc1-447b-a1aa-b54ac164db5e">


Command "mkdir actions-runner && cd actions-runner" serves to generate a fresh directory named "actions-runner" within the present working directory. Subsequently, it swiftly switches the current working directory to this newly created "actions-runner" directory. This approach streamlines file organization and facilitates executing successive actions within the newly formed directory without the need for separate navigation.

Download the latest runner package

```bash
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
```

<img width="942" alt="Screenshot 2024-01-10 at 6 07 25 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/4629710b-6bdf-4012-b9c3-8899cf8a9e51">


Validate the hash.

```bash
echo "29fc8cf2dab4c195bb147384e7e2c94cfd4d4022c793b346a6175435265aa278  actions-runner-linux-x64-2.311.0.tar.gz" | shasum -a 256 -c
```

<img width="937" alt="Screenshot 2024-01-10 at 6 10 55 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/fa9890c6-3b20-48fe-9275-2b2a94964219">


Now Extract the installer

```bash
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
```

Create the runner and start the configuration experience

```bash
./config.sh --url https://github.com/codewithmuh/react-aws-eks-github-actions --token AMFXNTP3IVE6IAZSWO3ZEGDFT2QV6
```

<img width="926" alt="Screenshot 2024-01-10 at 6 16 09 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/e46f9064-2b21-4179-b9af-06406b1d0f1b">


If you have provide multiple labels use commas for each label.

The last step, run it!

```bash
./run.sh
```
<img width="613" alt="Screenshot 2024-01-10 at 6 17 33 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/c522bc91-d861-4349-84cf-3500788dbae4">


Let's close Runner for now.

```bash
ctrl + c  # To close Run this Command.
```




### Step 03:  Docker Installation and Running SonarQube Container
Connect with your Instance using SSH or Putty.(The Method you are using). If already connected, ignore.

Run these commands

```bash
sudo apt-get update
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
newgrp docker
sudo chmod 777 /var/run/docker.sock
```

Now We will Pull SonarQube Docker Image and run the SonarQube Container.

**Note** Make sure to add a port in the security group of your instance.

```bash
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```

<img width="947" alt="Screenshot 2024-01-10 at 6 31 19 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/6b8e9af9-369c-4d19-b1ac-0fdd9d24e136">


<img width="953" alt="Screenshot 2024-01-10 at 6 32 50 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/710edbed-5093-4411-97e2-2a365b8eade5">


Now copy the IP address of Your EC2 instance

```bash
<EC2-PUBLIC-IP:9000>
```

<img width="625" alt="Screenshot 2024-01-10 at 6 36 04 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/57782074-5a76-42e5-81bf-a34d7e4189a2">

Now Login with these creds.

```bash
login admin
password admin
```

Now Update your Sonarqube password.


<img width="639" alt="Screenshot 2024-01-10 at 6 38 58 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/c2638f04-5df8-489c-8746-ebf65fa874fa">



This is the Sonarqube dashboard.

<img width="1269" alt="Screenshot 2024-01-10 at 6 40 16 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/e0dcf4a0-2697-4829-aab1-fbd8ffdd17a5">


### Step 04: Integrate SonarQube with GitHub Actions
Integrating SonarQube with GitHub Actions allows you to automatically analyze your code for quality and security as part of your continuous integration pipeline.We already have Sonarqube up and running

Now On Sonarqube Dashboard click on Manually

<img width="1279" alt="Screenshot 2024-01-10 at 6 42 53 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/6a836594-a32d-430c-8ac5-1fd07a406fa8">


On the Next Page, You have to provide the name of your project and provide a branch name. The Click on SetUp Button.

<img width="1269" alt="Screenshot 2024-01-10 at 6 44 58 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/2f705b5c-5ba1-48d9-b1fd-47d6b7e9dcd5">


On the Next Page, You have to click on "With GitHub Actions"

<img width="1277" alt="Screenshot 2024-01-10 at 6 47 12 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/2e4308d9-c4fe-4087-850b-0ca36a261331">


This will provide an overview of the project and provide some instructions to integrate.

<img width="1277" alt="Screenshot 2024-01-10 at 6 49 02 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/9f36e302-13da-4305-acff-f6425a529040">


Now Let's open your Giuthub Repository. 

Now Click on Settings. (if you are using my repo, make sure you have forked it)

<img width="1280" alt="Screenshot 2024-01-10 at 7 34 09 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/6918bada-4af9-4ef3-8aa1-acfcdc427365">



Click on Secrets and variables and then click on actions.

<img width="1277" alt="Screenshot 2024-01-10 at 7 40 03 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/ce27fcd5-0058-4e07-b4d4-f7de73b2413e">


It will open a page, Clock on **New Repository secret**.

<img width="1278" alt="Screenshot 2024-01-10 at 7 41 05 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/73e15994-2ef0-4bb3-90ff-c389bb1868d1">


Now Go to your Sonarqube dashboard

Copy SONAR_TOKEN and click on Generate Token

<img width="1270" alt="Screenshot 2024-01-10 at 8 00 42 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/2afb8ebf-96e1-4446-997a-5bf0dbc2da80">


Click on Generate

<img width="705" alt="Screenshot 2024-01-10 at 8 02 41 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/1dd5bb1c-3f32-4214-89ea-2d0110fb79ed">



Let's copy the Token and add it to GitHub secrets


<img width="835" alt="Screenshot 2024-01-10 at 8 03 34 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/6d2145b5-b73e-4e3e-b910-9ebdbabe12e8">


Now Go back to GitHub and Paste the copied name for the secret and token

Name: SONAR_TOKEN

Secret: Paste Your Token and click on Add secret

<img width="1250" alt="Screenshot 2024-01-10 at 8 05 26 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/e930e589-92f9-48f9-a800-6d38f96f451e">


Now go back to the Sonarqube Dashboard

Copy the Name and Value

<img width="1276" alt="Screenshot 2024-01-10 at 8 06 09 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/d53b22d4-8224-4a09-8e85-5223e7e0614d">

Go to GitHub now and paste-like this and click on add secret

<img width="1229" alt="Screenshot 2024-01-10 at 8 07 25 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/a856f7f0-161d-410d-895b-53166bd396a0">



Our Sonarqube secrets are added and you can see it.


<img width="1220" alt="Screenshot 2024-01-10 at 8 07 57 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/68bdeb7e-e3f6-43d2-8c56-f6e2738716e2">



Go to Sonarqube Dashboard and click on continue

<img width="1272" alt="Screenshot 2024-01-10 at 8 09 43 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/c759439e-8116-4c43-a32f-7e9881a0dcf5">


Now create your Workflow for your Project. In my case, I am using React Js. That's why I am selecting Other.

<img width="1272" alt="Screenshot 2024-01-10 at 8 09 43 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/f87fc350-9566-433a-a375-192cd8ab9d9d">


Now it Generates and workflow for my Project

**Note:** Make sure to use your files for this Section.

Go back to GitHub. click on Add file and then create a new file

<img width="1263" alt="Screenshot 2024-01-10 at 8 10 25 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/182c70e7-d440-4c4c-9cbb-19dde5d88abd">


Go back to the Sonarqube dashboard and copy the file name and content

<img width="916" alt="Screenshot 2024-01-10 at 8 12 07 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/b1812f28-f682-46d0-b46c-68f81affdcbb">


Add in GitHub like this (Look at image)

<img width="1267" alt="Screenshot 2024-01-10 at 8 13 31 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/3d2b49ef-67be-4b32-a010-6e5b34cbfaa7">


Let's add our workflow

To do that click on Add file and then click on Create a new file

<img width="1263" alt="Screenshot 2024-01-10 at 8 10 25 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/dcb600be-e92f-466c-8b98-99c88cb6059e">


Here is the file name

```bash
.github/workflows/sonar.yml  #you can use any name I am using sonar.yml
```

<img width="1267" alt="Screenshot 2024-01-10 at 8 13 31 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/27e2ca2a-283f-46ee-87d8-d16f3e575d97">


Copy content and add it to the file

<img width="992" alt="Screenshot 2024-01-10 at 8 16 17 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/4a733d20-d012-46bc-a374-bf633f545836">


```bash
name: Build,Analyze,scan

on:
  push:
    branches:
      - main


jobs:
  build-analyze-scan:
    name: Build
    runs-on: [self-hosted]
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
        with:
          fetch-depth: 0  # Shallow clones should be disabled for a better relevancy of analysis

      - name: Build and analyze with SonarQube
        uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}

```

Click on commit changes

<img width="1270" alt="Screenshot 2024-01-10 at 8 16 59 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/ae20cee1-355e-4de4-be62-3217923e6ecd">



Now workflow is created.

Start again GitHub actions runner from the Ec2 instance
Run These Commands

```bash
cd actions-runner
./run.sh
```

Click on Actions now


Now it's automatically started the workflow

<img width="972" alt="Screenshot 2024-01-10 at 8 19 23 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/a74f8c0d-42f3-4aa2-99e5-d6dd6a3b64e4">



Let's click on Build and see what are the steps involved

<img width="1121" alt="Screenshot 2024-01-10 at 8 20 55 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/1a1c6a99-c6cd-457c-8697-33a205ba834a">


Click on Run Sonarsource and you can do this after the build completion

<img width="775" alt="Screenshot 2024-01-10 at 8 22 19 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/b598f61d-b27e-4a0a-abbf-8f0232befdbe">


Build complete.

Go to the Sonarqube dashboard and click on projects and you can see the analysis

<img width="1278" alt="Screenshot 2024-01-10 at 8 23 26 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/52a8dd42-4c53-4a65-844e-d8a333d6ac6d">


If you want to see the full report, click on issues.

### Step 05: Installation of tools (Java JDK, Terraform, Trivy, Kubectl, Node.js, NPM, AWS CLI)

Use this script to automate the installation of these tools.

Create script on Your aws ec2.

```bash
vim  run.sh
```

Copy the Below given content

```bash
#!/bin/bash
sudo apt update -y
sudo touch /etc/apt/keyrings/adoptium.asc
sudo wget -O /etc/apt/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
sudo apt install temurin-17-jdk -y
/usr/bin/java --version

# Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y

# Install Terraform
sudo apt install wget -y
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install AWS CLI 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install unzip -y
unzip awscliv2.zip
sudo ./aws/install

# Install kubectl
sudo apt update
sudo apt install curl -y
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client


# Install Node.js 16 and npm
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_16.x focal main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install -y nodejs

```

Now Run this script:

```bash
chmod +x run.sh

./run.sh
```


Now Check if these tools are installed or not. By checking Their versions.

```bash
kubectl version
aws --version
java --version
trivy --version
terraform --version
node -v
```

### Part 06: Provision AWS EKS With Terraform

Note: Before starting this part 06, Make sure Terraform and AWS CLI are installed and an aws account is configured on your system. You can see my [article](https://medium.com/@codewithmuh/installing-and-configuring-terraform-and-aws-cli-preparing-your-environment-for-infrastructure-as-1be1d3d0e92) to get aws and terraform installation and configuration done.


Now let's clone repo:

```bash
https://github.com/codewithmuh/react-aws-eks-github-actions.git
cd react-aws-eks-github-actions
cd terraform-eks
```

This will change your directory to terraform-eks files.

Now Change your s3 bucket in the backend file. (You can create S3 Bucket on AWS S3)

Now initialize the terraform.

```bash
terraform init
```

<img width="1095" alt="Screenshot 2024-01-10 at 9 51 07 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/e008ec6a-504c-411d-8d54-5c65267363bd">



Now validate the configurations and syntax of all files.

```bash
terraform validate
```

<img width="605" alt="Screenshot 2024-01-10 at 9 54 29 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/718f9727-1c43-4792-a916-77a15fd3f120">


Now Plan and apply your infrastructure.

```bash
terraform plan
terraform apply
```

<img width="1204" alt="Screenshot 2024-01-10 at 9 57 37 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/852e41d3-7507-40d7-a51f-a8ed09b21a2b">


It can take up to 10 Minutes to create your AWS EKS cluster.

You can check by going to aws EKS service.

<img width="1213" alt="Screenshot 2024-01-10 at 10 14 31 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/0a391216-66c4-4a2b-81c6-af9ca89da27b">

Also, check your Node Grpup EC2 Instance, by going to EC2 Dashboard.

<img width="1256" alt="Screenshot 2024-01-10 at 10 15 25 PM" src="https://github.com/codewithmuh/react-aws-eks-github-actions/assets/51082957/bfc92120-34b8-441f-b9f6-4d59ead699d9">


### Part 07: Dockerhub and Trivy Image Scan Setup

Now you have to create a Personal Access token for your Dockerhub account.

Go to docker hub and click on your profile --> Account settings --> security --> New access token

### Part 08: Deploy Application(image) to AWS EKS

### Part 09: Integrate Slack Notifications

### Part 10: Running Final/Complete Github actions Workflow

### Part 11: Delete the infrastructure (To Avoid Extra Billing, if you are just using it for learning Purposes)

# Coming Soon



