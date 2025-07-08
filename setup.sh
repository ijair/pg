#!/bin/bash
set -e

# 1. Levantar el contenedor
docker-compose up -d

# 2. Esperar a que PostgreSQL esté listo
echo "Esperando a que PostgreSQL esté listo..."
until docker exec northwind-db pg_isready -U northwind; do
  sleep 2
done

# 3. Descargar el dump de Northwind si no existe
if [ ! -f northwind.sql ]; then
  echo "Descargando northwind.sql..."
  curl -L -o northwind.sql https://raw.githubusercontent.com/pthom/northwind_psql/master/northwind.sql
fi

# 4. Cargar el dump en la base de datos
echo "Cargando datos en la base de datos..."
cat northwind.sql | docker exec -i northwind-db psql -U northwind -d northwind

# 5. Ejecutar la consulta y exportar a CSV
echo "Exportando tabla customers a customers.csv..."
docker exec -i northwind-db psql -U northwind -d northwind -c "\COPY customers TO '/tmp/customers.csv' CSV HEADER"

# 6. Copiar el archivo CSV al host
docker cp northwind-db:/tmp/customers.csv ./customers.csv

echo "¡Listo! El archivo customers.csv está en el directorio actual." 