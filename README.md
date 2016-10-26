# Context

The repo, Chef-Services, will become the recommended way to install both the Open Source and commercial Chef Products.
It provides full automation of the install.
It works both behind the firewall on pre-provisioned machines and out on the internet.
It is a work in progress.

For provisioning:
- It will set up today in any environment where the machines are already provisioned, including VMware.
- Server provisioning is presently out of scope from this repository. Just supply IP addresses.
- it supports the provisioning step today only on AWS; this is covered in https://github.com/echohack/tf_chef_automate
- In the future it will provision other computing resources using Terraform; this is not yet supported. https://github.com/stephenlauck/chef-services/issues/44

## Objectives
- This suite is for people that want a full set of Commercial products for Chef. 
- This installs:
-- Chef Server,
-- Chef Supermarket
-- Chef Automate (Workflow, Visibility and Compliance)

## Product Maturity
- This in active test on some large customer sites.
- It is still considered preproduction and needs hand-holding to install

## Environments 
- Presently works on Ubuntu 14, Centos 6 & 7.
- Some issues on Ubuntu 16.

## Installation

You perform the installation from a Chef Server. It will either provision and use or just use the other machines in the /etc/hosts file.
Chef Server itself does not have to (but can) be installed prior to running

## Pre-requisites
list the things I need to have / know before starting
- You must be prepared to run Chef Server for controlling your nodes (no Chef Solo)
- It must be a Chef 12 server
- An accessible domain (assumed ".services.com") must be in a DNS server reachable by the servers
- All servers need access via the ssh keys held on the Chef Server server

## Manual Preparation
list the things I need to do before 
- change .services.com in (which?) files
- plan IP addresses for the VMs used for the services

## How to install
- what do I log into
``ssh your-empty-chef-server``
- what do I clone
``git clone https://github.com/stephenlauck/chef-services.git``
- preparation
Set up your /etc/hosts file
- what do I run
``kitchen create 72``

## Troubleshooting
- known issues
- order of things to check
- how to ask for help

### Testing and Development
See TESTING.md

?? It's not clear if these are only for development and testing
```
kitchen list - shows AWS nodes
kitchen converge - see TESTING.md
```




#### Example Output

`` blah blah ``

## Success!

You can now login to the Chef services with the details shown below.

## Next Steps
- Change passwords.
- Enjoy

##### user/password: delivery/delivery
[http://chef.services.com](http://chef.services.com)

### Automate credentials for admin login

`kitchen exec delivery -c 'cat /tmp/test.creds'`

[http://automate.services.com/e/test](http://automate.services.com/e/test)

#### Supermarket
[http://supermarket.services.com](http://supermarket.services.com)

### Login to compliance
##### user/password: admin/password

[http://compliance.services.com](http://compliance.services.com)

### Chef simple install

`kitchen create chef-server-centos-72`

`scp -p files/default/installer.sh vagrant@33.33.33.10:/tmp/installer.sh`

`ssh vagrant@33.33.33.10 "sudo /tmp/installer.sh -c 33.33.33.10"`

or

`curl -O https://raw.githubusercontent.com/stephenlauck/chef-services/master/files/default/installer.sh && sudo bash ./installer.sh -c 33.33.33.10 -a 33.33.33.11 -b 33.33.33.12 -u vagrant -p vagrant`
