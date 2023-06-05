terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}


provider "kubernetes" {
  config_path = "~/.kube/lke-tf"
}



resource "kubernetes_deployment" "lke-tf-jenkins" {
  metadata {
    name = "lke-tf-poc"
    labels = {
      test = "lke-tf"
      app  = "lke-tf"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "lke-tf"
      }
    }

    template {
      metadata {
        labels = {
          app = "lke-tf"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "lke-tf"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "lke-tf" {
  metadata {
    name = "lke-tf-jenkins"
    labels = {
      test = "lke-tf-jenkins"
      app  = "lke-tf-jenkins"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.lke-tf.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port = 80
    }
  }
}

# resource "linode_domain" "exampleDomain" {
#   domain    = "splitfare.io"
#   soa_email = "gabrielmermelstein@gmail.com"
#   type      = "master"
# }

# resource "linode_domain_record" "exampleDomainRec" {
#   domain_id   = linode_domain.exampleDomain.id
#   name        = "www.splitfare.io"
#   record_type = "A"
#   target      = kubernetes_service.CBC.ip_address
#   ttl_sec     = 300
# }

