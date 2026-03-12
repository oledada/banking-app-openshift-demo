# Création du namespace (idempotent)
resource "kubernetes_namespace" "banking" {
  metadata {
    name = var.namespace
  }
}

# ------------------------------------------------------
#  PostgreSQL via Helm (Bitnami chart)
# ------------------------------------------------------
resource "helm_release" "postgres" {
  name       = "bank-db"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = var.postgres_chart_version
  namespace  = kubernetes_namespace.banking.metadata[0].name

  values = [
    file("${path.module}/../helm/postgres-values.yaml")   # si tu as un fichier values séparé
  ]

  set {
    name  = "auth.enablePostgresUser"
    value = "true"
  }
  set_sensitive {
    name  = "auth.postgresPassword"
    value = var.postgres_password
  }
  set {
    name  = "auth.username"
    value = var.app_db_user
  }
  set {
    name  = "auth.database"
    value = var.app_db_name
  }
  set {
    name  = "primary.persistence.size"
    value = "8Gi"
  }
  set {
    name  = "primary.resources.requests.cpu"
    value = "300m"
  }
  set {
    name  = "primary.resources.requests.memory"
    value = "512Mi"
  }

  depends_on = [kubernetes_namespace.banking]
}

# ------------------------------------------------------
#  Backend Spring Boot via ton chart Helm local
# ------------------------------------------------------
resource "helm_release" "backend" {
  name      = "banking-backend"
  chart     = var.backend_chart_path
  namespace = kubernetes_namespace.banking.metadata[0].name

  values = [
    yamlencode({
      image = {
        repository = var.backend_image_repository
        tag        = var.backend_image_tag
      }
      env = {
        SPRING_DATASOURCE_URL      = "jdbc:postgresql://bank-db-postgresql.${var.namespace}.svc.cluster.local:5432/${var.app_db_name}"
        SPRING_DATASOURCE_USERNAME = var.app_db_user
      }
    })
  ]

  set_sensitive {
    name  = "env.SPRING_DATASOURCE_PASSWORD"
    value = var.postgres_password   # même mot de passe pour simplicité (à séparer en prod)
  }

  depends_on = [
    helm_release.postgres,
    kubernetes_namespace.banking
  ]
}
# Route OpenShift pour le backend
resource "kubernetes_manifest" "backend_route" {
  manifest = {
    apiVersion = "route.openshift.io/v1"
    kind       = "Route"
    metadata = {
      name      = "${helm_release.backend.name}-backend"
      namespace = var.namespace
      labels = {
        app     = "banking-backend"
        release = helm_release.backend.name
      }
    }
    spec = {
      host = var.backend_route_host != "" ? var.backend_route_host : null   # null = auto-généré par OpenShift
      to = {
        kind = "Service"
        name = "${helm_release.backend.name}-backend"
      }
      port = {
        targetPort = "http"
      }
      tls = {
        termination                   = "edge"
        insecureEdgeTerminationPolicy = "Redirect"
      }
      wildcardPolicy = "None"
    }
  }

  depends_on = [helm_release.backend]
}
