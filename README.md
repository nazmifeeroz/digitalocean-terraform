# Terraforming Digital Ocean Droplet

### To apply

```shell
$ terraform apply \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_key=$SSH_KEY" \
  -var "user_name=ubuntu" \
  -var "pw=$NON_ROOT_PWD" \
  -var "hasura_admin_secret=$ADMIN_SECRET" \
  -var "domain_name=$DOMAIN_NAME"
```
