# 🛒 TechMarket - Microservicio "Orders" (EKS & Blue-Green Deployment)
![Version](https://img.shields.io/badge/version-1.0.0--stable-success)
![AWS EKS](https://img.shields.io/badge/AWS-EKS-FF9900?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?logo=github-actions)

Este repositorio contiene la arquitectura, infraestructura y orquestación completa para el microservicio crítico transaccional **Orders** de TechMarket. El proyecto implementa un flujo de entrega continua de nivel empresarial utilizando **Amazon EKS (Kubernetes)** y una estrategia de despliegue **Blue-Green** para garantizar cero tiempo de inactividad (Zero Downtime) y protección financiera total.

---

## 🎯 Resumen Ejecutivo y Arquitectura
El objetivo central es mantener un **SLA del 99.9%** en el procesamiento de ventas. Para lograrlo, la arquitectura se sostiene en tres pilares:
1. **Infraestructura Ágil (IaC):** Aprovisionamiento automatizado de VPC, subredes públicas/privadas y clúster EKS utilizando Terraform.
2. **Estrategia Blue-Green:** Aislamiento de versiones a nivel de *Pods* en Kubernetes. Permite la validación en producción (entorno Green) y un conmutador instantáneo mediante un *LoadBalancer* de AWS.
3. **Pipeline Inteligente (GitFlow):** Integración y Despliegue Continuo (CI/CD) multi-rama gestionado por GitHub Actions.

---

## 📂 Estructura del Proyecto

```text
📦 ev2ciclovida_lslv
 ┣ 📂 .github
 ┃ ┗ 📂 workflows
 ┃   ┗ 📜 deploy.yml        # Pipeline CI/CD multi-rama (dev/main)
 ┣ 📂 k8s
 ┃ ┣ 📜 deployment.yaml   # Manifiestos de Pods (Entornos Blue y Green)
 ┃ ┗ 📜 service.yaml      # Interruptor de tráfico (LoadBalancer público)
 ┣ 📜 main.tf             # Infraestructura como Código (AWS + Terraform)
 ┣ 📜 server.js           # Lógica de la API Transaccional (Node.js)
 ┣ 📜 Dockerfile          # Imagen optimizada (Node Alpine)
 ┗ 📜 README.md           # Documentación oficial del proyecto
