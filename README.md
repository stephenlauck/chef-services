# chef-services

```
kitchen list
kitchen converge
```
### Sets up:

1. chef-server
2. analytics
3. supermarket
4. delivery
5. build-node

#### Must have a license key to build Delivery
`scp -i ~/.vagrant.d/insecure_private_key /PATH_TO_YOUR/delivery.license root@33.33.33.13:/var/opt/delivery/license/delivery.license`

### Add this to your local workstation /etc/hosts

```
33.33.33.10 chef.example.com
33.33.33.11 analytics.example.com
33.33.33.12 supermarket.example.com
33.33.33.13 delivery.example.com
33.33.33.14 build.example.com
```

### Login to each service and authenticate with 'delivery' / 'delivery'

[http://chef.example.com](http://chef.example.com)

[http://analytics.example.com](http://analytics.example.com)

[http://supermarket.example.com](http://supermarket.example.com)

### Delivery credentials for admin login

`kitchen exec delivery -c 'cat /tmp/test.creds'`

[http://delivery.example.com/e/test](http://delivery.example.com/e/test)
