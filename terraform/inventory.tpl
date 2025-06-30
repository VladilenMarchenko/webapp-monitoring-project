all:
  children:
    webservers:
      hosts:
        webapp:
          ansible_host: ${webapp_ip}
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/webapp-key
    monitoring:
      hosts:
        monitor:
          ansible_host: ${monitoring_ip}
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/webapp-key
