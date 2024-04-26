const path = require('path');
const db = require(__dirname + '/db');
const https = require('https');
const WebSocket = require('ws');
const fs = require('fs');
///////////////////////////////////////////////////////////////////////////////
db.pruebaConexion();
//*********************WEBSOCKETS***********************/
const server = https.createServer({
    cert: fs.readFileSync(path.join(__dirname, '../ssl/certificado.crt')), // Ruta al certificado SSL
    key: fs.readFileSync(path.join(__dirname, '../ssl/clave_privada.key')) // Ruta a la clave privada
});

const wss = new WebSocket.Server({ server });

server.listen(8080, function() {
    db.insertLogMessage(`Servidor WebSocket HTTPS iniciado en el puerto 8080`);
});

const conexiones = {};

wss.on('connection', async function connection(ws) {
    ws.on('message', async function incoming(message) {
        const data = JSON.parse(message);
        let cod_elemento = data.ws_cliente + '-' + data.es_cliente;
        let cliente_nuevo = null;
        
        let log_alerta = `Mensaje de ClienteWS |${String(data.ws_cliente).trim()}| - EsCliente : |${String(data.es_cliente).trim()}| - IdCliente |${String(data.id_cliente).trim()}|`;
        log_alerta = log_alerta + ` - Alerta: ${data.alerta}`;
        await db.insertLogMessage(log_alerta);

        let claves = Object.keys(conexiones);
        if (!claves.includes(cod_elemento)) {
            cliente_nuevo = { cliente_ws : ws,
                                es_cliente : String(data.es_cliente).trim(),
                                ws_cliente : String(data.ws_cliente).trim(),
                                id_cliente : String(data.id_cliente).trim()};
            conexiones[cod_elemento] = cliente_nuevo;
            await db.insertLogMessage(`Bienvenido Cliente ${cliente_nuevo.ws_cliente} (EsCliente : ${cliente_nuevo.es_cliente}) - Conexiones: ${Object.keys(conexiones).length}`);
            sendMessageToClient(conexiones[cod_elemento].cliente_ws, {alerta : 'hola desde el servidor!'});
        } else {
            await db.insertLogMessage(`Conexiones: ${Object.keys(conexiones).length}`);
            if (data.alerta == 'actualiza' && data.es_cliente == 0) {
                conexiones[cod_elemento].id_cliente = data.id_cliente;
                log_alerta = `Actualiza: ClienteWS ${conexiones[cod_elemento].ws_cliente} - IdCliente : ${conexiones[cod_elemento].id_cliente}`;
                await db.insertLogMessage(log_alerta);
            } else if (data.alerta == 'chat' && data.es_cliente == 0) {
                for (let key in conexiones) {
                    if ((conexiones[key].ws_cliente == data.id_cliente) && (conexiones[key].es_cliente == 1)) {
                        log_alerta = `Alerta a Cliente: ${conexiones[key].ws_cliente} - De Operador : ${data.ws_cliente}`;
                        db.insertLogMessage(log_alerta);
                        sendMessageToClient(conexiones[key].cliente_ws, {alerta : 'chat'});
                        break;
                    }
                } 
            } else if (data.alerta == 'chat' && data.es_cliente == 1) {
                for (let key in conexiones) {
                    //if ((conexiones[key].id_cliente == data.id_cliente) && (conexiones[key].es_cliente == 0)) {
                    if (conexiones[key].es_cliente == 0) {
                        log_alerta = `Alerta a Operador: ${conexiones[key].ws_cliente} - De cliente : ${data.ws_cliente}`;
                        db.insertLogMessage(log_alerta);
                        //alerta_chat.id_cliente = data.id_cliente;
                        sendMessageToClient(conexiones[key].cliente_ws, {alerta : 'chat', id_cliente : data.id_cliente});
                    }
                };
            } else if ((data.alerta == 'sol_retiro_aceptada' || data.alerta == 'sol_carga_aceptada'
                        || data.alerta == 'sol_retiro_rechazada' || data.alerta == 'sol_carga_rechazada')
                        && data.es_cliente == 0) {
                for (let key in conexiones) {
                    if ((conexiones[key].ws_cliente == data.id_cliente) && (conexiones[key].es_cliente == 1)) {
                        log_alerta = `Alerta a Cliente: ${conexiones[key].ws_cliente} - De Operador : ${data.ws_cliente} - ${data.alerta}`;
                        db.insertLogMessage(log_alerta);
                        //alerta_chat.id_cliente = data.id_cliente;
                        sendMessageToClient(conexiones[key].cliente_ws, {alerta : data.alerta, id_cliente : data.id_cliente});
                        break;
                    }
                };
            } else if ((data.alerta == 'sol_retiro_creada' || data.alerta == 'sol_carga_creada')
                        && data.es_cliente == 1) {
                for (let key in conexiones) {
                    if (conexiones[key].es_cliente == 0) {
                        log_alerta = `Alerta a Operador: ${conexiones[key].ws_cliente} - De Cliente : ${data.ws_cliente} - ${data.alerta}`;
                        db.insertLogMessage(log_alerta);
                        //alerta_chat.id_cliente = data.id_cliente;
                        sendMessageToClient(conexiones[key].cliente_ws, {alerta : data.alerta, id_cliente : data.id_cliente});
                    }
                };
            }
        } 
    });
    ws.on('close', async function close(message) {
        const data = JSON.parse(message);
        // Eliminar la conexión del cliente del array de conexiones
        for (let key in conexiones) {
            if (conexiones[key].cliente_ws == ws) {
                await db.insertLogMessage(`***Elemento ${key} -> Baja ClienteWS ${conexiones[key].ws_cliente} - EsCliente : ${conexiones[key].es_cliente}`);
                delete conexiones[key];
                break;
            }
        }
    });
});

function sendMessageToClient(client, data) {
    client.send(JSON.stringify(data));
}