#!/bin/bash

#set -e


yum  install -y ansible
yum  install -y jq

cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg


