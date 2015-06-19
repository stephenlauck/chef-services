# chef-services

```
kitchen list
kitchen converge
```
### Sets up:

1. chef-server
2. chef-analytics
 
~~3. chef-delivery~~

4. chef-supermarket

### The delivery server may fail on converge and give an error that your license key was not found.
### Make sure to upload your Delivery License.
```
scp -i ~/.vagrant.d/insecure_private_key /PATHTOLICENSEKEY/delivery.license root@33.33.33.12:/var/opt/delivery/license/delivery.license
```

### Add this to your local workstation /etc/hosts

```
33.33.33.10 chef.example.com
33.33.33.11 analytics.example.com
33.33.33.12 delivery.example.com
33.33.33.13 supermarket.example.com
```

### Login to each service and authenticate with 'testuser' / 'testuser'

[http://chef.example.com](http://chef.example.com)

[http://analytics.example.com](http://analytics.example.com)

[http://delivery.example.com](http://delivery.example.com)

[http://supermarket.example.com](http://supermarket.example.com)

#### log in credentials for your delivery server are on the server
```
kitchen login delivery
cat /tmp/test.creds
```
