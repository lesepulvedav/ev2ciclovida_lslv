# Usar una imagen base oficial de Node.js ultra ligera (Alpine Linux)
FROM node:18-alpine

# Crear y definir el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Inicializar un proyecto Node e instalar el framework Express
RUN npm init -y && npm install express

# Copiar el código de nuestra API (server.js) al contenedor
COPY server.js .

# Exponer el puerto 8080 (el mismo que configuramos en Kubernetes y en la app)
EXPOSE 8080

# Comando por defecto para arrancar el microservicio
CMD [ "node", "server.js" ]