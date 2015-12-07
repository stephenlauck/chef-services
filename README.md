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
6. compliance

### Add this to your local workstation /etc/hosts

```
33.33.33.10 chef.services.com
33.33.33.11 analytics.services.com
33.33.33.12 supermarket.services.com
33.33.33.13 delivery.services.com
33.33.33.14 build.services.com
33.33.33.15 compliance.services.com
```

### Login to each service and authenticate with user/password: delivery/delivery

[http://chef.services.com](http://chef.services.com)

[http://analytics.services.com](http://analytics.services.com)

[http://supermarket.services.com](http://supermarket.services.com)

### Delivery credentials for admin login

`kitchen exec delivery -c 'cat /tmp/test.creds'`

[http://delivery.services.com/e/test](http://delivery.services.com/e/test)

### Login to compliance and authenticate with user/password: admin/password

[http://compliance.services.com](http://compliance.services.com)
