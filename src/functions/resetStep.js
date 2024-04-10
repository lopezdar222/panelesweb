//const Usuario = require("../database/models/Usuario.js");

async function resetStep() {
    /*let steps1000 = await Usuario.find({ step: 1000 });
    for (let i = 0; i < steps1000.length; i++) {
        await Usuario.findOneAndUpdate({ id: steps1000[i].id }, { step: 40 });
        console.log(`${steps1000[i].username} step 1000 a 40`);
    }*/
    //Modificar todas las sesiones con Step=1000 a 40
}

module.exports = resetStep;