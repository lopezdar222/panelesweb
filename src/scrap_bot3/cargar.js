const axios = require('axios');

async function cargar(nombre, monto, variables_utiles) {
    try {
        const url = `https://wallet-uat.emaraplay.com/bot/user/deposit`;
        // Datos que deseas enviar en la petición POST
        const data = {
            agent : {
                username : variables_utiles.ADMIN,
                password : variables_utiles.ADMIN_PASS
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
            return 'error';
        }
    } catch (error) {
        //console.log(`----------\nSucedio un error en la creación del usuario ${nombre}.\n${error}\n----------\n`);
        return 'error';
    }
};

module.exports = cargar;