# chef-services

## Background

This cookbook serves as a platform to install Chef Automate in a couple of ways:

* As a number of virtual machines spun up via Test Kitchen and vagrant,
* Using a number of existing hosts onto which the Chef Automate services can be deployed.

## Installation via Test Kitchen

### 1. Select a platform for installation

Look at the available platforms in `.kitchen.yml`:

```
platforms:
  - name: centos-6.8
  - name: centos-7.3
  - name: ubuntu-14.04
  - name: ubuntu-16.04
```

Select **ONE** of the platforms to install Chef Automate.

>NOTE: For this example, we'll use __centos-7.3__.

### 2. Create the instances

1. Run `kitchen list centos-73` to see the list of instances that will get created:

        $ kitchen list centos-73
        Instance               Driver   Provisioner  Verifier  Transport  Last Action    Last Error
        chef-server-centos-73  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
        automate-centos-73     Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
        build-centos-73        Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
        supermarket-centos-73  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
        compliance-centos-73   Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>

2. Create the instances:

        $ kitchen converge centos-73

    While the instances are getting created and converged, execute Step 3 below.        

### 3. Modify local `/etc/hosts`

1. Add the following lines to your local workstation `/etc/hosts`:

```
33.33.33.10 chef.services.com
33.33.33.11 automate.services.com
33.33.33.12 build.services.com
33.33.33.13 supermarket.services.com
33.33.33.14 compliance.services.com
```

### 4. Verify logins

Once the `kitchen converge ...` has completed, the various logins can be tested as follows.

#### Chef Server

1. Browse to [http://chef.services.com]()
2. Sign in with:
    Username: __delivery__
    Password: __delivery__

#### Automate Server

1. Obtain the credentials for the Automate login using this command:

        kitchen exec automate-centos-73 -c 'cat /etc/delivery/test.creds'

2. Browse to [http://automate.services.com/e/test]()
3. Sign in with the credentials from Step 1.

__Recommend creating a new admin user with a sane password:__

1. Browse to [https://automate.services.com/e/test/#/users]() and select __Users &rarr; + NEW USER__.
2. Fill in the __FIRST NAME, LAST NAME, EMAIL, USERNAME, and PASSWORD__ fields.  All check the __admin__ role under __Roles Within the Enterprise__.
3. Paste your public key into the __SSH KEY__ field.  Without this, subsequent `delivery` commands won't authenticate properly.
4. Click __SAVE & CLOSE__.

Future admin logins can use this account rather than the __admin__ account with its cryptic password.

#### Supermarket

1. Browse to [http://supermarket.services.com]()

#### Compliance Server

1. Browse to [http://compliance.services.com]()
2. Sign in with:
    Username: __admin__
    Password: __password__

### 5. Deploy a sample pipeline (Optional)

The sample pipeline we'll be using is from the [National Parks Cookbook](https://github.com/billmeyer/national_parks_cookbook).

#### 5.1 Create a new Workflow Organization

1. Create a new __Workflow Organization__ by browsing to [https://automate.services.com/e/test/#/organizations]().
2. Fill in the __ORGANIZATION NAME__ field with `travel-usa`.
3. Click __SAVE & CLOSE__.

#### 5.2 Create a new __Project__ in the __Workflow Organization__.

1. Browse to [https://automate.services.com/e/test/#/organizations]().
2. Click on the __travel-usa__ Workflow Org.
3. Fill in the __PROJECT NAME__ with `national_parks_cookbook`.
4. Select __Chef Automate__ for the __Source Code Provider__.
5. Click __SAVE & CLOSE__.

#### 5.3 Download the sample cookbook

For this step, we only want to pull the cookbook source from github and _not_ use github as our repo (We'll be using Chef Automate's git repo).  So, we'll pull the source and then blow away the `national_parks_cookbook/.git` directory.

1. Clone the source to the cookbook to the local workstation:

        $ git clone https://github.com/billmeyer/national_parks_cookbook
        $ cd national_parks_cookbook

2. Change git repo from GitHub to Chef Automate:

        $ git remote remove origin
        $ git remote add origin ssh://bmeyer@test@automate.services.com:8989/test/travel-usa/national_parks_cookbook
        $ git remote add delivery ssh://bmeyer@test@automate.services.com:8989/test/travel-usa/national_parks_cookbook

3. Create the project config file:

        $ delivery setup --ent=test --org=travel-usa --user=bmeyer --server=automate.services.com
        $ delivery init

## Install Chef Automate to existing infrastructure

This use case can be used for on-premise installations of Chef Automate using supplied hosts.

`kitchen create chef-server-centos-73`

`kitchen login chef-server-centos-73`

`sudo su -`

>NOTE: __-u &lt;username&gt;__ should be a user account on the remote host that has __sudo__ privileges on the remote host.

    curl -O https://raw.githubusercontent.com/stephenlauck/chef-services/master/files/default/installer.sh && \
        sudo bash ./installer.sh \
        -u vagrant -p vagrant \
        -c <chef-server-host-or-ip> \
        -a <automate-server-host-or-ip> \
        -b <build-server-host-or-ip>
