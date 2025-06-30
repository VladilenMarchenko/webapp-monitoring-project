# Webapp Monitoring Project

Автоматизоване розгортання веб-додатку з системою моніторингу використовуючи Terraform, Ansible та Docker.

## Компоненти

- **Terraform**: Створення інфраструктури в AWS
- **Ansible**: Автоматизація налаштування серверів
- **Docker**: Контейнеризація додатків
- **Prometheus + Grafana**: Моніторинг та візуалізація

## Швидкий старт

1. Встановіть необхідні інструменти:
   - Terraform
     - ```bash
          wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg;
          echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list;
          sudo apt update && sudo apt install terraform```
   - Ansible
     - ```
       sudo apt update
       sudo apt install software-properties-common
       sudo add-apt-repository --yes --update ppa:ansible/ansible
       sudo apt install ansible
       ```
   - AWS CLI

2. Налаштуйте AWS credentials:
   ```bash
   aws configure
   ```

3. Згенеруйте SSH ключі:
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/webapp-key
   ```

4. Запустіть розгортання:
   ```bash
   ./scripts/deploy.sh
   ```

5. Для видалення інфраструктури:
   ```bash
   ./scripts/destroy.sh
   ```

## Структура проекту

- `terraform/` - Конфігурація інфраструктури
- `ansible/` - Playbooks та ролі для налаштування
- `docker/` - Dockerfile та код додатку
- `scripts/` - Скрипти автоматизації

## Доступ до сервісів

Після розгортання ви отримаєте URL адреси для:
- Web Application
- Grafana Dashboard (admin/admin)
- Prometheus Metrics
