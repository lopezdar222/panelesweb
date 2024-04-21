const WebSocket = require('ws');

// Crear un servidor WebSocket
const wss = new WebSocket.Server({ port: 8080 });

// Array para almacenar las conexiones de los clientes
const conexiones = [];
//const clientsIntervals = [];

// Evento cuando se establece una conexión con un cliente
wss.on('connection', function connection(ws) {

    console.log('Cliente conectado');

    // Evento cuando se recibe un mensaje del cliente
    ws.on('message', function incoming(message) {
        const data = JSON.parse(message);
        const cliente_check =  {
                                id_token : data.id_token,
                                cliente_ws : ws,
                                es_cliente : data.es_cliente,
                                id_cliente : data.id_cliente};
        let mensaje = '';
        let encontrado = false;

        conexiones.forEach((conexion, indice) => {
            if (conexion.cliente_ws === ws) {
                encontrado = true;
            }
        });

        if (encontrado) {
            mensaje = `Hola Cliente ${data.id_cliente} (EsCliente : ${data.es_cliente})`;
            mensaje = mensaje + ` Tu mensaje es: ${data.mensaje}`;
        } else {
            // Agregar la conexión del cliente al array de clientes
            conexiones.push(cliente_check);
            mensaje = `Bienvenido Cliente ${data.id_cliente} (EsCliente : ${data.es_cliente})`;
        }

        // Ejemplo de cómo responder al cliente con un objeto JSON
        const response = { 
            type: 'respuesta',
            content : mensaje
        };
        sendMessageToClient(ws, response);
    });

    // Enviar un mensaje push al cliente cada 5 segundos
    /*const pushInterval = setInterval(() => {
        sendMessageToClient(ws, '¡Hola desde el servidor!');

        const response = { 
            type: 'periodico',
            content: '¡Hola desde el servidor!'
        };
        sendMessageToClient(ws, response);

    }, 5000);
    
    clientsIntervals.push(pushInterval);*/

    // Evento cuando se cierra la conexión con el cliente
    ws.on('close', function close() {
        console.log('Cliente desconectado');
        //clearInterval(pushInterval);
        // Eliminar la conexión del cliente del array de conexiones
        conexiones.forEach((conexion, indice) => {
            if (conexion.cliente_ws === ws) {
                console.log(`Elemento encontrado en la posición ${indice}, IdCliente: ${conexion.id_cliente}, EsCliente: ${conexion.es_cliente}`);
                // Aquí puedes realizar alguna acción con el elemento encontrado
                conexiones.splice(indice, 1);
            }
        })
        //clientsIntervals.splice(clientsIntervals.indexOf(pushInterval), 1);
    });
});

// Función para enviar un mensaje a un cliente específico
function sendMessageToClient(client, data) {
    client.send(JSON.stringify(data));
}

// Ejemplo de cómo enviar un mensaje a un cliente específico
// Aquí podrías llamar a esta función en cualquier momento para enviar un mensaje específico a un cliente
// Por ejemplo, sendMessageToClient(clients[0], 'Mensaje específico para el primer cliente');

// Ejemplo de cómo enviar un mensaje a todos los clientes
// clients.forEach(client => client.send('¡Hola a todos!'));