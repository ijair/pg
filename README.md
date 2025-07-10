# PostgreSQL 16 con Base de Datos Northwind

Este proyecto configura un contenedor Docker de PostgreSQL 16 con la base de datos de ejemplo Northwind, configurado para aceptar conexiones externas en el puerto 5432.

## 🚀 Inicio Rápido

### Prerrequisitos
- Docker y Docker Compose instalados
- Opcional: Cliente PostgreSQL (psql) para pruebas

### Instalación y Configuración

1. **Clonar o descargar el proyecto**
2. **Ejecutar el script de configuración:**
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

El script automáticamente:
- Descarga la base de datos Northwind
- Crea el usuario y base de datos
- Carga todos los datos
- Exporta la tabla customers a CSV
- Verifica las conexiones externas

## 📊 Información de Conexión

- **Host:** localhost
- **Puerto:** 5432
- **Base de datos:** northwind
- **Usuario:** northwind
- **Contraseña:** northwind
- **PostgreSQL Version:** 16

## 🔗 Ejemplos de Conexión

### Desde línea de comandos (psql)
```bash
psql -h localhost -p 5432 -U northwind -d northwind
```

### Desde aplicaciones
```bash
# URL de conexión
DATABASE_URL=postgresql://northwind:northwind@localhost:5432/northwind

# Variables de entorno
DB_HOST=localhost
DB_PORT=5432
DB_NAME=northwind
DB_USER=northwind
DB_PASSWORD=northwind
```

### Desde Docker
```bash
# Conectar al contenedor
docker exec -it northwind-db psql -U northwind -d northwind

# Ejecutar consulta
docker exec northwind-db psql -U northwind -d northwind -c "SELECT COUNT(*) FROM customers;"
```

## 📁 Estructura del Proyecto

```
.
├── docker-compose.yml      # Configuración de Docker
├── postgresql.conf         # Configuración de PostgreSQL
├── pg_hba.conf            # Configuración de autenticación
├── setup.sh               # Script de configuración automática
├── northwind.sql          # Dump de la base de datos Northwind
├── customers.csv          # Exportación de la tabla customers
├── init-northwind.sql     # Script de inicialización
└── README.md              # Este archivo
```

## 🛠️ Comandos Útiles

```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker logs northwind-db

# Detener servicios
docker-compose down

# Reiniciar servicios
docker-compose restart

# Ver estado de los contenedores
docker-compose ps
```

## 🔍 Verificación de Conexión

### Verificar que PostgreSQL está funcionando
```bash
docker exec northwind-db pg_isready -U postgres
```

### Verificar tablas disponibles
```bash
docker exec northwind-db psql -U northwind -d northwind -c "\dt"
```

### Verificar datos de customers
```bash
docker exec northwind-db psql -U northwind -d northwind -c "SELECT COUNT(*) FROM customers;"
```

## 📊 Base de Datos Northwind

La base de datos Northwind incluye las siguientes tablas:
- categories
- customer_customer_demo
- customer_demographics
- customers
- employee_territories
- employees
- order_details
- orders
- products
- region
- shippers
- suppliers
- territories
- us_states

## 🔧 Configuración de Red

El contenedor está configurado para:
- Escuchar en todas las interfaces (`listen_addresses = '*'`)
- Puerto 5432
- Aceptar conexiones externas con autenticación MD5
- Máximo 100 conexiones simultáneas

## 🚨 Solución de Problemas

### Puerto 5432 ya en uso
Si tienes PostgreSQL instalado localmente en el puerto 5432, detén el servicio:
```bash
# macOS
brew services stop postgresql

# Linux
sudo systemctl stop postgresql

# Windows
net stop postgresql
```

### Error de conexión
Verifica que el contenedor esté corriendo:
```bash
docker-compose ps
docker logs northwind-db
```

### Problemas de permisos
Si hay problemas de permisos, recrea el contenedor:
```bash
docker-compose down -v
./setup.sh
```

## 📝 Notas

- Los datos se persisten en un volumen de Docker
- La configuración permite conexiones externas seguras
- El usuario `northwind` tiene todos los permisos necesarios
- El archivo `customers.csv` se genera automáticamente