# 2dv517-project

## Introduction
This is for an assignment in the course 2DV517 at Linnaeus University 2021. 
We are Elias, Emil, Lucas and Delfi. 

## Set up 
Clone this repo. 

Install Terraform. 

Install the Openstack CLI. 

In the CsCloud dashboard, download the clouds.yaml and openrc.sh and add them to the directory. 

Run "source ./openrc.sh" and type in the password to your CsCloud account to add these as environment variables.

Create a file terraform.tfvars and add the neccessary information. Look at terraform.tfvars.sample for an example. 

Add the backup files "acme_wordpress_files.tar.gz", "backup.sql" and "acme.wordpress.2018-10-09.xml" to the directory ansible/files. 