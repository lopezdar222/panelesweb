const Usuario = require('../database/models/Usuario.js');

async function obtenerUsuario(id) {
    let dataLinked = await Usuario.findOne({ id });
    if (dataLinked === null) {
        dataLinked = {
            username: id,
            id,
            step: 0
        }
        try {
            await Usuario.create(dataLinked);
        } catch (error) {
            console.log(`${error}\n\nSucedio un error al intentar crear al usuario ${id}`);
        }
    };
    return dataLinked;
}

module.exports = obtenerUsuario;