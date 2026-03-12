output "namespace_name" {
  description = "Nom du namespace créé"
  value       = kubernetes_namespace.banking.metadata[0].name
}

output "postgres_release_name" {
  description = "Nom de la release Helm PostgreSQL"
  value       = helm_release.postgres.name
}

output "postgres_service_name" {
  description = "Nom du service PostgreSQL créé par le chart Bitnami"
  value       = "bank-db-postgresql"
}

output "backend_release_name" {
  description = "Nom de la release Helm du backend"
  value       = helm_release.backend.name
}

output "backend_service_dns" {
  description = "Nom DNS interne du service backend (à utiliser dans le frontend)"
  value       = "${helm_release.backend.name}-backend.${var.namespace}.svc.cluster.local"
}

output "connection_string_example" {
  description = "Exemple de chaîne de connexion JDBC pour le backend"
  value       = "jdbc:postgresql://bank-db-postgresql.${var.namespace}.svc.cluster.local:5432/${var.app_db_name}"
  sensitive   = false
}
output "backend_route_url" {
  description = "URL de la Route backend OpenShift"
  value       = "https://${try(kubernetes_manifest.backend_route.manifest.spec.host, "non-défini-encore")}"
}
