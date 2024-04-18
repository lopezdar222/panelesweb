const axios = require('axios');

async function retirar(nombre, monto, agent_user, agent_pass) {
    try {
        const url = `https://wallet-uat.emaraplay.com/bot/user/withdraw`;
        // Datos que deseas enviar en la petición POST
        const data = {
            agent : {
                username : agent_user,
                password : agent_pass
            },
            user : {
                username : nombre
            },
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
            if (response.data.description == 'Not enough balance') {
                return 'faltante';
            } else {
                return 'error';
            }
        }
    } catch (error) {
        //console.log(`----------\nSucedio un error en la creación del usuario ${nombre}.\n${error}\n----------\n`);
        return 'error';
    }
};

module.exports = retirar;