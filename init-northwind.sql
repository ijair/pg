-- Crear base de datos northwind
CREATE DATABASE northwind;

-- Crear usuario northwind
CREATE USER northwind WITH PASSWORD 'northwind';

-- Otorgar permisos al usuario northwind
ALTER USER northwind WITH SUPERUSER CREATEDB CREATEROLE REPLICATION;
GRANT ALL PRIVILEGES ON DATABASE northwind TO northwind; 