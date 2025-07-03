## Ansible playbook for Passbolt (Ubuntu 24.04)
This playbook allows you to automatically deploy a Passbolt instance with a self-signed SSL-certificate on an Ubuntu 24.04 machine using the `secrets.yml` file

You can deploy Passbolt directly (`playbook.yml`) or via rootless Docker (`docker-playbook.yml`)

The first playbook uses the [official guide](https://www.passbolt.com/docs/hosting/faq/how-to-install-passbolt-in-non-interactive-mode/) for installing Passbolt in non-interactive mode and its own script to execute post-installation steps

The second playbook installs Docker, activates rootless mode and deploys Passbolt container using modified official [docker-compose-ce.yaml](https://download.passbolt.com/ce/docker/docker-compose-ce.yaml) file

### Requirements
- Ubuntu 24.04 (pure system)
- (Direct install) Generated locale `en_US.UTF-8` (needed for the official pre-install script)

### Usage
- Clone this repository
- Create a `secrets.yml` file using the `secrets.example.yml` file (you can run `ansible-vault create secrets.yml` to create an encrypted version of this file)
- Specify in the `hosts` file the addresses of the machines to which you want to deploy the Passbolt (by default it will be deployed to hosts in the `managed` group). **In the current configuration playbook will deploy Passbolt with same variables on every host**
- Execute this playbook with the `ansible-playbook playbook.yml --ask-become-pass` command (or `ansible-playbook docker-playbook.yml --ask-become-pass` for Docker variant)

### Variable definitions in the configuration file

|Name|Type|Definition|
|-|-|-|
|`mysql_username`|string|The name of the MySQL user to be created and used by the Passbolt|
|`mysql_password`|string|The password of the MySQL user to be created and used by the Passbolt|
|`mysql_dbname`|strting|The name of the MySQL database to be created and used by the Passbolt|
|`nginx_domain`|string|The domain name or IP address for which the SSL-certificate will be created|
|`SSL_cert_path`|string|Path where the public certificate file will be created **(Ignored in the Docker variant. It will create the certificate file in ~/certs/certificate.crt)**|
|`SSL_key_path`|string|Path where the private key of the certificate will be created **(Ignored in the Docker variant. It will create the private key file in ~/certs/certificate.key)**|
|`GPG_name`|string|Username for the server's OpenPGP key|
|`GPG_mail`|string|Email for the server's OpenPGP key|
|`SMTP_sender_name`|string|Name of the sender of emails from the server|
|`SMTP_sender_mail`|string|Email of the sender of emails from the server (same value will be provided in sender's username variable)|
|`SMTP_password`|string|Password of the sender of emails from the server|
|`SMTP_host`|string|Address of the SMTP server|
|`SMTP_client`|string|Address from which to send requests to the SMTP server|
|`SMTP_use_TLS`|integer|Use TLS for SMTP requests or not (1 or 0)|
|`account_first_name`|string|First name of the first account created|
|`account_last_name`|string|Last name of the first account created|
|`account_mail`|string|Email of the first account created|

### After install
After the direct installation you will need to go to the Passbolt instance page and enter the email of the first created user. Passbolt will send an email with a link to set up this account

After the Docker installation you will only need to wait for the email that Passbolt will send automatically


