### Test task

## Short description

This main goal of this task is to containerize the application in the ./src directory, setup infrastructure and CI/CD.
I chose Hetzner CLoud for the provider, terraform and ansible for infrastructure provision and server setup: setting the users and microk8s configuration. GitHub Actions is used for build and deploy with self-hosted agent.

## Setup

First, it's important to generate the key which will be used for ssh connection to the server:
```ssh-keygen -f ~/.ssh/hetzner -t rsa -b 4096 -N '' -C ''```

Also, let's put other public keys in the ~/.ssh directory for future automation of users creation process:
``` cp phrase_admin.pub phrase_user.pub ~/.ssh ```

Now, It should be created new project and API token in the Hetzner Cloud: the token should be placed in the ./terraform/terraform.tfvars in the variable
``` hcloud_token = %PLACE_TOKEN_HERE% ```

After that it's possible to run `terraform init`, `terraform plan` and `terraform apply` from the ./terraform directory. That should create server with ipv4 address attached and all the necessary users setup.

Terraform automatically creates inventory for ansible, so we could cd into `./ansible` and run
```ansible-playbook microk8s.yml --private-key ~/.ssh/hetzner  -i inventory -e "github_token=%TOKEN_FOR_SELFHOSTED_AGENT%" -e "install_github_agent=true"```

It's needed the github token for the self-hosted runner, there is description how to setup it: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners

After running ansible playbook any changes of the source code or helm chart will be deployed to the microk8s cluster and will be available through ingress
