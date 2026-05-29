# 🛒 TechMarket - Microservicio "Orders" (Blue-Green Deployment)
**Versión:** `v0.2.0`

Este repositorio contiene la implementación de la infraestructura y el pipeline CI/CD para el microservicio crítico transaccional **Orders**. El proyecto está diseñado bajo una arquitectura de alta disponibilidad en AWS, utilizando **Amazon EKS (Kubernetes)** y automatización mediante **GitHub Actions** para lograr despliegues con cero tiempo de inactividad (Zero Downtime).

---

## 🎯 Objetivo Arquitectónico
Garantizar un **SLA del 99.9%** y resiliencia ante fallos en el procesamiento de órdenes de compra. Se emplea una estrategia de **Blue-Green Deployment** gestionada a nivel de clúster Kubernetes, permitiendo:
1. Pruebas seguras en el entorno *Green* antes de liberar a producción.
2. Cambio de tráfico instantáneo mediante un Balanceador de Carga (AWS ALB).
3. Capacidad de *Rollback* inmediato (en milisegundos) ante cualquier anomalía.

---

## 🛠️ Tecnologías Utilizadas
* **Lenguaje:** Node.js / Express (API REST)
* **Contenedores:** Docker & Amazon ECR
* **Orquestación:** Kubernetes (Amazon EKS)
* **Infraestructura como Código (IaC):** Terraform
* **CI/CD:** GitHub Actions

---

## 📂 Estructura del Proyecto v0.2.0
```text
📦 ev2ciclovida_lslv
 ┣ 📂 .github
 ┃ ┗ 📂 workflows
 ┃   ┗ 📜 deploy.yml        (El pipeline CI/CD para EKS)
 ┣ 📂 k8s
 ┃ ┣ 📜 deployment.yaml   (Los Pods para Blue y Green)
 ┃ ┗ 📜 service.yaml      (El interruptor del LoadBalancer)
 ┣ 📜 main.tf             (La infraestructura Terraform)
 ┣ 📜 server.js           (Tu API Node.js)
 ┣ 📜 Dockerfile          (La imagen optimizada en Alpine)
 ┗ 📜 README.md           (La documentación profesional)
