## Terraform projects

In the project direcoty you can:

### `cd ssh-to-instance && terraform apply -var-file prod.tfvars`

This will run ssh-to-instance terraform configuration. Be sure to create a var file (e.g. prod.tfvars),
specify value for ubuntu_instance_key_name and only after that run the command.

To ssh into the EC2 instance, use a command  `ssh -i path/to/private/key ubuntu@publicInstanceIp` (specify your private key path and public instance IP address)
