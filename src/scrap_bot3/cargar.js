const axios = require('axios');

async function cargar(id_cliente_ext, id_cliente_db, nombre, monto, agent_user, agent_pass) {
    try {
        const url = `https://wallet-uat.emaraplay.com/bot/user/deposit`;
        // Datos que deseas enviar en la petición POST
        const data = {
            agent : {
                username : agent_user,
                password : agent_pass
            },
            user : {
                id : id_cliente_ext,
                db : id_cliente_db
            },
            /*user : {
                username : nombre
            },*/
            amount : monto
        };
        
        // Configuración de la petición
        const config = {
          method: 'post',
          url: url,
          data: data
        };

        // Realizar la petición POST
        const response = await axios(config);
        
        if (response.data.error == false) {
            return 'ok';
        } else {
            return 'error';
        }
    } catch (error) {
        return 'error';
    }
};

module.exports = cargar;