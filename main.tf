# ==========================================
# 1. PROVEEDOR Y ROL DE LABORATORIO
# ==========================================
provider "aws" {
  region = "us-east-1"
}

# Usamos el LabRole preexistente de AWS Academy para evitar el error de IAM
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "aws_availability_zones" "available" {}

# ==========================================
# 2. RED (VPC, Subredes Públicas y Privadas)
# ==========================================
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "techmarket-eks-vpc" }
}

# Internet Gateway para la salida a Internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = { Name = "techmarket-igw" }
}

# Subredes Públicas (Aquí vivirá el Balanceador de Carga)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name                     = "public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1" # Etiqueta clave para que EKS ponga el ALB aquí
  }
}

# Subredes Privadas (Aquí vivirán los Nodos de EKS)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name                              = "private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# NAT Gateway (Para que los nodos privados tengan internet para descargar imágenes)
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

# Tablas de Ruteo
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ==========================================
# 3. AMAZON ECR (Repositorio de imágenes)
# ==========================================
resource "aws_ecr_repository" "orders_api" {
  name                 = "orders-api"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

# ==========================================
# 4. CLÚSTER EKS Y GRUPO DE NODOS
# ==========================================
resource "aws_eks_cluster" "techmarket_cluster" {
  name     = "techmarket-eks-cluster"
  role_arn = data.aws_iam_role.lab_role.arn # Usamos el LabRole

  vpc_config {
    # El clúster se conecta tanto a redes públicas como privadas
    subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
  }
}

resource "aws_eks_node_group" "techmarket_nodes" {
  cluster_name    = aws_eks_cluster.techmarket_cluster.name
  node_group_name = "techmarket-node-group"
  node_role_arn   = data.aws_iam_role.lab_role.arn # Usamos el LabRole
  
  # Los nodos van en subredes privadas
  subnet_ids      = aws_subnet.private[*].id

  instance_types = ["t3.medium"] # Tamaño permitido en laboratorios

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.techmarket_cluster
  ]
}

# ==========================================
# OUTPUTS
# ==========================================
output "eks_cluster_name" {
  value = aws_eks_cluster.techmarket_cluster.name
}

output "comando_configurar_kubectl" {
  description = "Ejecuta esto en tu terminal para conectar tu PC al clúster"
  value       = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.techmarket_cluster.name}"
}