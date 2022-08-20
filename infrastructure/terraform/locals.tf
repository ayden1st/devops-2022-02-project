locals {
  kubeconfig = <<-EOT
  apiVersion: v1
  clusters:
  - cluster:
      server: ${yandex_kubernetes_cluster.project_k8s.master[0].external_v4_endpoint}
      certificate-authority-data: ${base64encode(yandex_kubernetes_cluster.project_k8s.master[0].cluster_ca_certificate)}
    name: yc-managed-k8s-${yandex_kubernetes_cluster.project_k8s.id}
  contexts:
  - context:
      cluster: yc-managed-k8s-${yandex_kubernetes_cluster.project_k8s.id}
      user: yc-managed-k8s-${yandex_kubernetes_cluster.project_k8s.id}
    name: ${yandex_kubernetes_cluster.project_k8s.name}
  current-context: ${yandex_kubernetes_cluster.project_k8s.name}
  kind: Config
  preferences: {}
  users:
  - name: yc-managed-k8s-${yandex_kubernetes_cluster.project_k8s.id}
    user:
      exec:
        apiVersion: client.authentication.k8s.io/v1beta1
        args:
        - k8s
        - create-token
        - --profile=default
        command: yc
        env: null
        provideClusterInfo: false
  EOT
}
