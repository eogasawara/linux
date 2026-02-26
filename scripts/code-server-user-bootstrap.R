# Configura code-server e preferencias do RStudio por usuario.
get_public_host <- function() {
  return("<HOST_FQDN>")
}

create_rprofile <- function(login) {
  filename <- sprintf("/home/%s/.Rprofile", login)
  fileConn<-file(filename)
  writeLines(c("options(save.defaults=list(compressed=TRUE))",
               "options(save.image.defaults=list(compressed=TRUE))"), fileConn)
  close(fileConn)
  cmd <- system2("chown", args = c("-R",sprintf("%s:%s", login, login), sprintf("/home/%s/.Rprofile", login)), stdout = TRUE, stderr = TRUE)
}

create_config_file <- function(login, id) {
  filename <- sprintf("/home/%s/.config/code-server", login)
  cmd <- system2("rm", args=c(sprintf("%s/config.yaml", filename)), stdout = TRUE, stderr = TRUE)
  fileConn<-file(sprintf("%s/config.yaml", filename))
  writeLines(c(sprintf("bind-addr: 127.0.0.1:%d", id),
               "auth: none",
               "cert: false"), fileConn)
  close(fileConn)
}

create_apache_users_map <- function(entries) {
  filename <- "/etc/apache2/code-server-users.map"
  fileConn <- file(filename)
  if (length(entries) > 0) {
    writeLines(entries, fileConn)
  }
  close(fileConn)
  cmd <- system2("chown", args = c("root:root", filename), stdout = TRUE, stderr = TRUE)
  cmd <- system2("chmod", args = c("644", filename), stdout = TRUE, stderr = TRUE)
}

enable_code_server_service <- function(login) {
  unit <- sprintf("code-server@%s", login)
  cmd <- system2("systemctl", args = c("enable", "--now", unit), stdout = TRUE, stderr = TRUE)
}

create_readme_proxy <- function(login, id) {
  host_fqdn <- get_public_host()
  filename <- sprintf("/home/%s/readme-proxy.txt", login)
  cmd <- system2("rm", args=c(filename), stdout = TRUE, stderr = TRUE)
  fileConn<-file(filename)
  writeLines(c(sprintf("ssh -p <PORTA_SSH> -L %d:127.0.0.1:%d %s@%s", id, id, login, host_fqdn),
               "#estabele o tunel entre tua maquina e o servidor na porta indicada",
               sprintf("#uma vez logado, basta configurar o proxy no Firefox para 127.0.0.1 porta %d", id)), fileConn)
  close(fileConn)
  cmd <- system2("chown", args = c("-R",sprintf("%s:%s", login, login), filename), stdout = TRUE, stderr = TRUE)
}

create_readme_code_server <- function(login, id) {
  host_fqdn <- get_public_host()
  filename <- sprintf("/home/%s/readme-code-server.txt", login)
  cmd <- system2("rm", args=c(filename), stdout = TRUE, stderr = TRUE)
  fileConn<-file(filename)
  writeLines(c(sprintf("url publica: https://%s/code/", host_fqdn),
               "#login no Apache com usuario/senha Linux (PAM)",
               "#opcional: acesso local por tunel SSH",
               sprintf("ssh -p <PORTA_SSH> -L %d:127.0.0.1:%d %s@%s", id, id, login, host_fqdn)), fileConn)
  close(fileConn)
  cmd <- system2("chown", args = c("-R",sprintf("%s:%s", login, login), filename), stdout = TRUE, stderr = TRUE)
}

create_readme_jupyter <- function(login, id) {
  host_fqdn <- get_public_host()
  filename <- sprintf("/home/%s/readme-jupyter.txt", login)
  cmd <- system2("rm", args=c(filename), stdout = TRUE, stderr = TRUE)
  fileConn<-file(filename)
  writeLines(c(sprintf("ssh -p <PORTA_SSH> -L %d:127.0.0.1:%d %s@%s", id, id, login, host_fqdn),
               "#estabele o tunel entre tua maquina e o servidor na porta indicada",
               sprintf("#uma vez logado, basta rodar jupyter notebook --port %d, obter a url produzida e acessa-lo pelo browser", id)), fileConn)
  close(fileConn)
  cmd <- system2("chown", args = c("-R",sprintf("%s:%s", login, login), filename), stdout = TRUE, stderr = TRUE)
}

setup_rstudio <- function(login) {
  library(jsonlite)
  if (!dir.exists(sprintf("/home/%s/.config/rstudio", login))) {
    cmd <- system2("mkdir", args = c(sprintf("/home/%s/.config/rstudio", login)), stdout = TRUE, stderr = TRUE)
  }
  filename <- sprintf("/home/%s/.config/rstudio/rstudio-prefs.json", login)
  
  json_result <- list()
  result <- tryCatch(
    {    
      if (file.exists(filename))
        json_result <- jsonlite::fromJSON(filename, simplifyDataFrame = FALSE)
    },
    error=function(cond) {
      message(cond) # Choose a return value in case of error
      json_result <- list()
      return(NULL)
    }
  ) 
  
  library(reticulate)
  py <- py_discover_config()
  
  modify <- FALSE
  if (is.null(json_result$python_type)) {
    json_result$python_type <- "system"
    modify <- TRUE  
  }
  if (is.null(json_result$python_version)){
    r <- strsplit(py$version_string, " ")
    json_result$python_version <- r[[1]][1]
    #json_result$python_version <- "3.8.10"
    modify <- TRUE  
  }
  if (is.null(json_result$python_path)){
    #json_result$python_path <- "/usr/bin/python3.8"
    json_result$python_path <- py$executable
    modify <- TRUE  
  }
  if (modify) {
    json <- jsonlite::toJSON(json_result, pretty=TRUE, auto_unbox = TRUE)
    write(json, filename)
  }
}

folders <- list.dirs(path = "/home", full.names = FALSE, recursive = FALSE)
users_map_entries <- c()
for (login in folders) {
  id <- as.integer(system2("id", args = c("-u", login), stdout = TRUE, stderr = TRUE))
  if (!is.na(id)) {
    result <- tryCatch(
      {    
        if (!dir.exists(sprintf("/home/%s/.config", login)))
          cmd <- system2("mkdir", args = c(sprintf("/home/%s/.config", login)), stdout = TRUE, stderr = TRUE)
        if (!dir.exists(sprintf("/home/%s/.config/code-server", login)))
          cmd <- system2("mkdir", args = c(sprintf("/home/%s/.config/code-server", login)), stdout = TRUE, stderr = TRUE)
        port <- id + 8001
        create_config_file(login, port)
        create_readme_code_server(login, port) 
        create_readme_jupyter(login, id+9000) 
        create_readme_proxy(login, 31280)
        users_map_entries <<- c(users_map_entries, sprintf("%s %d", login, port))
        enable_code_server_service(login)
      },
      error=function(cond) {
        message(cond) 
        return(NULL)
      }
    ) 

    result <- tryCatch(
      {    
        setup_rstudio(login)
      },
      error=function(cond) {
        message(cond) 
        return(NULL)
      }
    ) 
    result <- tryCatch(
      {    
        create_rprofile(login)
      },
      error=function(cond) {
        message(cond) 
        return(NULL)
      }
    ) 

    result <- tryCatch(
      {    
        cmd <- system2("chown", args = c("-R",sprintf("%s:%s", login, login), sprintf("/home/%s/.config", login)), stdout = TRUE, stderr = TRUE)
      },
      error=function(cond) {
        message(cond) 
        return(NULL)
      }
    ) 
  }
}

result <- tryCatch(
  {
    create_apache_users_map(users_map_entries)
  },
  error=function(cond) {
    message(cond)
    return(NULL)
  }
)
