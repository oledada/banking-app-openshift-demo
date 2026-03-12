variable "kube_context" {
  description = "Nom du contexte kubectl à utiliser pour se connecter au cluster OpenShift"
  type        = string
  default     = "default/api-fr01-openshift-example-com:6443/admin"
}

variable "namespace" {
  description = "Namespace OpenShift où déployer l'application"
  type        = string
  default     = "banking-app"
}

variable "postgres_chart_version" {
  description = "Version du chart Bitnami PostgreSQL à installer"
  type        = string
  default     = "15.5.21"   # vérifie la version actuelle sur artifacthub.io/charts/bitnami/postgresql
}

variable "backend_chart_path" {
  description = "Chemin local vers le chart Helm du backend (relatif au terraform/)"
  type        = string
  default     = "../helm/banking-app"
}

variable "backend_image_repository" {
  description = "Repository de l'image du backend"
  type        = string
  default     = "quay.io/ton-compte/banking-backend"
}

variable "backend_image_tag" {
  description = "Tag de l'image du backend"
  type        = string
  default     = "latest"
}

variable "postgres_password" {
  description = "Mot de passe PostgreSQL admin (à sécuriser via tfvars ou vault)"
  type        = string
  sensitive   = true
}

variable "app_db_user" {
  description = "Utilisateur applicatif PostgreSQL"
  type        = string
  default     = "bankuser"
}

variable "app_db_name" {
  description = "Nom de la base de données applicative"
  type        = string
  default     = "bankdb"
}
variable "backend_route_host" {
  description = "Hostname personnalisé pour la Route backend (vide = auto-généré par OpenShift)"
  type        = string
  default     = ""
}
