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

### vsphere settings

If you would like to bootstrap this into a vSphere environment, you need to edit the `.kitchen.vsphere.yml` file. The following settings should get you most of the way there.

Fill out anything that is in UPPERCASE.

```
  driver_options:
    host: 'HOSTIP'
    user: 'USERNAME'
    password: 'PASSWORD'
    insecure: true
  machine_options:
    start_timeout: 600
    create_timeout: 600
    ready_timeout: 90
    bootstrap_options:
      use_linked_clone: true
      datacenter: 'DATACENTER'
      template_name: 'TEMPLATENAME'
      template_folder: 'FOLDER'
      resource_pool: 'CLUSTER'
```

The SSH transport account.

```
ssh:
  user: admini # ssh username
  paranoid: false
  password: admini # ssh password
  port: 22
```

The SSH transport account.

```
transport:
  username: "admin" # ssh username
  password: admini # ssh password
```

After this, you can run:

```bash
$ KITCHEN_YAML=.kitchen.vsphere.yml kitchen list
```

and

```bash
$ KITCHEN_YAML=.kitchen.vsphere.yml kitchen converge ubuntu
```

#### Login to chef-server
##### user/password: delivery/delivery
[http://chef.services.com](http://chef.services.com)

### Automate credentials for admin login

`kitchen exec delivery -c 'cat /etc/delivery/test.creds'`

[http://automate.services.com/e/test](http://automate.services.com/e/test)

#### Supermarket
[http://supermarket.services.com](http://supermarket.services.com)

### Login to compliance
##### user/password: admin/password

[http://compliance.services.com](http://compliance.services.com)

### Chef simple install

`kitchen create 72`

`kitchen login chef-server-centos-72`

`sudo su -`

`curl -O https://raw.githubusercontent.com/stephenlauck/chef-services/master/files/default/installer.sh && sudo bash ./installer.sh -c chef.services.com -a automate.services.com -b build.services.com -u vagrant -p vagrant`
