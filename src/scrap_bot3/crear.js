const axios = require('axios');

async function crear(nombre, variables_utiles) {
    try {
        console.log(`usuario: ${variables_utiles.ADMIN}`);
        console.log(`pass: ${variables_utiles.ADMIN_PASS}`);
        const url = `https://wallet-uat.emaraplay.com/bot/user/create`;
        // Datos que deseas enviar en la petición POST
        const data = {
            agent : {
                username : variables_utiles.ADMIN,
                password : variables_utiles.ADMIN_PASS
            },
            user : {
                username : nombre,
                password : 'cambiar123'
            }
        };

        // Configuración de la petición
        const config = {
          method: 'post',
          url: url,
          data: data
        };

        // Realizar la petición POST
        const response = await axios(config);
        if (response.data.error == true) {
            return 'taken';
        } else {
            return 'ok';
        }        
    } catch (error) {
        //console.log(`----------\nSucedio un error en la creación del usuario ${nombre}.\n${error}\n----------\n`);
        return 'error';
    }
};

module.exports = crear;