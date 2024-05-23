const cluster = require('cluster');
const os = require('os');
const path = require('path');
const db = require(path.join(__dirname, '/db'));
const https = require('https');
const WebSocket = require('ws');
//const redis = require('redis');
const { createClient } = require('@redis/client');
const fs = require('fs');

const esperaRegistro = 30;
let registrando_sesiones = 0;
let redisConnected = false;

const redisClient = createClient({
    url: 'redis://localhost:6379'
    //url: 'redis://149.50.131.87:6379'  
});

redisClient.on('error', (err) => {
    console.error('Error en la conexión a Redis:', err);
});

async function conectarRedis() {
    try {
        await redisClient.connect();
        console.log('Conectado a Redis');

        const succeeded = await redisClient.flushDb();
        console.log('Todos los elementos han sido borrados:', succeeded);

        const reply = await redisClient.ping();
        console.log('Respuesta PING:', reply); // Debería ser "PONG"

        redisConnected = true;
    } catch (err) {
        console.error('Error en la conexión a Redis:', err);
    } /*finally {
        await redisClient.disconnect();
    }*/
}

conectarRedis();

const numCPUs = os.cpus().length;

console.log(`numCPUs ${numCPUs}`);

if (cluster.isMaster) {
    for (let i = 0; i < numCPUs; i++) {
        cluster.fork();
    }

    cluster.on('exit', (worker, code, signal) => {
        console.log(`Worker ${worker.process.pid} died`);
        cluster.fork();
    });
} else {
    //*********************WEBSOCKETS***********************/
    const server = https.createServer({
        cert: fs.readFileSync(path.join(__dirname, '../ssl/fullchain.pem')), // Ruta al certificado SSL
        key: fs.readFileSync(path.join(__dirname, '../ssl/clave_privada.key')) // Ruta a la clave privada
    });

    const wss = new WebSocket.Server({ server });

    wss.on('connection', function connection(ws) {
        ws.on('message', async function incoming(message) {
            if (!redisConnected) {
                console.error('Redis client is not connected');
                return;
            }
            let sessionData = null;
            const data = JSON.parse(message);
            const cod_elemento = `${data.ws_cliente}-${data.es_cliente}`;

            console.log('***************');
            console.log(cod_elemento);
            console.log(data.es_cliente);
            console.log(data.tipo);
            console.log(data.alerta);
            console.log(data.id_cliente);
            // Manejar la inicialización de sesión
            if (data.tipo == 1) {
                const cliente_nuevo = {
                    cliente_ws: ws,
                    es_cliente: String(data.es_cliente).trim(),
                    ws_cliente: String(data.ws_cliente).trim(),
                    id_cliente: String(data.id_cliente).trim()
                };

                redisClient.set(cod_elemento, cliente_nuevo, (err) => {
                //redisClient.set(cod_elemento, JSON.stringify(cliente_nuevo), (err) => {
                    if (err) {
                        db.insertLogMessage(`Session ${cod_elemento} : Redis set error:`, err);
                        console.error('Redis set error:', err);
                    } else {
                        console.log(`Session ${cod_elemento} initialized`);
                    }
                });
            }
            // Manejar la recuperación de sesión
            if (data.tipo == 0) {
                if (data.alerta == 'actualiza' && data.es_cliente == 0) {
                    console.log(`Va a buscar: ${cod_elemento}`);
                    const reply = await redisClient.get(cod_elemento, (err, reply) => {
                        if (err) {
                            console.error('Error retrieving session:', err);
                            return;
                        }
                        return reply;
                    });
                    console.log(`encuentra: ${JSON.parse(reply)}`);
                    //sessionData = JSON.parse(reply);
                    sessionData.id_cliente = data.id_cliente;

                    redisClient.set(cod_elemento, sessionData, (err) => {
                    //redisClient.set(cod_elemento, JSON.stringify(sessionData), (err) => {
                        if (err) {
                            console.error('Error updating session:', err);
                        }
                    });
                } else if (data.alerta == 'chat'  
                        || data.alerta == 'sol_carga_creada'
                        || data.alerta == 'sol_carga_aceptada'
                        || data.alerta == 'sol_carga_rechazada'
                        || data.alerta == 'sol_retiro_creada'
                        || data.alerta == 'sol_retiro_aceptada'
                        || data.alerta == 'sol_retiro_rechazada') {
                    
                    if (data.es_cliente == 0) {
                        const cod_elemento_busca = `${data.id_cliente}-1`;
                        console.log(`Va a buscar: ${cod_elemento_busca}`);
                        const reply = await redisClient.get(cod_elemento_busca, (err, reply) => {
                            if (err) {
                                console.error('Error retrieving session:', err);
                                return;
                            }
                            return reply;
                        });
                        if (reply) {
                            console.log(`encontrado!`);
                            //sessionData = JSON.parse(reply);
                            sessionData.cliente_ws.send({ alerta: data.alerta, id_cliente: data.id_cliente });
                            //sendMessageToClient(sessionData.cliente_ws, { alerta: data.alerta, id_cliente: data.id_cliente });    
                        }
                    } else {
                        const keys = redisClient.keys('*-0', (err, keys) => {
                            if (err) {
                                console.error('Error retrieving keys:', err);
                                return;
                            }
                        });
                        if (keys.length === 0) {
                            return;
                        }
                        let reply = null;
                        keys.forEach(async (key) => {
                            reply = await redisClient.get(key, (err, reply) => {
                                if (err) {
                                    console.error('Error retrieving session:', err);
                                    return;
                                }
                            });
                            sessionData = JSON.parse(reply);
                            sendMessageToClient(sessionData.cliente_ws, { alerta: data.alerta, id_cliente: data.id_cliente });
                        });
                    }
                }
            }
        });

        ws.on('close', async function close(message) {
            if (!redisConnected) {
                console.error('Redis client is not connected');
                return;
            }

            const data = JSON.parse(message);
            const cod_elemento_busca = `${data.ws_cliente}-${data.es_cliente}`;
            
            redisClient.del(cod_elemento_busca, (err, response) => {
                if (err) {
                    console.error('Error deleting session:', err);
                }
            });
        });
    });

    server.listen(8080, function() {
        db.insertLogMessage(`Servidor WebSocket HTTPS iniciado en el puerto 8080 -> Worker ${process.pid}`);
    });

    function sendMessageToClient(client, data) {
        client.send(JSON.stringify(data));
    }
}

/* registrar_Sesiones_Landing */
async function registrar_Sesiones_Landing() {
    if (registrando_sesiones === 0) {
        registrando_sesiones = 1;
        try {
            if (redisConnected) {
                redisClient.dbSize((err, size) => {
                    if (err) {
                        console.error('Error obteniendo la cantidad de claves:', err);
                        registrando_sesiones = 0;
                        return;
                    }
                    const query = `insert into registro_sesiones_sockets (fecha_hora, conexiones) values (Now(), ${size});`;
                    db.handlerSQL(query).then(() => {
                        registrando_sesiones = 0;
                    }).catch((error) => {
                        console.error('Error al Registrar Sesiones', error);
                        registrando_sesiones = 0;
                    });
                });
            } else {
                console.error('Redis client is not connected');
                registrando_sesiones = 0;
            }
        } catch (error) {
            registrando_sesiones = 0;
            console.error('Error al Registrar Sesiones', error);
            throw error;
        }
    }
}

const intervalId_01 = setInterval(registrar_Sesiones_Landing, esperaRegistro * 1000); // (30000 ms = 30 segundos)

// Cerrar el cliente Redis correctamente al terminar el proceso
process.on('SIGINT', () => {
    redisClient.quit(() => {
        console.log('Redis client disconnected');
        process.exit(0);
    });
});
