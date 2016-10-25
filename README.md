# Context

The repo, Chef-Services, will become the recommended way to install commercial Chef Products.
It provides full automation of the install.
It works both behind the firewall on pre-provisioned machines and out on the internet.

For provisioning:
- It will set up today in any environment where the machines are already provisioned, including VMware.
- it supports the provisioning step today only on AWS.
- In the future it will provision other computing resources using Terraform; this is not yet supported. https://github.com/stephenlauck/chef-services/issues/44

## Objectives
- This suite is for people that want a full set of Commercial products for Chef. 
- This installs Chef Server, Chef Automate (Workflow, Visibility and Compliance)

## Product Maturity
- This in active test on some large customer sites.
- It is still considered preproduction and needs hand-holding to install

## Environments 
- Presently works on Ubuntu 14, Centos 6 & 7.
- Some issues on Ubuntu 16.

## Pre-requisites
list the things I need to have / know before starting
- You must be prepared to run Chef Server for controlling your nodes (no Chef Solo)
- It must be a Chef 12 server
- An accessible domain (assumed ".services.com") must be in a DNS server reachable by the servers
- 


## Manual Preparation
list the things I need to do before 
- change .services.com in (which?) files

## How to install
- what do I log into
- what do I clone
- what do I run

## Troubleshooting
- known issues
- order of things to check
- how to ask for help

# chef-services
```
kitchen list - shows AWS nodes
kitchen converge - does what??
```
### Sets up:

kitchen converge - does what??
1. chef-server
4. automate
5. build-node
3. supermarket
6. compliance

## Process

If you don't have DNS pointing to the computing resources.
### Add this to your local workstation /etc/hosts

```
33.33.33.10 chef.services.com
33.33.33.11 automate.services.com
33.33.33.12 build.services.com
33.33.33.13 supermarket.services.com
33.33.33.14 compliance.services.com
```

#### Login to chef-server  

?? Does my Chef Server have to already exist?
?? What steps do I do to actually install??

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
