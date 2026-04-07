# Ansible Docker Image

## Table Of Content

* [Self building the image & using it](#self-building-the-image--using-it)
  * [Building the image](#building-the-image)
  * [Uploading the image](#uploading-the-image)
  * [Using the built image](#using-the-built-image)
* [Using the pre-uploaded image](#using-the-pre-uploaded-image)
* [Using the ansible-wrapper script](#using-the-ansible-wrapper-script)
  * [Example](#example)
* [Versioning](#versioning)
* [Contributing](#contributing)
* [License](#license)

## Included collections

The following collections are included by now:

* ansible.netcommon
* ansible.posix
* ansible.utils
* cisco.nxos
* community.docker
* community.general
* community.grafana
* community.hashi_vault
* community.network
* community.postgresql
* community.rabbitmq
* dellemc.openmanage
* juniper.device
* kubernetes.core
* netbox.netbox

I included them on the base of "do I need them or not?".

If you need more collections feel free to add them and create a PR - see [Contributing](#contributing)!

## Self building the image & using it

### Building the image

To build the image, simply run this command:

```bash
docker build -t local-imagename:tagname .
```

Or if you plan to push it to a registry:

```bash
docker build -t registry/imagename:tagname .
```

### Uploading the image

After building the image, you can push it to a registry like this:

```bash
docker push registry/imagename:tagname
```

### Using the built image

You can use the image locally like this:

```bash
docker run -it --rm --name ansible local-imagename:tagename
```

Or after pushing it to a registry:

```bash
docker run -it --rm --name ansible registry/imagename:tagname
```

## Using the pre-uploaded image

### Simple Test

To test if the image works, you can run this command:

```bash
docker run -it --rm --name ansible \
    d3niswalth3r/ansible-docker:3.13.1 ansible --version
```

### Advanced Usage

For advanced usage, like running playbooks and using `ansible-vault` it is highly recommended to use
a wrapper script or run the container like this (ensure the variables are defined, of course):

```bash
docker run -it --rm \
    --name "ansible-$(date +%s || true)" \
    -e "USER=${USER}" \
    -e "ANSIBLE_USER=${USER}" \
    -e "ANSIBLE_REMOTE_USER=${USER}" \
    -e "ANSIBLE_REMOTE_TEMP=/var/tmp/.ansible-${USER}/tmp" \
    -e "SSH_AUTH_SOCK=${SSH_AUTH_SOCK}" \
    -v "${HOME}/.ssh:/root/.ssh:ro" \
    -v "${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK}" \
    -v "${ANSIBLE_REPO_PATH}:/ansible" -w /ansible \
    -v "${ANSIBLE_ROLES_PATH}:/ansible_roles" \
    d3niswalth3r/ansible-docker:3.13.1 \
    ansible-playbook -i inventory/ playbooks/site.yml --check
```

## Using the ansible-wrapper script

The ansible wrapper script will create symlinks in the defined bin folder for each binary of ansible.
With those you can simply run the. commands `ansible-playbook` or `ansible-vault` without the long docker command.

The setup is pretty straightforward:

* Copy the script to a folder in your `$PATH` and ensure it has executable permissions
* Setup the config in your `$HOME` or copy the `ansible-wrapper.conf.example` to `~/.ansible-wrapper.conf`
* Run it with its name: `ansible-wrapper` - the script will set everything up for you
* Now you can run the following commands without a long docker command:
  * ansible
  * ansible-builder
  * ansible-community
  * ansible-config
  * ansible-console
  * ansible-creator
  * ansible-doc
  * ansible-galaxy
  * ansible-inventory
  * ansible-lint
  * ansible-navigator
  * ansible-playbook
  * ansible-pull
  * ansible-runner
  * ansible-sign
  * ansible-test
  * ansible-vault

### Example

```bash
$:> ansible --version
ansible [core 2.20.3]
  config file = /ansible/ansible.cfg
  configured module search path = ['/ansible/plugins/modules']
  ansible python module location = /opt/ansible-venv/lib/python3.13/site-packages/ansible
  ansible collection location = /opt/ansible-venv/collections
  executable location = /opt/ansible-venv/bin/ansible
  python version = 3.13.12 (main, Mar 16 2026, 23:05:06) [GCC 14.2.0] (/opt/ansible-venv/bin/python3)
  jinja version = 3.1.6
  pyyaml version = 6.0.3 (with libyaml v0.2.5)
```

## Versioning

The versioning follows a simple pattern:

| Minimum OS Version Suppoprted | Ansible Version | Patchversion |
| --- | --- | --- |
| Python3 -> 3 | Ansible 13 -> 13 | First working version -> 1 |

This will equal to version `3.13.1`.

## Contributing

You are more than welcome to create pull requests for new features, functions or adding collections:

1. Create a new branch
2. Adjust or add the code desired
3. Ensure the image still works as intended
4. Create a PR

## License

MIT
