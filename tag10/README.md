# Monitoring Setup (KN05 B) mit Ansible, Terraform & AWS Dynamic Inventory

Dieses Verzeichnis enthält die Ansible-Konfiguration und ein zweistufiges Playbook zur automatisierten Anpassung der **AWS Security Group** mittels Terraform sowie zur Bereitstellung der Monitoring-Umgebung (**cAdvisor**, **Prometheus**, **Grafana**) auf der **SonarQube VM**.

## Dateiübersicht

- **[../tag07/sonarqube-vm.tf](file:///Users/ado/tmp/git_tbz/hf/stud/devops/musterloesungen-praxisauftraege/tag07/sonarqube-vm.tf)**: Erweitertes Terraform-Manifest mit Ingress-Regeln für die Ports 3000 (Grafana), 9090 (Prometheus) und 8080/8090 (cAdvisor).
- **[aws_ec2.yml](file:///Users/ado/tmp/git_tbz/hf/stud/devops/musterloesungen-praxisauftraege/tag10/aws_ec2.yml)**: Dynamic Inventory Konfiguration für das `amazon.aws.aws_ec2` Plugin.
- **[ansible.cfg](file:///Users/ado/tmp/git_tbz/hf/stud/devops/musterloesungen-praxisauftraege/tag10/ansible.cfg)**: Ansible-Einstellungen zur Einbindung des AWS-Plugins und SSH-Schlüssels.
- **[playbook.yml](file:///Users/ado/tmp/git_tbz/hf/stud/devops/musterloesungen-praxisauftraege/tag10/playbook.yml)**: Zweistufiges Playbook:
  1. **Schritt 1 (lokal)**: Führt `terraform apply` im Verzeichnis `../tag07` aus, um die Security Group zu aktualisieren und den Terraform State konsistent zu halten.
  2. **Schritt 2 (remote)**: Installiert Docker & Git auf der VM, klont das Repo `m169-scripts` und startet den Monitoring Stack via `docker compose up -d`.

## Voraussetzungen

1. **Terraform, AWS CLI & Boto3**:
   - Terraform muss lokal installiert sein.
   - Python-Pakete & Ansible-Collections:
     ```bash
     pip install boto3 botocore
     ansible-galaxy collection install amazon.aws
     ```

2. **AWS Credentials**:
   ```bash
   export AWS_ACCESS_KEY_ID="DEIN_ACCESS_KEY"
   export AWS_SECRET_ACCESS_KEY="DEIN_SECRET_KEY"
   export AWS_REGION="us-east-1"
   ```

## Durchführung

1. **Dynamisches Inventory testen**:
   ```bash
   ansible-inventory -i aws_ec2.yml --list
   ```

2. **Ansible Playbook ausführen**:
   ```bash
   ansible-playbook playbook.yml
   ```

## Zugriffe nach der Bereitstellung

- **cAdvisor**: `http://<EC2-IP>:8080` (oder `http://<EC2-IP>:8090`)
- **Prometheus**: `http://<EC2-IP>:9090`
- **Grafana**: `http://<EC2-IP>:3000`
