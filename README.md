# Terraform Multicloud Infrastructure

This repository hosts Terraform code to provision infrastructure across multiple clouds including Azure, and Oracle Cloud .

## Prerequisites

- Terraform
- Nodejs ( Needed for Vpn Script )
- Variables from variables.tf in environment ( You can add them to your bashrc file like this -> export TF_VAR_ssl_password="somepassword" )
- Oracle and Azure Cloud ( No Aws for now )
  
## Installation

```bash
git clone https://github.com/Moody-san/terraform-multicloud-infra.git
cd terraform-multicloud-infra
```
## Usage

- terraform init
- terraform plan
- terraform apply

## Configuration

Edit the server.tf file to easily scale up and down on Oracle and Azure Cloud

## Miscs

- If you dont need azure you can comment out azureresources.tf and its servers in server.tf
- Similarly you can comment out vpn.tf to not setup vpn between both clouds
- Our usecase for vpn was to sync MariaDb and Reuse jenkins, Argo and bastion servers.
- To setup kubernetes on this infrastructure have a look at -> https://github.com/Moody-san/ansible-k8s-deployment
- To setup MariaDb Cluster with k8s based failover have a look at -> https://github.com/Moody-san/ansible-galeracluster-deployment
- For CiCd and other automation scripts have a look at -> https://github.com/Moody-san/ansible-controller-setup
