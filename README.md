# DevSecOps Automation Project

Projet étudiant orienté **infrastructure sécurisée**, **hardening système** et **pipeline CI/CD de sécurité** sur AWS.

## Objectif

Construire une architecture cloud simple mais solide, puis automatiser :
- le provisioning avec Terraform,
- le hardening des machines avec Ansible (inspiré CIS Level 1),
- la vérification sécurité continue dans GitHub Actions.

Ce projet est pensé comme une base réaliste pour montrer une approche DevSecOps de bout en bout.

## Architecture mise en place

- `1 VPC` avec segmentation réseau :
  - `1 subnet public` (bastion SSH),
  - `1 subnet privé` (accès indirect via bastion).
- `Internet Gateway` + table de routage publique.
- `Bastion EC2` (`t3.micro`) protégé par Security Group :
  - SSH entrant limité à `my_ip`,
  - sorties limitées à HTTP/HTTPS.

## Sécurisation de l'infrastructure

- **Terraform state sécurisé** :
  - bucket S3 dédié,
  - versioning activé,
  - chiffrement serveur `AES256`,
  - blocage accès public.
- **Verrouillage Terraform** :
  - table DynamoDB (`terraform-lock`) pour éviter les conflits entre deux personnes.
- **Journalisation AWS** :
  - CloudTrail activé avec export des logs vers S3 dédié,
  - bucket CloudTrail chiffré et non public.

## Hardening système avec Ansible

Playbook `ansible/playbooks/hardening.yml` :
- durcissement SSH (root login off, password auth off, algorithmes forts),
- `fail2ban` activé,
- `auditd` activé + règles d'audit,
- suppression de services non sécurisés (`telnet`, `rsh`),
- pare-feu UFW (deny incoming, allow only SSH),
- durcissement kernel via `sysctl`,
- permissions renforcées sur fichiers sensibles (`/etc/shadow`, `/etc/gshadow`),
- bannière légale SSH.

## Pipeline CI/CD (GitHub Actions)

## Workflow Git

- Développement sur la branche `dev`.
- À chaque push sur `dev`, la pipeline CI sécurité s'exécute.
- Quand la pipeline est verte, ouverture d'une Pull Request vers `main`.
- Le merge dans `main` déclenche le workflow CD (`terraform plan`).

Ce workflow permet de garder une branche de production propre et contrôlée.

## Pipeline CI/CD (GitHub Actions)

### CI sécurité (`.github/workflows/ci-security.yml`)

Sur `dev` et PR vers `main` :
- `terraform fmt -check`,
- `terraform init -backend=false`,
- `terraform validate`,
- scan IaC avec **Trivy**,
- scan Terraform avec **Checkov**,
- `ansible-lint` sur le playbook de hardening.

### CD (`.github/workflows/cd-deploy.yml`)

Sur `main` :
- configuration credentials AWS via secrets GitHub,
- `terraform init`,
- `terraform plan`.

## Choix techniques et compromis

- Infrastructure volontairement minimaliste (ressources limitées).
- Chiffrement S3 en `AES256` (SSE-S3) pour rester dans un budget simple et pas KMS.
- Certaines règles de scanners (Checkov/Trivy) sont strictes type entreprise ; elles servent de guide pour prioriser les vrais risques selon le contexte.

## ELK / Kibana : statut

Initialement prévu :
- centraliser CloudTrail + logs réseau,
- corréler les événements de sécurité,
- visualiser des dashboards de détection dans Kibana.

Décision actuelle :
- **ELK/Kibana mis en pause** pour contrainte de ressources machine (PC local) et budget ( plus de crrédits AWS).


## Résultat

Ce projet démontre une démarche DevSecOps complète :
- **concevoir** une infra segmentée,
- **durcir** les hôtes,
- **contrôler** la sécurité en CI/CD,
- **documenter** les compromis sécurité/coût de manière professionnelle.