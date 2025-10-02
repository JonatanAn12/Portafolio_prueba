# Usar nginx como imagen base
FROM nginx:alpine

# Copiar configuración personalizada de nginx primero
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar solo los archivos web necesarios
COPY index.html /usr/share/nginx/html/
COPY estilos.css /usr/share/nginx/html/
COPY img/ /usr/share/nginx/html/img/

# Exponer puerto 80
EXPOSE 80

# Nginx se ejecuta automáticamente
CMD ["nginx", "-g", "daemon off;"]