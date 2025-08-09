# erpnext-ecom-docker
Custom Image of ERPNext with Ecommerce Integrations app

Images are pushed to https://hub.docker.com/r/geodoomcraft/erpnext-ecom

Images contain the following:
- https://github.com/frappe/frappe - version-15 branch
- https://github.com/frappe/erpnext - version-15 branch
- https://github.com/frappe/ecommerce_integrations - main branch

The above repositories are checked once a day for version changes, if any are updated the image is rebuilt and pushed to docker hub.

## Tag naming
Tags are named using the following:
v15-frappe-xx.xx.x-erpnext-xx.xx.x-ecom-x.xx.x

Each repo is named and then followed by the version used at the time of the image's build.

So `v15-frappe-15.76.0-erpnext-15.74.0-ecom-1.20.1` means:
- Frappe version 15.76.0
- Erpnext version 15.74.0
- Ecommerce Integrations version 1.20.1

The latest tag will always contain the latest build.

## Usage
Recommended usage of this image is to use the official pwd.yml for docker compose and modify it slightly to work with the ecommerce integration.

Firstly make a copy of the pwd.yml (https://github.com/frappe/frappe_docker/blob/main/pwd.yml⁠) and then replace the frappe erpnext image with this one. Eg. Replace frappe/erpnext:vXX.XX.X with geodoomcraft/erpnext-ecom:v15-frappe-15.76.0-erpnext-15.74.0-ecom-1.20.1

Next there is a line in create-site service which creates the site

```
bench new-site --mariadb-user-host-login-scope='%' --admin-password=admin --db-root-username=root --db-root-password=admin --install-app erpnext --set-default frontend;
```
In this line, add --install-app ecommerce_integrations


So it will end up looking like this:

```
bench new-site --mariadb-user-host-login-scope='%' --admin-password=admin --db-root-username=root --db-root-password=admin --install-app erpnext --install-app ecommerce_integrations --set-default frontend;
```
From here just run it with docker compose and it should work just like the standard image but with ecommerce integrations app installed.
