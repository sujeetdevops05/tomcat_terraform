# tomcat_terraform


Following tech are being used to build this project
    1. Packer
    2. Ansible
    3. Terraform

1. Packer
Packer is used to install base ansible and build the ec2 ami

2. Ansible
Ansible is used to install java and tomcat

3. Terraform
Terraform to build the Infrastructure in AWS

Build Guide
************

Ansible_role: apache-tomcat-6.0.20 and Java installation will be done by 
             ansible role.

Packer: ansible role will be automate to the machine image by below command.
packer build -var-file=vars.json packer.json

Terraform: Deploy the autoscaling group using terraform by the Terraform plan and Terraform apply command to autoscalinggroup.tf file

Verify Load Balaners and Autoscaling group in the AWS console.
