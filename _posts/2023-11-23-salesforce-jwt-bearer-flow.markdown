---
layout: post
title:  Salesforce JWT Bearer Flow
description: Implement the JWT Bearer flow with a Salesforce Connected app
date: 2023-11-30 10:51:12 +0300
image:  '/images/jwt-bearer.png'
tags:   ["salesforce"]
---

Setting up a Connected App with the JWT Bearer Token flow can we be a challenge as you have to create server keys, configure the Connected App with the keys and correct permissions and finally construct the encrypted JWT token to pass during the OAuth dance. 

This video walks through the entire process to get you up and running quickly. 

## Steps to create keys and certificate

{% highlight js %}
// Generate a private key
openssl genpkey -des3 -algorithm RSA -pass pass:X7wjiJ166R84 -out server.pass.key -pkeyopt rsa_keygen_bits:2048

// Process the RSA keys into a file called server.key
openssl rsa -passin pass:X7wjiJ166R84 -in server.pass.key -out server.key

// Delete the server.pass.key file because you no longer need it.
rm server.pass.key

// Generate a certificate signing request using the server.key file and store it in a file called server.csr. Fill out everything and use a password (I used 123456)
openssl req -new -key server.key -out server.csr

// Generate a self-signed digital certificate from the server.key and server.csr files. Store the certificate in a file called server.crt.
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
{% endhighlight %}

<p><iframe src="https://www.youtube.com/embed/VVfz-8AwPog" loading="lazy" frameborder="0" allowfullscreen=""></iframe></p>

Links referenced in the walkthrough:

- [Create a Private Key and Self-Signed Digital Certificate](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_key_and_cert.htm)
- [OAuth 2.0 JWT Bearer Flow for Server-to-Server Integration](https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_jwt_flow.htm&type=5)
- [jwt.io](https://jtw.io)