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

## Gestión de Usuarios y Seguridad

### Acceso como Root al Contenedor
```bash
# Acceder como root (por defecto)
docker exec -it curriculum-portfolio sh

# Verificar usuario actual
whoami

# Ver usuarios del sistema
cat /etc/passwd
```

### Crear Usuario No Privilegiado (Recomendado)
Para mayor seguridad, puedes modificar el Dockerfile:

```dockerfile
# Agregar después de FROM nginx:alpine
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser

# Cambiar permisos de archivos
RUN chown -R appuser:appuser /usr/share/nginx/html

# Cambiar a usuario no privilegiado
USER appuser
```

### Comandos de Administración en el Contenedor
```bash
# Instalar paquetes (como root)
docker exec -u root curriculum-portfolio apk add --no-cache nano

# Ejecutar comandos como usuario específico
docker exec -u appuser curriculum-portfolio whoami

# Ver procesos en el contenedor
docker exec curriculum-portfolio ps aux

# Ver uso de recursos
docker stats curriculum-portfolio
```

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

### Problemas de Permisos
```bash
# Verificar permisos de archivos
docker exec curriculum-portfolio ls -la /usr/share/nginx/html/

# Corregir permisos si es necesario
docker exec -u root curriculum-portfolio chown -R nginx:nginx /usr/share/nginx/html/
```

## Comandos Docker Avanzados

### Inspección y Monitoreo
```bash
# Inspeccionar contenedor
docker inspect curriculum-portfolio

# Ver uso de recursos en tiempo real
docker stats curriculum-portfolio

# Ver puertos expuestos
docker port curriculum-portfolio

# Ver historial de la imagen
docker history curriculum-portfolio
```

### Backup y Restauración
```bash
# Crear backup del contenedor
docker commit curriculum-portfolio curriculum-backup

# Exportar imagen
docker save curriculum-portfolio > curriculum.tar

# Importar imagen
docker load < curriculum.tar

# Copiar archivos desde/hacia contenedor
docker cp archivo.txt curriculum-portfolio:/tmp/
docker cp curriculum-portfolio:/tmp/archivo.txt ./
```

### Limpieza del Sistema
```bash
# Limpiar todo lo no usado
docker system prune -a

# Limpiar solo imágenes
docker image prune

# Limpiar contenedores parados
docker container prune

# Ver espacio usado por Docker
docker system df
```

## Tecnologías Utilizadas

- **Docker**: Containerización
- **Nginx**: Servidor web y proxy reverso
- **HTML/CSS**: Frontend del curriculum
- **Alpine Linux**: Sistema operativo base ligero

## Buenas Prácticas de Seguridad

- ✅ Usar imágenes oficiales (nginx:alpine)
- ✅ No ejecutar como root en producción
- ✅ Usar .dockerignore para excluir archivos sensibles
- ✅ Mantener imágenes actualizadas
- ✅ Limitar recursos del contenedor
- ✅ Usar redes personalizadas en producción

## Autor

Jonatan Andres Sanchez Ayala