# Musterlösung – Übung 3: Continuous Deployment auf AWS ECS

**Ziel:** Nach dem Image-Push automatisch den ECS-Service aktualisieren — durchgängig vom
Code-Push bis zum laufenden Container in der Cloud.

Workflow-Vorlage: [uebung01-ci-build/.github/workflows/aufgabe3.yml](uebung01-ci-build/.github/workflows/aufgabe3.yml)

---

## 1. Zusätzliche Voraussetzungen

- Abschluss von Übung 2 (ECR ist gefüllt, AWS-Secrets vorhanden).
- Ein ECS-Cluster mit Service und Task-Definition, der das Image ausführt.
- Zusätzliche Secrets: `ECS_CLUSTER`, `ECS_SERVICE`, `ECS_TASK_DEFINITION` (Familienname),
  `CONTAINER_NAME`.

## 2. Ablauf des Workflows

Der Deploy-Workflow erweitert die Pipeline um den CD-Teil:

1. **AWS-Login + ECR-Login** (wie Übung 2).
2. **Build & Push** des Images mit dem Commit-SHA als eindeutigem Tag (`${{ github.sha }}`) —
   so ist jede Version klar identifizierbar (besser als immer nur `latest`).
3. **Task-Definition holen** (`aws ecs describe-task-definition`).
4. **Neues Image eintragen** mit `aws-actions/amazon-ecs-render-task-definition`.
5. **Deploy** mit `aws-actions/amazon-ecs-deploy-task-definition`
   (`wait-for-service-stability: true` wartet, bis der neue Task stabil läuft).

```yaml
      - name: Deploy to Amazon ECS service
        uses: aws-actions/amazon-ecs-deploy-task-definition@v2
        with:
          task-definition: ${{ steps.task-def.outputs.task-definition }}
          service: ${{ secrets.ECS_SERVICE }}
          cluster: ${{ secrets.ECS_CLUSTER }}
          wait-for-service-stability: true
```

## 3. Prüfen

1. Antworttext in `app.py` minimal ändern und pushen.
2. Die Pipeline baut/pusht das neue Image und aktualisiert ECS.
3. Nach dem Rollout zeigt der Endpoint den geänderten Text — das Deployment war erfolgreich.

> Referenz-Musterlösung des Kurses:
> <https://github.com/tbzdevops/tag15-aws-container/tree/main/.github/workflows>

## Ergebnis

- Durchgängige CI/CD-Pipeline: **Code push → Image bauen → nach ECR pushen → ECS aktualisieren**.
- Eindeutige Image-Tags per Commit-SHA statt nur `latest`.
- Die Kernprinzipien der Container-Automatisierung mit GitHub Actions sitzen.
