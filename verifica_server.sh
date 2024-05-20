#!/bin/bash

# Realiza la solicitud POST
response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "username=dario&password=hola123" https://paneleslanding.com/login_test)

# Obtiene la marca de tiempo
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Verifica si la respuesta es un código de error (por ejemplo, 4xx o 5xx)
if [ $response -ge 400 ]; then
  # Ejecuta el comando pm2 restart server
  pm2 restart server
  pm2 restart server_socket
  
  error_message="La solicitud POST devolvió un código de error $response"
  
  # Imprime el mensaje con la marca de tiempo en la consola
  # echo "$timestamp, $error_message"
  
  # Guarda el mensaje con la marca de tiempo en el archivo de registro
  echo "$timestamp, $error_message" >> verifica_server_nodejs_log.txt

fi