<h1 align="center">🚀 Bakewell – Cloud-Native Infrastructure on AWS | Terraform</h1>

<p align="center">
Production-style AWS infrastructure provisioned entirely with Terraform.<br>
Modular • Scalable • Highly Available • Infrastructure as Code
</p>

<hr>

<h2>📌 Project Overview</h2>

<p>
Bakewell is a fully containerised backend application deployed on AWS using
<strong>Terraform Infrastructure as Code</strong>.
</p>

<p>
This project demonstrates real-world cloud engineering practices, including:
</p>

<ul>
  <li>VPC networking with public & private subnets</li>
  <li>Application Load Balancer</li>
  <li>ECS (EC2 launch type)</li>
  <li>Auto Scaling Group</li>
  <li>RDS PostgreSQL (private)</li>
  <li>ECR for container registry</li>
  <li>CloudWatch logging</li>
</ul>

<hr>

<h2>🏗 Architecture</h2>

<pre>
Internet
   ↓
Application Load Balancer (Public Subnets)
   ↓
Target Group (Instance Type)
   ↓
ECS EC2 Instances (Private Subnets)
   ↓
Docker Container (Node.js Backend)
   ↓
Amazon RDS PostgreSQL (Private Subnets)
</pre>

<hr>

<h2>🧱 Terraform Structure</h2>

<pre>
bakewell-terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
└── modules/
    ├── vpc/
    ├── security/
    ├── alb/
    ├── compute/
    ├── ecs/
    ├── ecs-task/
    ├── ecs-service-ec2/
    ├── rds/
    └── ecr/
</pre>

<p>
Each infrastructure component is modularised for reusability and maintainability.
Values are injected between modules using variable outputs.
</p>

<hr>

<h2>🔧 Technologies Used</h2>

<ul>
  <li><strong>AWS:</strong> VPC, ALB, ECS, EC2, ASG, RDS, ECR, CloudWatch, IAM</li>
  <li><strong>Terraform:</strong> Modular design, resource dependencies, state management</li>
  <li><strong>Docker:</strong> Containerized Node.js backend</li>
  <li><strong>PostgreSQL:</strong> Managed RDS database</li>
  <li><strong>GitHub:</strong> Version control & portfolio showcase</li>
</ul>

<hr>

<h2>⚙️ Key Engineering Concepts Demonstrated</h2>

<ul>
  <li>Infrastructure as Code (IaC)</li>
  <li>Modular Terraform architecture</li>
  <li>Private subnet database isolation</li>
  <li>Security group least-privilege model</li>
  <li>Auto Scaling Group integration with ALB</li>
  <li>ECS task definitions & service configuration</li>
  <li>CloudWatch centralized logging</li>
  <li>Environment-based naming conventions</li>
</ul>

<hr>

<h2>🔐 Security Design</h2>

<ul>
  <li>RDS deployed in private subnets</li>
  <li>ALB only public entry point</li>
  <li>Backend accessible only via target group</li>
  <li>Security groups restrict DB access to backend only</li>
  <li>No direct public database exposure</li>
</ul>

<hr>

<h2>📦 Deployment Process</h2>

<ol>
  <li>Build Docker image</li>
  <li>Push image to Amazon ECR</li>
  <li>Terraform apply to provision infrastructure</li>
  <li>ECS pulls image and deploys container</li>
  <li>ALB routes traffic to backend</li>
</ol>

<hr>

<h2>📈 Scalability</h2>

<ul>
  <li>Auto Scaling Group supports horizontal scaling</li>
  <li>ALB distributes traffic automatically</li>
  <li>Multi-AZ VPC design</li>
</ul>

<hr>

<h2>🧠 What This Project Demonstrates</h2>

<p>
This project reflects hands-on cloud engineering skills, including:
</p>

<ul>
  <li>Designing production-style AWS architectures</li>
  <li>Writing clean modular Terraform code</li>
  <li>Debugging networking and security issues</li>
  <li>Integrating containerized applications with managed databases</li>
  <li>Understanding ECS EC2 vs Fargate architecture trade-offs</li>
</ul>

<hr>

<h2>👨‍💻 Author</h2>

<p>
Hamza Ahmed Siddiqui<br>
Cloud Engineer | DevOps Enthusiast | Software Developer
</p>

<p>
This repository is part of my DevOps & Cloud Engineering portfolio.
</p>

<hr>

<p align="center">
Built with ❤️ using Terraform & AWS
</p>
