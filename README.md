## Ansible playbook for Passbolt (Ubuntu 24.04)
This playbook allows you to automatically deploy a Passbolt instance with a self-signed SSL-certificate on an Ubuntu 24.04 machine using the `secrets.yml` file

The playbook uses the [official guide](https://www.passbolt.com/docs/hosting/faq/how-to-install-passbolt-in-non-interactive-mode/) for installing Passbolt in non-interactive mode and its own script to execute post-installation steps

### Requirements
- Ubuntu 24.04 (pure system)
- Generated locale `en_US.UTF-8` (needed for the official pre-install script)

### Usage
- Clone this repository
- Create a `secrets.yml` file using the `secrets.example.yml` file (you can run `ansible-vault create secrets.yml` to create an encrypted version of this file)
- Specify in the `hosts` file the addresses of the machines to which you want to deploy the Passbolt (by default it will be deployed to hosts in the `managed` group). **In the current configuration playbook will deploy Passbolt with same variables on every host**
- Execute this playbook with the `ansible-playbook playbook.yml --ask-become-pass` command

### Variable definitions in the configuration file

|Name|Type|Definition|
|-|-|-|
|`mysql_username`|string|The name of the MySQL user to be created and used by the Passbolt|
|`mysql_password`|string|The password of the MySQL user to be created and used by the Passbolt|
|`mysql_dbname`|strting|The name of the MySQL database to be created and used by the Passbolt|
|`nginx_domain`|string|The domain name or IP address for which the SSL-certificate will be created|
|`SSL_cert_path`|string|Path where the public certificate file will be created|
|`SSL_key_path`|string|Path where the private key of the certificate will be created|
|`GPG_name`|string|Username for the server's OpenPGP key|
|`GPG_mail`|string|Email for the server's OpenPGP key|
|`SMTP_sender_name`|string|Name of the sender of emails from the server|
|`SMTP_sender_mail`|string|Email of the sender of emails from the server|
|`SMTP_password`|string|Password of the sender of emails from the server|
|`SMTP_host`|string|Address of the SMTP server|
|`SMTP_client`|string|Address from which to send requests to the SMTP server|
|`SMTP_use_TLS`|integer|Use TLS for SMTP requests or not (1 or 0)|
|`account_first_name`|string|First name of the first account created|
|`account_last_name`|string|Last name of the first account created|
|`account_mail`|string|Email of the first account created|


