#!/bin/sh

# Generar nginx.conf a partir de la plantilla y variables de entorno
envsubst '\
$SERVICE1_HOST $SERVICE1_PORT \
$SERVICE2_HOST $SERVICE2_PORT \
$SERVICE3_HOST $SERVICE3_PORT \
$SERVICE4_HOST $SERVICE4_PORT' \
< /etc/nginx/default.template.conf > /etc/nginx/nginx.conf

# Ejecutar NGINX en primer plano
nginx -g 'daemon off;'
