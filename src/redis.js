const { createClient } = require('@redis/client');

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
    } catch (err) {
        console.error('Error en la conexión a Redis:', err);
    } finally {
        await redisClient.disconnect();
    }
}

conectarRedis();