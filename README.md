# Curriculum Dockerizado con Nginx

Este proyecto dockeriza un curriculum personal usando Nginx como servidor web y proxy reverso.

## Estructura del Proyecto

```
Portafolio_prueba/
├── Dockerfile          # Configuración de Docker
├── nginx.conf          # Configuración personalizada de Nginx
├── index.html          # Página principal del curriculum
├── estilos.css         # Estilos CSS
├── img/                # Imágenes del portfolio
└── README.md           # Esta documentación
```

## Archivos de Configuración

### Dockerfile
```dockerfile
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
```

### nginx.conf
```nginx
server {
    listen 80;
    server_name localhost;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    
    # Configuración para archivos estáticos
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        root /usr/share/nginx/html;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## Comandos para Ejecutar

### Construcción y Ejecución
```bash
# Construir la imagen
docker build -t curriculum-portfolio .

# Ejecutar el contenedor
docker run -d -p 8080:80 --name curriculum-portfolio curriculum-portfolio

# Acceder al curriculum
# http://localhost:8080
```

### Gestión del Contenedor
```bash
# Ver contenedores activos
docker ps

# Ver logs
docker logs curriculum-portfolio

# Parar el contenedor
docker stop curriculum-portfolio

# Eliminar el contenedor
docker rm curriculum-portfolio

# Reconstruir (si hay cambios)
docker stop curriculum-portfolio
docker rm curriculum-portfolio
docker build --no-cache -t curriculum-portfolio .
docker run -d -p 8080:80 --name curriculum-portfolio curriculum-portfolio
```

## Características

- ✅ Servidor web Nginx optimizado
- ✅ Configuración de cache para archivos estáticos
- ✅ Imagen ligera basada en Alpine Linux
- ✅ Puerto 8080 expuesto para acceso local
- ✅ Configuración de proxy reverso

## Solución de Problemas

### Error 404 en archivos CSS/imágenes
Si los archivos estáticos no cargan:
1. Verificar que los archivos estén en el contenedor:
   ```bash
   docker exec curriculum-portfolio ls -la /usr/share/nginx/html/
   ```
2. Reconstruir la imagen sin cache:
   ```bash
   docker build --no-cache -t curriculum-portfolio .
   ```

### Verificar configuración de Nginx
```bash
docker exec curriculum-portfolio cat /etc/nginx/conf.d/default.conf
```

## Tecnologías Utilizadas

- **Docker**: Containerización
- **Nginx**: Servidor web y proxy reverso
- **HTML/CSS**: Frontend del curriculum
- **Alpine Linux**: Sistema operativo base ligero

## Autor

Jonatan Andres Sanchez Ayala