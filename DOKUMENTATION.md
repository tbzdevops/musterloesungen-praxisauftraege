# Container-Pipeline — Tag 14 Praxis

Dokumentation der dreistufigen Pipeline: **CI-Build** (Übung 1), **Push zu AWS ECR** (Übung 2)
und **Deployment auf AWS ECS** (Übung 3). Die ausführlichen Musterlösungen stehen in
[tag14/](tag14/).

## Übung 1 — Automatisierter Build

[`.github/workflows/aufgabe1.yml`](.github/workflows/aufgabe1.yml) baut bei jedem Push auf `main`
das Container-Image aus dem [Dockerfile](Dockerfile) und testet es sofort: Der Container wird
gestartet und per `curl` gegen Port 8080 geprüft, ob die Flask-App mit `Hello, World!` antwortet.
Wichtig ist `load: true` in der `docker/build-push-action` — ohne diesen Schalter landet das Image
nur im Buildx-Cache und `docker run` findet es nicht.

## Übung 2 — Container Registry (ECR)

[`.github/workflows/aufgabe2.yml`](.github/workflows/aufgabe2.yml) meldet sich mit
`aws-actions/configure-aws-credentials` und `aws-actions/amazon-ecr-login` an der Registry an und
pusht das Image (`push: true`). Die Zugangsdaten liegen als Repository-Secrets vor:
`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `AWS_ACCOUNT_ID` und
`ECR_REPOSITORY` — nie im Code.

## Übung 3 — Continuous Deployment (ECS)

[`.github/workflows/aufgabe3.yml`](.github/workflows/aufgabe3.yml) baut und pusht das Image mit
dem Commit-SHA als Tag, lädt die aktuelle ECS-Task-Definition, ersetzt darin die Image-URI und
deployt sie mit `amazon-ecs-deploy-task-definition`. `wait-for-service-stability: true` sorgt
dafür, dass der Workflow erst grün wird, wenn der Service tatsächlich stabil läuft.

## Erkenntnis

Die drei Workflows bilden die vollständige Kette **Build → Registry → Deployment** ab. Der
unveränderliche Image-Tag (Commit-SHA) macht jedes Deployment nachvollziehbar und ein Rollback zu
einer früheren Version möglich. Übung 2 und 3 brauchen ein AWS-Konto mit ECR-Repository und
ECS-Cluster; ohne die Secrets laufen sie nicht an.
