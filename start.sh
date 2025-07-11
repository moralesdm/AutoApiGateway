#!/bin/sh

# Reemplaza las variables de entorno en la plantilla y genera nginx.conf final
envsubst < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf

# Inicia NGINX en primer plano
nginx -g 'daemon off;'
