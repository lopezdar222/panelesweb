const axios = require('axios');

async function contraseña(nombre, variables_utiles) {
    try {
        const url = `https://wallet-uat.emaraplay.com/bot/user/password`;
        // Datos que deseas enviar en la petición POST
        const data = {
            agent : {
                username : variables_utiles.ADMIN,
                password : variables_utiles.ADMIN_PASS
            },
            user : {
                username : nombre,
                newPassword : 'cambiar123'
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
            return 'error';
        } else {
            return 'ok';
        }
    } catch (error) {
        //console.log(`----------\nSucedio un error en la creación del usuario ${nombre}.\n${error}\n----------\n`);
        return 'error';
    }
};

module.exports = contraseña;