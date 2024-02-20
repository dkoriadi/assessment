# Assessment

> Design an automation deployed with GitHub/GitLab pipelines to create load balanced simple Nginx hosted on 1 or more virtual machines on AWS or Azure

### Output

Successful execution IaC pipeline recorded here:
https://github.com/dkoriadi/assessment/actions/runs/7968333224

REST API accessible from endpoint:
http://proj-alb-1772570794.ap-southeast-1.elb.amazonaws.com/vend_ip

The subnet IP address will be shown differently for each request as the request is load balanced across two different virtual machines.

### Solution

Pipeline for IaC automation using GitHub Actions:
https://github.com/dkoriadi/assessment/blob/main/.github/workflows/tf-plan-apply.yml

Terraform creates the below infrastructure in AWS:
1. Two public subnets across different availability zones
2. Two different virtual machines in each subnet with SSH keys
3. Load balancer to balance incoming requests across the two different virtual machines across different subnets
4. Setup Nginx within the virtual machines with REST API endpoints

### Folder Structure
    .
    ├── .github/workflows
    │   └── tf-plan-apply.yml   # Automation pipeline using GitHub Actions
    ├── README.md
    └── terraform               # Infrastructure-as-code deployment
        ├── files               # Files for server configuration in VM
        │   ├── app.py          # REST API endpoint
        │   └── nginx.conf      # Nginx configuration file
        ├── (tf files)
        ├── ...
        ├── ...
        └── env.tfvars          # Variables for Terraform

### Observations

> Take into consideration CSP Best Practices such as security and resiliency

- Security groups have been created both on the instances and load balancer with ingress/egress rules for certain ports only
- Virtual machines (EC2 instances) are in different availability zones (multi-AZ) for high availability
- For additional security, a SSL certificate should be installed on the load balancer to enable HTTPS.
- For monitoring of infra health, the load balancer can be configured to include regular health checks to the virtual machines. Cloudwatch Agent can also be installed in the virtual machines to pipe `stdout` and `stderr` messages into Cloudwatch. 

> Take into consideration coding/scripting practices

- Terraform code: Split into multiple files for variables, data and components for ease of navigation
- Automation: Any changes to cloud infrastructure can only be done on main branch and requires manual approval
- Automation: Each proposed change to infra done via pull request will trigger a `tf plan` and output the resulting changes
- Automation: Secrets are stored in GitHub directly and retrieved by the pipeline during execution



