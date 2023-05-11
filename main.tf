# Creating a network for keycloak and mysql

resource "docker_network" "kcnetwork" {
  name   = "kcnetwork"
  driver = "bridge"
}

#  Custom Image build with credentials for mysql

resource docker_image backendb {
  name = "keycloak_database"
  build {
    context = "./mysql"
  }
}

resource "docker_container" "mysqldb" {
  name         = "mysql-database"
  image        = docker_image.backendb.image_id
  network_mode = docker_network.kcnetwork.name
  ports {
    internal = 3306
    external = 3306
  }
}

#  Custom Image build with credentials for Keycloak

resource "docker_image" "keycloak_image" {
  name = "keycloak_master"
  build{
    context = "./keycloak"
  }
}

resource "docker_container" "keycloak" {
  name = "keycloak_live"
  image = docker_image.keycloak_image.image_id
  network_mode = docker_network.kcnetwork.name
  ports {
    internal = 8080
    external = 8080
  }
  depends_on = [docker_network.kcnetwork, docker_container.mysqldb ]
}
