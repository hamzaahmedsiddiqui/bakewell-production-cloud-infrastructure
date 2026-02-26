<h2>🚀 How to Run This Project (Terraform + Deployment)</h2>

<h3>✅ Prerequisites</h3>
<ul>
  <li>AWS Account + IAM user/role with permissions for: VPC, EC2, ECS, ECR, ALB, RDS, CloudWatch, IAM</li>
  <li><a href="https://developer.hashicorp.com/terraform/downloads" target="_blank">Terraform</a> installed</li>
  <li><a href="https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html" target="_blank">AWS CLI</a> installed</li>
  <li>Docker installed (to build/push the backend image)</li>
</ul>

<h3>1) Configure AWS CLI</h3>
<pre>
aws configure
# Set:
# AWS Access Key ID
# AWS Secret Access Key
# Default region: us-west-2
# Output format: json
</pre>

<h3>2) Clone Repository</h3>
<pre>
git clone https://github.com/hamzaahmedsiddiqui/bakewell-terraform.git
cd bakewell-terraform
</pre>

<h3>3) Initialize Terraform</h3>
<pre>
terraform init
</pre>

<h3>4) Create Terraform Variables File</h3>
<p>Create a file called <code>terraform.tfvars</code> (or use environment variables) and add values like:</p>

<pre>
project_name  = "bakewell"
environment   = "prod"

db_name       = "bakewell_dev"
db_user       = "bakewelladmin"
db_password   = "YOUR_DB_PASSWORD"
</pre>

<p><strong>Tip:</strong> If you don’t want Terraform asking for the DB password each time, define it in <code>terraform.tfvars</code>.</p>

<h3>5) Plan & Apply Infrastructure</h3>
<pre>
terraform plan
terraform apply
</pre>

<p>This provisions:</p>
<ul>
  <li>VPC (public/private subnets + routing)</li>
  <li>Security groups</li>
  <li>ALB + Listener + Target Group</li>
  <li>ECS Cluster (EC2 launch type)</li>
  <li>Auto Scaling Group + Launch Template</li>
  <li>RDS PostgreSQL</li>
  <li>ECR repository</li>
  <li>CloudWatch log group</li>
</ul>

<hr>

<h2>🐳 Build & Push Backend Image to ECR</h2>

<h3>1) Login to ECR</h3>
<pre>
aws ecr get-login-password --region us-west-2 \
| docker login --username AWS --password-stdin 738561339***.dkr.ecr.us-west-2.amazonaws.com
</pre>

<h3>2) Build & Push Image</h3>
<p>If you're on Apple Silicon (M1/M2/M3), build for amd64 to match ECS EC2 instances:</p>

<pre>
cd backend

docker buildx build \
  --platform linux/amd64 \
  --provenance=false \
  -t 73856133****.dkr.ecr.us-west-2.amazonaws.com/bakewell-prod-backend:latest \
  --push .
</pre>

<h3>3) Force ECS Service to Pull the New Image</h3>
<pre>
aws ecs update-service \
  --cluster bakewell-prod-cluster \
  --service bakewell-prod-service \
  --force-new-deployment \
  --region us-west-2
</pre>

<hr>

<h2>✅ Verify Deployment</h2>

<h3>1) Check ECS Service Status</h3>
<pre>
aws ecs describe-services \
  --cluster bakewell-prod-cluster \
  --services bakewell-prod-service \
  --region us-west-2 \
  --query "services[0].events[:10]"
</pre>

<h3>2) Check CloudWatch Logs</h3>
<p>Look for application logs:</p>
<pre>
/ecs/bakewell-prod
</pre>

<h3>3) Test Health Endpoint via ALB</h3>
<p>Get the ALB DNS name:</p>
<pre>
aws elbv2 describe-load-balancers \
  --region us-west-2 \
  --query "LoadBalancers[?contains(LoadBalancerName,'bakewell-prod')].DNSName" \
  --output text
</pre>

<p>Then open:</p>
<pre>
http://&lt;ALB_DNS_NAME&gt;/health
</pre>

<hr>

<h2>🧹 Destroy Infrastructure</h2>
<pre>
terraform destroy
</pre>

<p><strong>Warning:</strong> This deletes AWS resources. Use with care.</p>
