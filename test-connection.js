const { Client } = require('pg');

console.log('🔍 Probando conexión externa a PostgreSQL...');

const client = new Client({
  host: 'localhost',
  port: 5432,
  database: 'northwind',
  user: 'northwind',
  password: 'northwind',
  connectionTimeoutMillis: 10000
});

client.connect()
  .then(() => {
    console.log('✅ Conexión exitosa!');
    return client.query('SELECT current_user, current_database(), version()');
  })
  .then((result) => {
    console.log('📊 Información de conexión:');
    console.log('   Usuario:', result.rows[0].current_user);
    console.log('   Base de datos:', result.rows[0].current_database);
    console.log('   Versión:', result.rows[0].version.split(',')[0]);
    
    return client.query('SELECT COUNT(*) as total_customers FROM customers');
  })
  .then((result) => {
    console.log('📈 Total de clientes en la base de datos:', result.rows[0].total_customers);
    console.log('🎉 ¡Conexión externa funcionando perfectamente!');
  })
  .catch((err) => {
    console.error('❌ Error de conexión:', err.message);
    console.error('   Código:', err.code);
  })
  .finally(() => {
    client.end();
  }); 