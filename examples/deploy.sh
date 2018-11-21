#!/bin/bash
ansible-playbook ./deploy.yml --extra-vars "app_file=./from_client.txt app_file_dest_path=~/ inventory_host=all"