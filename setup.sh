#!/bin/bash
set -e

echo "🚀 Iniciando configuración de PostgreSQL 16 con Northwind..."

# 1. Detener y limpiar contenedores existentes
echo "🧹 Limpiando contenedores existentes..."
docker-compose down -v 2>/dev/null || true

# 2. Levantar el contenedor
echo "🚀 Levantando contenedor PostgreSQL 16..."
docker-compose up -d

# 3. Esperar a que PostgreSQL esté listo
echo "⏳ Esperando a que PostgreSQL esté listo..."
until docker exec northwind-db pg_isready -U postgres; do
  echo "   Esperando conexión a PostgreSQL..."
  sleep 3
done
echo "✅ PostgreSQL está listo!"

# 4. Crear usuario y base de datos northwind con permisos correctos
echo "👤 Creando usuario y base de datos northwind..."
docker exec northwind-db psql -U postgres -d postgres -c "
-- Crear usuario northwind si no existe
DO \$\$ 
BEGIN 
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'northwind') THEN
    CREATE USER northwind WITH PASSWORD 'northwind';
  END IF;
END \$\$;
"

# Crear base de datos northwind si no existe
docker exec northwind-db psql -U postgres -d postgres -c "
CREATE DATABASE northwind OWNER northwind;
" 2>/dev/null || echo "Base de datos northwind ya existe"

# Otorgar todos los privilegios al usuario northwind
docker exec northwind-db psql -U postgres -d postgres -c "
GRANT ALL PRIVILEGES ON DATABASE northwind TO northwind;
GRANT CREATE ON DATABASE northwind TO northwind;
"

# 5. Verificar que el usuario y base de datos fueron creados correctamente
echo "🔍 Verificando creación de usuario y base de datos..."
docker exec northwind-db psql -U postgres -d postgres -c "
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb FROM pg_roles WHERE rolname = 'northwind';
SELECT datname, datdba::regrole FROM pg_database WHERE datname = 'northwind';
"

# 6. Descargar el dump de Northwind si no existe
if [ ! -f northwind.sql ]; then
  echo "📥 Descargando northwind.sql..."
  curl -L -o northwind.sql https://raw.githubusercontent.com/pthom/northwind_psql/master/northwind.sql
fi

# 7. Cargar el dump en la base de datos
echo "📊 Cargando datos en la base de datos..."
cat northwind.sql | docker exec -i northwind-db psql -U northwind -d northwind

# 8. Verificar que los datos se cargaron correctamente
echo "🔍 Verificando carga de datos..."
docker exec northwind-db psql -U northwind -d northwind -c "
SELECT COUNT(*) as total_tables FROM information_schema.tables WHERE table_schema = 'public';
SELECT COUNT(*) as total_customers FROM customers;
"

# 9. Ejecutar la consulta y exportar a CSV
echo "📄 Exportando tabla customers a customers.csv..."
docker exec -i northwind-db psql -U northwind -d northwind -c "\COPY customers TO '/tmp/customers.csv' CSV HEADER"

# 10. Copiar el archivo CSV al host
docker cp northwind-db:/tmp/customers.csv ./customers.csv

# 11. Verificar configuración de conexiones externas
echo "🔍 Verificando configuración de conexiones externas..."
docker exec northwind-db psql -U postgres -d postgres -c "
SHOW listen_addresses;
SHOW port;
"

# 12. Verificar que el puerto está abierto
echo "🔍 Verificando que el puerto 5432 está abierto..."
docker exec northwind-db netstat -tlnp | grep 5432 || echo "⚠️  Puerto 5432 no encontrado en netstat"

# 13. Verificar conexión externa desde el contenedor
echo "🔍 Verificando conexión externa desde el contenedor..."
docker exec northwind-db psql -h localhost -p 5432 -U northwind -d northwind -c "SELECT 'Conexión externa exitosa desde contenedor' as status;"

# 14. Verificar conexión externa desde el host
echo "🔍 Verificando conexión externa desde el host..."
if command -v psql &> /dev/null; then
    echo "✅ Probando conexión desde host local..."
    PGPASSWORD=northwind psql -h localhost -p 5432 -U northwind -d northwind -c "SELECT 'Conexión externa exitosa desde host' as status;" || echo "⚠️  Advertencia: No se pudo conectar desde el host local"
else
    echo "ℹ️  psql no está instalado en el host. Para probar conexiones externas, instala PostgreSQL client."
fi

# 15. Verificar permisos del usuario northwind
echo "🔍 Verificando permisos del usuario northwind..."
docker exec northwind-db psql -U postgres -d northwind -c "
SELECT 
    r.rolname,
    r.rolsuper,
    r.rolcreaterole,
    r.rolcreatedb,
    r.rolcanlogin,
    r.rolreplication
FROM pg_roles r 
WHERE r.rolname = 'northwind';
"

# 16. Verificar que el usuario puede conectarse y ejecutar consultas
echo "🔍 Verificando capacidad de conexión y consultas del usuario northwind..."
docker exec northwind-db psql -U northwind -d northwind -c "
SELECT current_user, current_database();
SELECT COUNT(*) as total_customers FROM customers;
"

echo ""
echo "🎉 ¡Configuración completada exitosamente!"
echo ""
echo "📊 Información de conexión:"
echo "   Host: localhost"
echo "   Puerto: 5432"
echo "   Base de datos: northwind"
echo "   Usuario: northwind"
echo "   Contraseña: northwind"
echo "   PostgreSQL Version: 16"
echo ""
echo "🔗 Ejemplo de conexión externa:"
echo "   psql -h localhost -p 5432 -U northwind -d northwind"
echo "   o desde tu aplicación:"
echo "   DATABASE_URL=postgresql://northwind:northwind@localhost:5432/northwind"
echo ""
echo "📁 Archivo CSV generado: customers.csv"
echo ""
echo "🔧 Comandos útiles:"
echo "   - Ver logs: docker logs northwind-db"
echo "   - Conectar al contenedor: docker exec -it northwind-db psql -U northwind -d northwind"
echo "   - Detener: docker-compose down"
echo "   - Reiniciar: docker-compose restart" 