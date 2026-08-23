# Musterlösung – Übung 2: Container Registry (Image-Push zu AWS ECR)

**Ziel:** Das gebaute Image automatisch in eine Container-Registry (AWS ECR) hochladen.

Workflow: [.github/workflows/aufgabe2.yml](../.github/workflows/aufgabe2.yml)

---

## 1. Vorbereitung in AWS

1. In der AWS-Console unter **ECR** ein Repository anlegen (z. B. `hello-docker-repo`),
   optional „Scan on push" aktivieren.
2. Einen IAM-User mit ECR-Push-Rechten anlegen und dessen Access Keys notieren.

## 2. GitHub-Secrets hinterlegen

*Settings → Secrets and variables → Actions → New repository secret*:

| Secret | Inhalt |
|--------|--------|
| `AWS_ACCESS_KEY_ID` | Access Key ID des IAM-Users |
| `AWS_SECRET_ACCESS_KEY` | zugehöriger Secret Key |
| `AWS_REGION` | z. B. `eu-central-1` |
| `AWS_ACCOUNT_ID` | AWS-Konto-ID |
| `ECR_REPOSITORY` | Name des ECR-Repos, z. B. `hello-docker-repo` |

## 3. Workflow (Kernpunkte)

```yaml
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Login to Amazon ECR
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build, tag, and push to ECR
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.${{ secrets.AWS_REGION }}.amazonaws.com/${{ secrets.ECR_REPOSITORY }}:latest
```

- `configure-aws-credentials` setzt die Zugangsdaten aus den Secrets.
- `amazon-ecr-login` authentifiziert Docker gegen die private Registry.
- `push: true` + vollständige ECR-URL als Tag laden das Image hoch.

## 4. Prüfen

Nach dem Push zeigt der Action-Log `pushed image to …amazonaws.com/hello-docker-repo:latest`.
In der AWS-Console erscheint das Image (Tag `latest`) im ECR-Repository.

## Ergebnis

- CI/CD-Pipeline, die das Image automatisch in eine Cloud-Registry pusht.
- AWS-Zugangsdaten sicher als GitHub-Secrets abgelegt — Basis für das Deployment (Übung 3).
