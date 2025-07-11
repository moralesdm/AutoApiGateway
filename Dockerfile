FROM nginx:latest

# Copiamos el archivo de configuración plantilla y script
COPY nginx.template.conf /etc/nginx/nginx.template.conf
COPY start.sh /start.sh

# Establecemos el punto de entrada
CMD ["/start.sh"]
