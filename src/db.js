const { Pool } = require('pg');
//const ip = require('ip');

const pool = new Pool({
    //publica:
    host: '149.50.139.207',
    //local:
    //host: 'localhost',
    port: 5432,
    user: 'postgres',
    password: 'paneles0110',
    database: 'panelesweb',
});

// Realizar una consulta de prueba
async function pruebaConexion() {
    try {
        const client = await pool.connect();

        const sql = `SELECT NOW() as now;`;

        client.query(sql, (error, result) => {
            if (error) {
                console.error('Error al conectar con PostgreSQL:', error);
            } else {
                console.log('Conexión exitosa con PostgreSQL. Hora actual:', result.rows[0].now);
            }
        });

        client.release();
    } catch (error) {
        console.error('Error al conectarse a la base de datos:', error);
    }
}

async function insertLogMessage(message) {
    try {
        const client = await pool.connect();

        const sql = `INSERT INTO console_logs (mensaje_log, fecha_hora) VALUES ($1, NOW());`;
        const values = [message];

        await client.query(sql, values);

        client.release();
    } 
    catch (error) {
        console.error('Error al insertar el mensaje en la base de datos:', error);
    }
}

async function handlerSQL(sql) {
try {
    const client = await pool.connect();

    const result = await pool.query(sql);

    client.release();
    
    return result;

    } catch (error) {
        console.error('Error al interactuar con base de datos:', error);
        return null;
    }
}

module.exports = {
    pruebaConexion,
    insertLogMessage,
    handlerSQL
};