deploy:
	terraform -chdir=terraform apply -var-file=prod.tfvars -var='ssh_privkey=/home/alexv/.ssh/alexv' -var='inventory_file=../../kubespray/inventory/magi/inventory.ini'

destroy:
	terraform -chdir=terraform destroy -var-file=prod.tfvars -var='ssh_privkey=/home/alexv/.ssh/alexv' -var='inventory_file=../../kubespray/inventory/magi/inventory.ini'
