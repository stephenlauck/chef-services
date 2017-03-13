directory '/etc/chef' do
  mode 0755
  recursive true
end

file '/etc/chef/delivery-validator.pem' do
  content <<-eos
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAuK094FPDVk8YgRxNyCszfpMwuoLinQGbDtHUtiqodVrJk5Q8
PYN7f8K5tM61tPMv0VduCDahm7LXOLk/SWgIlBFdBurrwMeIsRhoqohtsUW2qhaK
SX6dhPjWjFAwP1C8WqjL9xuyWTMjS6hF2w6+za43OLvV+srnoBPIcRDWqr/76IbO
1RO+fgw1cX4FBPHp+rdJI/BjkufSQNGEQuWaQDYv7ZGgCBgb0xtOEARlHZUWBCjc
W6apMo6jKnOCEqvheN6PboSYXAITwueLdGB7COOJxa9h3vZYI9jFqUKMMV/kTCls
5KlnxI0ATDTeZ4Y9KASNISQQA0Sv0i1R28Oy+wIDAQABAoIBAGSRaxXDZ6eTsSt2
J2FvLT6rlyiqaA/KNQ9v8x80wcIOq6EjY164QEPF3e15d/hPSmX8752naoBods2c
C7vE3I8NmZRP0AyOXIDcYvsjCmE0LpIXbj0xp0QnYmbMsEl6hOf17gTmX0w2De2A
eHIfaIaHbekGWTOW1WYV/9yap9wZfYS4zDtES5LX+wTakxHV3Dl1XTTVzkhebrBg
t7v7bpM37CuCAXNM6SWQkfZ1Rt8sDdvteKmIJhlkNfSaH9ofS8RnJqCdHqSm8frN
EkqfIJ9yRXsRgXlINSsGH/zoBuCxt6pkdFPpOU5K4pJ4HxJAOzqkLnaO87PqABmA
1MIhdTECgYEA33G2N/M1P5IUnYsq91eWqH8W1voTrhaLHAWOiiqz7EGL5efXxmuR
YbEOJbLw86uNbLNmxuG1R89NDOP7YlzNWpCHFJKgENdBi7PoCIEHW7I37V+55jJg
qrotCj5CU+dFYsOO34iZtaJNO6A3GGI8z/mX8vQf1pwKHonIu0X2/rMCgYEA05WI
6pPLJrEfVyKaTAehUm480HWaQ4wfmp3S8JejD35oL7rd0O/eILnkpcNcwb6sv+On
OxeJap2XtjCMODY+qU/UDCE8lZCpjwoxF1eeGqouGqYxpaGKWQ5DHq3GYoiiWOA1
KaiLPHhWyaIQ4soI9zw+af8DN9co3T/Op5fBnpkCgYEAraK/51qn1m6+dm7fRLZb
7TRVm1laUb5S+8OVsOjeSInnHRG9LAQLRc9BHyqe87wsenwvMf3T0anWRl4jy5wy
OF53mhUXLf8YgGeduH4MKcWkkGIDJE+hrwpeVcdr46ek08sEC9ErIWqueddW+Svd
9gAPhE0RMMSxWGnaAy2rcuECgYBTIGjOYIpsBSKfBUVBoa3LyOuzqsCU0TSJdoAt
biXuLGeaePw03kiS6vXd+kczB0qviS1mlfSzIn88YQ519znfIzHYIia/TDqRrBtl
ZFMFft7mMW1H+ZN1MZlFMFjE1ZGTAWNhnoo1k8HlLfscXuvu1ohe9IW7Jpkzc6Ip
TgIP4QKBgAfH73z9nQ1GObORMDxw6LatGmC0xyYGDDQPdkEfNXa+EcdWbiB4rElS
U+AfElCk1SMK7vru/ZD/iRE0SBdtrTi7ZTpvB1sJYlk0LjrDTGG0n6OCsT6XOQSd
1hTdaZ9y3hUzjL/NSulIELEmzF2Rm6QnKD1rOsTfl2aPCrpf1OWB
-----END RSA PRIVATE KEY-----
eos
end

file '/etc/chef/client.rb' do
  content <<-EOF
log_level                :info
log_location             STDOUT
validation_client_name   "delivery-validator"
validation_key           "/etc/chef/delivery-validator.pem"
chef_server_url          "https://chef.services.com/organizations/delivery"
encrypted_data_bag_secret "/tmp/kitchen/encrypted_data_bag_secret"
EOF
end

file '/etc/chef/dna.json' do
  content <<-EOF
{
    "delivery": {
        "fqdn": "automate.services.com",
        "chef_server": "https://chef.services.com/organizations/delivery"
    },
    "chef_automate": {
      "fqdn": "automate.services.com"
    },
    "chef_server": {
      "fqdn": "chef.services.com"
    },
    "supermarket_omnibus": {
      "chef_oauth2_verify_ssl": false
    },
    "run_list": [
        "role[patch]",
        "recipe[chef-services::compliance]"
    ],
    "chef_environment": "delivered"
}
  EOF
end

execute 'knife ssl fetch -c /etc/chef/client.rb'

execute 'chef-client -j /etc/chef/dna.json'
