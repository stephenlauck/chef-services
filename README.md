# chef-services
```
kitchen list
kitchen converge
```
### Sets up:

1. chef-server
4. automate
5. build-node
3. supermarket
6. compliance

### Add this to your local workstation /etc/hosts

```
33.33.33.10 chef.services.com
33.33.33.11 automate.services.com
33.33.33.12 build.services.com
33.33.33.13 supermarket.services.com
33.33.33.14 compliance.services.com
```

#### Login to chef-server  
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

`curl -O https://raw.githubusercontent.com/stephenlauck/chef-services/ad/fixes/files/default/installer.sh && sudo bash ./installer.sh -c 33.33.33.10 -a 33.33.33.11 -b 33.33.33.12 -u vagrant -p vagrant`
