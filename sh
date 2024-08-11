#!/bin/bash
cp /etc/ansible/hosts /var/lib/jenkins/hosts_bcp_$(date +"%d-%m-%yT%H:%M:%S")
ssh-keyscan $(terraform output -raw ipbild) >> ~/.ssh/known_hosts
echo "[bild]" > /etc/ansible/hosts
echo "server1 ansible_host=$(terraform output -raw ipbild)" >> /etc/ansible/hosts
ssh-keyscan $(terraform output -raw ipprod) >> ~/.ssh/known_hosts
echo "[prod]" >> /etc/ansible/hosts
echo "server1 ansible_host=$(terraform output -raw ipprod)" >> /etc/ansible/hosts
echo "[all:vars]" >> /etc/ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> /etc/ansible/hosts
echo "myrepo=$(terraform output -raw myrepo)" >> /etc/ansible/hosts