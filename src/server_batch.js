const path = require('path');
const db = require(__dirname + '/db');
const https = require('https');
const fs = require('fs');
let anulando_notificaciones = 0;
const esperaRegistro = 60;
///////////////////////////////////////////////////////////////////////////////
db.pruebaConexion();

async function anular_Notificaciones_Landing() {
    if (anulando_notificaciones == 0)
    {
        console.log('Procesa Anulacion');
        anulando_notificaciones = 1;
        try {
            const query = `SELECT  id_notificacion ` +
                            `FROM v_Notificaciones_Cargas ` +
                            `WHERE fecha_hora < NOW() - INTERVAL '1 hour' ` +
                            `AND anulada = false ` +
                            `AND id_operacion_carga IS NULL ` +
                            `AND marca_procesado = false ` +
                            `ORDER BY fecha_hora LIMIT 1`;
            //console.log(query);
            const result = await db.handlerSQL(query);
            if (result.rows.length > 0) {
                console.log(`Anula: ${result.rows[0].id_notificacion}`);
                const query2 = `SELECT Registrar_Anulacion_Carga(${result.rows[0].id_notificacion}, 1)`;
                await db.handlerSQL(query2);
            }            
            anulando_notificaciones = 0;
        } catch (error) {
            anulando_notificaciones = 0;
            console.error('Error al Anular Notificaciones', error);
            throw error;
        }
    }
};

const intervalId_01 = setInterval(anular_Notificaciones_Landing, esperaRegistro * 1000); // (30000 ms = 30 segundos)