# Tag 11: Prometheus EC2 Service Discovery (`ec2_sd_configs`)

Diese Musterlösung enthält die Konfiguration für automatisches Discovery von AWS EC2 Instanzen in Prometheus.

## Dateien

- [`prometheus.yml`](prometheus.yml): Prometheus-Konfigurationsdatei mit `ec2_sd_configs` und `relabel_configs`.

## Funktionsweise

Prometheus nutzt die AWS EC2 API, um laufende EC2-Instanzen in der angegebenen Region zu erkennen und automatisch deren Metrics (Standard: Port `9100` / Node Exporter) zu scrapen.

### AWS IAM Berechtigungen

Im **AWS-Learnerlabi** ist es am einfachsten die Rolle `LabRole` der Sonarqube/Prometheus/Grafana Instanz zuzuordnen.

Damit Prometheus EC2-Instanzen abfragen kann, benötigt der ausgeführte Prozess bzw. die IAM-Rolle mindestens folgende Berechtigungen:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeTags"
            ],
            "Resource": "*"
        }
    ]
}
```


### Relabeling Highlight

- **`instance` Label**: Setzt das Tag `Name` der EC2-Instanz als `instance`-Name in Prometheus.
- **Zusätzliche Labels**:
  - `instance_id`: EC2 Instance ID (z.B. `i-0123456789abcdef0`)
  - `availability_zone`: Z.B. `us-east-1a`
  - `instance_type`: Z.B. `t3.micro`
  - `private_ip`: Die private IP-Adresse der Instanz
  - `environment`: Der Wert des AWS Tags `Environment`

## Restart von `monitoring`-Service
Nach den Konfigurationsanpassungen muss der `monitoring`-service  auf der Sonarqube/Prometheus/Grafana-Instanz neu gestartet werden
```
sudo systemctl restart monitoring
```
Prometheus ist anschließend unter `http://localhost:9090` erreichbar. Unter `http://localhost:9090/targets` können die dynamisch erkannten EC2-Ziele eingesehen werden.

