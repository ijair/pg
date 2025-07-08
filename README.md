# Northwind Database Setup

Este proyecto automatiza la configuración de una base de datos PostgreSQL con los datos de ejemplo de Northwind, utilizando Docker Compose. El script descarga automáticamente el dump de la base de datos y exporta la tabla `customers` a un archivo CSV.

## 📋 Descripción

El proyecto incluye:
- **Docker Compose**: Configuración para levantar un contenedor PostgreSQL
- **Script de automatización**: Descarga y carga automáticamente los datos de Northwind
- **Exportación a CSV**: Genera automáticamente un archivo CSV con los datos de clientes

## 🚀 Requisitos Previos

- Docker
- Docker Compose
- curl (para descargar el dump)

## 📁 Estructura del Proyecto

```
pg/
├── docker-compose.yml    # Configuración de Docker Compose
├── setup.sh             # Script de automatización
├── README.md            # Este archivo
├── northwind.sql        # Dump de la base de datos (se descarga automáticamente)
└── customers.csv        # Archivo CSV exportado (se genera automáticamente)
```

## 🛠️ Instalación y Uso

### 1. Clonar o descargar el proyecto

```bash
git clone <tu-repositorio>
cd pg
```

### 2. Dar permisos de ejecución al script

```bash
chmod +x setup.sh
```

### 3. Ejecutar el script de configuración

```bash
./setup.sh
```

## 🚀 Instrucciones de Ejecución Detalladas

### Ejecución Completa Automática

El script `setup.sh` automatiza todo el proceso:

```bash
./setup.sh
```

**Lo que hace el script:**
1. ✅ Levanta el contenedor PostgreSQL con Docker Compose
2. ✅ Espera a que la base de datos esté lista
3. ✅ Descarga automáticamente el archivo `northwind.sql`
4. ✅ Carga todos los datos en la base de datos
5. ✅ Exporta la tabla `customers` a `customers.csv`
6. ✅ Copia el archivo CSV al directorio actual

### Ejecución Paso a Paso (Manual)

Si prefieres ejecutar los comandos manualmente:

#### Paso 1: Levantar el contenedor
```bash
docker-compose up -d
```

#### Paso 2: Verificar que el contenedor esté funcionando
```bash
docker-compose ps
```

#### Paso 3: Descargar el dump de Northwind
```bash
curl -L -o northwind.sql https://raw.githubusercontent.com/pthom/northwind_psql/master/northwind.sql
```

#### Paso 4: Cargar los datos en la base de datos
```bash
cat northwind.sql | docker exec -i northwind-db psql -U northwind -d northwind
```

#### Paso 5: Exportar la tabla customers a CSV
```bash
docker exec -i northwind-db psql -U northwind -d northwind -c "\COPY customers TO '/tmp/customers.csv' CSV HEADER"
```

#### Paso 6: Copiar el archivo CSV al host
```bash
docker cp northwind-db:/tmp/customers.csv ./customers.csv
```

### Verificación de la Ejecución

Después de ejecutar el script, puedes verificar que todo funcionó correctamente:

#### Verificar que el contenedor está corriendo
```bash
docker-compose ps
```

#### Verificar que el archivo CSV se generó
```bash
ls -la customers.csv
```

#### Verificar el contenido del CSV
```bash
head -5 customers.csv
```

#### Conectarse a la base de datos para verificar datos
```bash
docker exec -it northwind-db psql -U northwind -d northwind -c "SELECT COUNT(*) FROM customers;"
```

## 📊 Configuración de la Base de Datos

### Detalles de Conexión
- **Host**: localhost
- **Puerto**: 5433
- **Base de datos**: northwind
- **Usuario**: northwind
- **Contraseña**: northwind

### Conexión Manual (opcional)

Si deseas conectarte manualmente a la base de datos:

```bash
# Usando psql desde el contenedor
docker exec -it northwind-db psql -U northwind -d northwind

# O usando un cliente PostgreSQL externo
psql -h localhost -p 5433 -U northwind -d northwind
```

## 🔧 Comandos Útiles

### Ver logs del contenedor
```bash
docker-compose logs db
```

### Detener el contenedor
```bash
docker-compose down
```

### Detener y eliminar volúmenes
```bash
docker-compose down -v
```

### Reiniciar el contenedor
```bash
docker-compose restart db
```

## 📈 Datos Incluidos

La base de datos Northwind incluye las siguientes tablas principales:
- `customers` - Información de clientes
- `employees` - Datos de empleados
- `orders` - Pedidos
- `order_details` - Detalles de pedidos
- `products` - Productos
- `suppliers` - Proveedores
- `categories` - Categorías de productos

## 📄 Archivo CSV Generado

El script genera automáticamente un archivo `customers.csv` que contiene:
- CustomerID
- CompanyName
- ContactName
- ContactTitle
- Address
- City
- Region
- PostalCode
- Country
- Phone
- Fax

## 🐛 Solución de Problemas

### Error de permisos
Si obtienes un error de permisos al ejecutar el script:
```bash
chmod +x setup.sh
```

### Puerto ocupado
Si el puerto 5433 está ocupado, modifica el archivo `docker-compose.yml`:
```yaml
ports:
  - "5434:5432"  # Cambia 5433 por otro puerto disponible
```

### Problemas de conexión
Si el contenedor no se levanta correctamente:
```bash
# Verificar el estado del contenedor
docker-compose ps

# Ver logs detallados
docker-compose logs db
```

## 📝 Personalización

### Cambiar versión de PostgreSQL
Edita `docker-compose.yml`:
```yaml
image: postgres:16  # Cambia la versión según necesites
```

### Modificar la consulta de exportación
Edita `setup.sh` en la línea de exportación:
```bash
docker exec -i northwind-db psql -U northwind -d northwind -c "\COPY (SELECT * FROM customers WHERE country = 'USA') TO '/tmp/customers.csv' CSV HEADER"
```

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🔗 Enlaces Útiles

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Northwind Database](https://github.com/pthom/northwind_psql)

## 📈 Instrucciones para Ejecutar Queries

### Método 1: Query Directa desde Línea de Comandos

Ejecuta una consulta SQL directamente sin conectarte a la base de datos:

```bash
# Sintaxis básica
docker exec -i northwind-db psql -U northwind -d northwind -c "TU_QUERY_AQUI"

# Ejemplos prácticos:
# Contar total de clientes
docker exec -i northwind-db psql -U northwind -d northwind -c "SELECT COUNT(*) FROM customers;"

# Ver primeros 5 clientes
docker exec -i northwind-db psql -U northwind -d northwind -c "SELECT company_name, contact_name FROM customers LIMIT 5;"

# Clientes por país
docker exec -i northwind-db psql -U northwind -d northwind -c "SELECT country, COUNT(*) FROM customers GROUP BY country ORDER BY COUNT(*) DESC;"
```

### Método 2: Modo Interactivo (Recomendado para múltiples queries)

Conéctate a la base de datos en modo interactivo:

```bash
# Conectar a la base de datos
docker exec -it northwind-db psql -U northwind -d northwind
```

Una vez conectado, puedes ejecutar queries interactivamente:

```sql
-- Listar todas las tablas disponibles
\dt

-- Ver estructura de una tabla específica
\d customers

-- Ejecutar queries
SELECT * FROM customers LIMIT 3;

SELECT company_name, country FROM customers WHERE country = 'USA';

-- Salir de psql
\q
```

### Método 3: Query desde Archivo

Crea un archivo con tu query y ejecútalo:

```bash
# Crear archivo con query
echo "SELECT company_name, contact_name FROM customers WHERE country = 'Germany';" > mi_query.sql

# Ejecutar query desde archivo
docker exec -i northwind-db psql -U northwind -d northwind < mi_query.sql
```

### Ejemplos de Queries Útiles

#### Consultas Básicas
```bash
# Ver todas las tablas
docker exec -i northwind-db psql -U northwind -d northwind -c "\dt"

# Contar registros en cada tabla
docker exec -i northwind-db psql -U northwind -d northwind -c "
SELECT 'customers' as tabla, COUNT(*) as total FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;"

# Ver estructura de tabla
docker exec -i northwind-db psql -U northwind -d northwind -c "\d products"
```

#### Consultas de Análisis
```bash
# Top 5 productos más caros
docker exec -i northwind-db psql -U northwind -d northwind -c "
SELECT product_name, unit_price 
FROM products 
ORDER BY unit_price DESC 
LIMIT 5;"

# Clientes con más pedidos
docker exec -i northwind-db psql -U northwind -d northwind -c "
SELECT c.company_name, COUNT(o.order_id) as total_pedidos
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_pedidos DESC
LIMIT 10;"

# Ventas por categoría
docker exec -i northwind-db psql -U northwind -d northwind -c "
SELECT cat.category_name, SUM(od.quantity * od.unit_price) as ventas_totales
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_details od ON p.product_id = od.product_id
GROUP BY cat.category_id, cat.category_name
ORDER BY ventas_totales DESC;"
```

### Exportar Resultados de Queries

```bash
# Exportar query a CSV
docker exec -i northwind-db psql -U northwind -d northwind -c "
\COPY (
    SELECT company_name, contact_name, country 
    FROM customers 
    WHERE country IN ('USA', 'Germany', 'France')
) TO '/tmp/clientes_export.csv' CSV HEADER"

# Copiar archivo CSV al host
docker cp northwind-db:/tmp/clientes_export.csv ./clientes_export.csv
```

### Tips para Queries

1. **Usar comillas simples** para strings en SQL
2. **Escape de caracteres especiales** si usas comillas dobles en bash
3. **Para queries largas**, usa el modo interactivo
4. **Para múltiples queries**, sepáralas con punto y coma
5. **Usar LIMIT** para evitar resultados muy grandes

### Comandos Útiles de psql

```sql
-- Dentro de psql:
\dt          -- Listar tablas
\d tabla     -- Ver estructura de tabla
\du          -- Listar usuarios
\l           -- Listar bases de datos
\q           -- Salir
\?           -- Ayuda de comandos
\h           -- Ayuda de SQL
```