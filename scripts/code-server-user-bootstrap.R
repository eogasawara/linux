# Configura code-server e preferencias do RStudio por usuario.
get_hostname <- function(){ 
  return(as.character(Sys.info()["nodename"])) 
} 

create_rprofile <- function(login) {
  filename <- sprintf("/home/%s/.Rprofile", login)
  fileConn<-file(filename)
  writeLines(c("options(save.defaults=list(compressed=TRUE))",
               "options(save.image.defaults=list(compressed=TRUE))"), fileConn)
  close(fileConn)
  cmd <- system2("chown", args = c("-R",sprintf("%s:%s", login, login), sprintf("/home/%s/.Rprofile", login)), stdout = TRUE, stderr = TRUE)
}

create_config_file <- function(login, password, id) {
  filename <- sprintf("/home/%s/.config/code-server", login)
  cmd <- system2("rm", args=c(sprintf("%s/config.yaml", filename)), stdout = TRUE, stderr = TRUE)
  fileConn<-file(sprintf("%s/config.yaml", filename))
  writeLines(c(sprintf("bind-addr: 127.0.0.1:%d", id),
               "auth: password", 
               sprintf("password: %s", password), 
               "cert: false",
               sprintf("base-path: /code/%s", login)), fileConn)
  close(fileConn)
}

create_readme_file <- function(login, password, id) {
  hostname <- get_hostname()
  filename <- sprintf("/home/%s/readme-code-server.txt", login)
  cmd <- system2("rm", args=c(filename), stdout = TRUE, stderr = TRUE)
  fileConn<-file(filename)
  writeLines(c(sprintf("url publica: https://%s.instituicao.exemplo/code/%s/", hostname, login),
               sprintf("code-server password: %s", password),
               "#opcional: acesso local por tunel SSH",
               sprintf("ssh -L %d:127.0.0.1:%d %s@%s.instituicao.exemplo", id, id, login, hostname)), fileConn)
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
  
  modify <- FALSE
  if (is.null(json_result$python_type)) {
    json_result$python_type <- "system"
    modify <- TRUE  
  }
  if (is.null(json_result$python_version)){
    json_result$python_version <- "3.8.10"
    modify <- TRUE  
  }
  if (is.null(json_result$python_path)){
    json_result$python_path <- "/usr/bin/python3.8"
    modify <- TRUE  
  }
  if (modify) {
    json <- jsonlite::toJSON(json_result, pretty=TRUE, auto_unbox = TRUE)
    write(json, filename)
  }
}

folders <- list.dirs(path = "/home", full.names = FALSE, recursive = FALSE)
folders <- sort(folders)
port_base <- 8081
idx <- 0
for (login in folders) {
  id <- as.integer(system2("id", args = c("-u", login), stdout = TRUE, stderr = TRUE))
  if (!is.na(id)) {
    result <- tryCatch(
      {    
        if (!dir.exists(sprintf("/home/%s/.config", login)))
          cmd <- system2("mkdir", args = c(sprintf("/home/%s/.config", login)), stdout = TRUE, stderr = TRUE)
        if (!dir.exists(sprintf("/home/%s/.config/code-server", login)))
          cmd <- system2("mkdir", args = c(sprintf("/home/%s/.config/code-server", login)), stdout = TRUE, stderr = TRUE)
        password <- "<PASSWORD>"
        port <- port_base + idx
        create_config_file(login, password, port)
        create_readme_file(login, password, port)
        idx <- idx + 1
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
