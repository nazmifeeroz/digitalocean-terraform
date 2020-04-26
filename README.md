# Terraforming Digital Ocean Droplet

### To apply

```shell
$ terraform apply \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_key=$SSH_KEY" \
  -var "user_name=ubuntu" \
  -var "pw='somePassword'"
```
