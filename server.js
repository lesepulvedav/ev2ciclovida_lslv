const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  // Toma el color de las variables de entorno de Kubernetes, por defecto azul
  const bgColor = process.env.BG_COLOR || 'blue'; 
  const version = bgColor === 'blue' ? 'V1 (Estable)' : 'V2 (Nueva Versión)';
  
  let html = `<body style="background-color: ${bgColor}; color: white; font-family: sans-serif; text-align: center; padding: 50px;">`;
  html += `<h1>TechMarket - Microservicio Orders (EKS)</h1>`;
  html += `<h2>Estado: ${version}</h2>`;
  html += `<p>Procesando órdenes de compra en tiempo real...</p>`;
  html += `</body>`;

  res.send(html);
});

app.listen(port, () => console.log(`Orders API corriendo en puerto ${port}`));