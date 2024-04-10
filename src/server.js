const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const session = require('express-session');
const bcrypt = require('bcrypt');
const db = require(__dirname + '/db');
const ejs = require('ejs');
const axios = require('axios');
///////////////////////////////////////////////////////////////////////////////
const app = express();
const PORT = process.env.PORT || 3000;
///////////////////////////////////////////////////////////////////////////////
db.pruebaConexion();
//dbMongo.pruebaConexion();
app.listen(PORT, () => {
    db.insertLogMessage(`Servidor en funcionamiento en el puerto ${PORT}`);
});
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json()); // Para analizar JSON
app.use(express.urlencoded({ extended: true })); // Para analizar datos de formularios URL-encoded
const ejecucion_servidor = false;
const ejecucion_servidor_numero = 1;
// Configurar EJS como motor de vistas/////////////////////////////////////////
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '../public/views'));
//Whatsapp/////////////////////////////////////////////////////////////////////
const dias_historial = 20;
// Configuración de sesiones
app.use(session({
    secret: 'tu-secreto-seguro',
    resave: false,
    saveUninitialized: true
}));

// Rutas
app.get('/', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'public', 'index.html'));
});

app.get('/monitoreo_cuentas_cobro', async (req, res) => {
    res.render('monitoreo_cuentas_cobro', { title: 'Monitoreo Cuentas de Cobro' });
});

app.get('/agentes_ayuda', async (req, res) => {
    res.render('agentes_ayuda', { title: 'Tutorial de Agentes' });
});

app.get('/usuarios_ayuda', async (req, res) => {
    res.render('usuarios_ayuda', { title: 'Tutorial de Usuarios' });
});

app.get('/monitoreo_cuentas_cobro_ayuda', async (req, res) => {
    res.render('monitoreo_cuentas_cobro_ayuda', { title: 'Tutorial de Monitoreo Cuentas Cobro' });
});

app.get('/cuentas_cobro_ayuda', async (req, res) => {
    res.render('cuentas_cobro_ayuda', { title: 'Tutorial de Cuentas para Transferencias' });
});

app.get('/cuentas_cobro_descargas_ayuda', async (req, res) => {
    res.render('cuentas_cobro_descargas_ayuda', { title: 'Tutorial de Descargas de Cuentas' });
});

app.get('/configuracion_oficinias_ayuda', async (req, res) => {
    res.render('configuracion_oficinias_ayuda', { title: 'Tutorial de Configuracion de Oficinas' });
});

app.get('/reportes', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('reportes', { message: 'error de sesión', title: 'Reportes'});
            return;
        }
        const id_operador = result.rows[0].id_operador;
        res.render('reportes', { message: 'ok', title: 'Reportes', id_operador: id_operador, id_rol : id_rol });
    }
    catch (error) {
        res.render('reportes', { message: 'error', title: 'Reportes'});
    }
});

app.get('/agentes', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('agentes', { message: 'error de sesión', title: 'Agentes'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        let query2 = `select    id_agente,` +
                                `agente_usuario,` +
                                `agente_password,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24') as fecha_hora_creacion,` +
                                `marca_baja,` +
                                `id_oficina,` +
                                `oficina ` +
                        `from v_Agentes`;
        if (result.rows[0].id_rol > 1) {
            query2 = query2 + ` where id_oficina = ${id_oficina}`;
            if (result.rows[0].id_rol == 3) {
                query2 = query2 + ` and id_usuario = ${id_usuario}`;
            }
        }
        query2 = query2 + ` order by plataforma, oficina, marca_baja, agente_usuario`;
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('agentes', { message: 'No hay Agentes', title: 'Agentes', id_rol : id_rol, id_oficina : id_oficina});
            return;
        }
        const datos = result2.rows;
        res.render('agentes', { message: 'ok', title: 'Agentes', datos: datos, id_rol : id_rol, id_oficina : id_oficina});
    }
    catch (error) {
        res.render('agentes', { message: 'error', title: 'Agentes', id_rol : id_rol});
    }
});

app.get('/agentes_editar', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_agente = parseInt(req.query.id_agente, 10);
    const id_rol = parseInt(req.query.id_rol, 10);
    let query2 = `select    id_agente,` +
                            `agente_usuario,` +
                            `agente_password,` +
                            `id_plataforma,` +
                            `plataforma,` +
                            `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24') as fecha_hora_creacion,` +
                            `marca_baja,` +
                            `id_oficina,` +
                            `oficina ` +
                    `from v_Agentes where id_agente = ${id_agente}`;
    
    const result2 = await db.handlerSQL(query2);
    if (result2.rows.length == 0) {
        res.render('agentes_editar', { message: 'Agente No encontrado', title: 'Edición de Agente', id_rol : id_rol});
        return;
    }

    //const datos = result2.rows;
    const datos = [
        {   id_agente: result2.rows[0].id_agente,
            agente_usuario: result2.rows[0].agente_usuario, 
            agente_password: result2.rows[0].agente_password,
            fecha_hora_creacion : result2.rows[0].fecha_hora_creacion,
            marca_baja : result2.rows[0].marca_baja, 
            id_plataforma : result2.rows[0].id_plataforma,
            plataforma : result2.rows[0].plataforma,
            id_oficina : result2.rows[0].id_oficina,
            oficina : result2.rows[0].oficina}
    ];
    
    let query3 = '';
    let result3 = '';
    let datos_oficina = '';

    if (id_rol == 1)
    {
        query3 = `select id_oficina, oficina from v_Oficinas where marca_baja = false`;
        result3 = await db.handlerSQL(query3);
        datos_oficina = result3.rows;
    } else {
        datos_oficina = [
            {   id_oficina : result2.rows[0].id_oficina,
                oficina : result2.rows[0].oficina}
        ];
    }

    //console.log(datos);
    res.render('agentes_editar', { message: 'ok', title: 'Edición de Agente', datos: datos, datos_oficina : datos_oficina, id_rol : id_rol });
});

app.get('/agentes_nuevo', async (req, res) => {
    const id_rol = parseInt(req.query.id_rol, 10);
    const id_oficina = parseInt(req.query.id_oficina, 10);
    try {
        let query3 = '';
        let result3 = '';
        let datos_oficina = '';
    
        if (id_rol == 1)
        {
            query3 = `select id_oficina, oficina from v_Oficinas where marca_baja = false`;
            result3 = await db.handlerSQL(query3);
            datos_oficina = result3.rows;
        } else {
            query3 = `select id_oficina, oficina from v_Oficinas where marca_baja = false and id_oficina = ${id_oficina}`;
            result3 = await db.handlerSQL(query3);
            datos_oficina = result3.rows;
        }

        res.render('agentes_nuevo', { message: 'ok', title: 'Creación de Agente', datos_oficina : datos_oficina });
    }
    catch (error) {
        res.render('agentes_nuevo', { message: 'error', title: 'Creación de Agente'});
    }
});

app.get('/usuarios', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('usuarios', { message: 'error de sesión', title: 'Usuarios'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        let query2 = `select    id_usuario,` +
                                `usuario,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24') as fecha_hora_creacion,` +
                                `marca_baja,` +
                                `id_rol,` +
                                `nombre_rol,` +
                                `id_oficina,` +
                                `oficina ` +
                        `from v_Usuarios`;
        if (result.rows[0].id_rol > 1) {
            query2 = query2 + ` where id_oficina = ${id_oficina} and id_rol >= ${id_rol}`;
            if (result.rows[0].id_rol == 3) {
                query2 = query2 + ` and id_usuario = ${id_usuario}`;
            }
        }
        query2 = query2 + ` order by oficina, marca_baja, nombre_rol, usuario`;
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('usuarios', { message: 'No hay Usuarios', title: 'Usuarios', id_rol : id_rol, id_usuario : id_usuario});
            return;
        }
        const datos = result2.rows;
        res.render('usuarios', { message: 'ok', title: 'Usuarios', datos: datos, id_rol : id_rol, id_usuario : id_usuario});
    }
    catch (error) {
        res.render('usuarios', { message: 'error', title: 'Usuarios'});
    }
});

app.get('/usuarios_editar', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_rol = parseInt(req.query.id_rol, 10);
    //console.log(`select * from v_Sesion_Bot where orden = 1 and id_operador = ${id_operador};`);
    let query2 = `select    id_usuario,` +
                            `usuario,` +
                            `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24') as fecha_hora_creacion,` +
                            `marca_baja,` +
                            `id_rol,` +
                            `nombre_rol,` +
                            `id_oficina,` +
                            `oficina ` +
                    `from v_Usuarios where id_usuario = ${id_usuario}`;
    //const query = `select * from Obtener_Usuario('${username}')`;
    //console.log(query2);
    const result2 = await db.handlerSQL(query2);
    if (result2.rows.length == 0) {
        res.render('usuarios_editar', { message: 'Usuario No encontrado', title: 'Edición de Usuario'});
        return;
    }

    //const datos = result2.rows;
    const datos = [
        {   id_usuario: result2.rows[0].id_usuario,
            usuario: result2.rows[0].usuario, 
            fecha_hora_creacion : result2.rows[0].fecha_hora_creacion,
            marca_baja : result2.rows[0].marca_baja, 
            id_rol : result2.rows[0].id_rol,
            nombre_rol : result2.rows[0].nombre_rol,
            id_oficina : result2.rows[0].id_oficina,
            oficina : result2.rows[0].oficina}
    ];

    let query3 = '';
    let result3 = '';
    let datos_oficina = '';

    if (id_rol == 1)
    {
        query3 = `select id_oficina, oficina from v_Oficinas where marca_baja = false`;
        result3 = await db.handlerSQL(query3);
        datos_oficina = result3.rows;
    } else {
        datos_oficina = [
            {   id_oficina : result2.rows[0].id_oficina,
                oficina : result2.rows[0].oficina}
        ];
    }

    //console.log(datos);
    res.render('usuarios_editar', { message: 'ok', title: 'Edición de Usuario', datos: datos, id_rol : id_rol, datos_oficina : datos_oficina });
});

app.get('/usuarios_nuevo', async (req, res) => {
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query3 = `select id_oficina, oficina from v_Oficinas where marca_baja = false`;
        const result3 = await db.handlerSQL(query3);
        const datos_oficina = result3.rows;

        res.render('usuarios_nuevo', { message: 'ok', title: 'Creación de Usuario', datos_oficina : datos_oficina, id_rol : id_rol });
    }
    catch (error) {
        res.render('usuarios_nuevo', { message: 'error', title: 'Creación de Usuario'});
    }
});

app.get('/usuarios_historial', async (req, res) => {
    const id_usuario = parseInt(req.query.id_usuario, 10);
    try {
        let query3 = `select    usuario,` +
                                `nombre_rol,` +
                                `oficina,` +
                                `ip,` +
                                `TO_CHAR(fecha_hora_creacion, 'YYYY/MM/DD HH24:MI:SS') as fecha_hora_creacion,` +
                                `fecha_hora_cierre ` +
                        `from v_Usuarios_Sesiones Where id_usuario = ${id_usuario} ` +
                        `and (fecha_hora_creacion > CURRENT_DATE - INTERVAL '${dias_historial} days') ` +
                        `order by fecha_hora_creacion desc`;
        let registros = 0;
        const result3 = await db.handlerSQL(query3);
        if (result3.rows.length == 0) {
            res.render('usuarios_historial', { message: 'No hay Historial', title: 'Historial de Sesiones de Usuario', registros : registros});
            return;
        }
        registros = result3.rows.length;
        datos = result3.rows;
        res.render('usuarios_historial', { message: 'ok', title: 'Historial de Sesiones de Usuario', datos : datos, registros : registros });
    }
    catch (error) {
        res.render('usuarios_historial', { message: 'No hay Historial', title: 'Historial de Sesiones de Usuario'});
    }
});

app.get('/configuracion_oficinas', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        const result = await db.handlerSQL(query);
        if (result.rows.length === 0) {
            res.render('configuracion_oficinas', { message: 'error de sesión', title: 'Configuracion de Oficinas'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        //console.log(`select * from v_Sesion_Bot where orden = 1 and id_operador = ${id_operador};`);
        let query2 = `select    id_oficina,` +
                                `oficina,` +
                                `contacto_whatsapp,` +
                                `contacto_telegram,` +
                                `bono_carga_1,` +
                                `bono_carga_perpetua,` +
                                `minimo_carga,` +
                                `minimo_retiro,` +
                                `minimo_espera_retiro,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24') as fecha_hora_creacion,` +
                                `marca_baja ` +
                        `from v_Oficinas`;
        if (result.rows[0].id_rol > 1) {
            query2 = query2 + ` where id_oficina = ${id_oficina}`;
        }
        query2 = query2 + ` order by marca_baja, oficina`;
        //const query = `select * from Obtener_Usuario('${username}')`;
        //console.log(query2);
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('configuracion_oficinas', { message: 'No hay Oficinas', title: 'Configuracion de Oficinas'});
            return;
        }
        const datos = result2.rows;
        res.render('configuracion_oficinas', { message: 'ok', title: 'Configuracion de Oficinas', datos: datos, id_rol : id_rol });
    }
    catch (error) {
        res.render('configuracion_oficinas', { message: 'error', title: 'Configuracion de Oficinas'});
    }
});

app.get('/configuracion_oficinas_editar', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_oficina = parseInt(req.query.id_oficina, 10);
    //console.log(`select * from v_Sesion_Bot where orden = 1 and id_operador = ${id_operador};`);
    let query2 = `select    id_oficina,` +
                            `oficina,` +
                            `contacto_whatsapp,` +
                            `contacto_telegram,` +
                            `bono_carga_1,` +
                            `bono_carga_perpetua,` +
                            `minimo_carga,` +
                            `minimo_retiro,` +
                            `minimo_espera_retiro,` +
                            `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24') as fecha_hora_creacion,` +
                            `marca_baja ` +
                    `from v_Oficinas where id_oficina = ${id_oficina}`;
    //const query = `select * from Obtener_Usuario('${username}')`;
    //console.log(query2);
    const result2 = await db.handlerSQL(query2);
    if (result2.rows.length == 0) {
        res.render('configuracion_oficinas_editar', { message: 'Oficina No encontrada', title: 'Edición de Oficina'});
        return;
    }
    const datos = result2.rows;
    res.render('configuracion_oficinas_editar', { message: 'ok', title: 'Edición de Oficina', datos: datos });
});

app.get('/configuracion_oficinas_nueva', async (req, res) => {
    res.render('configuracion_oficinas_nueva', { title: 'Creación de Oficina' });
});

app.get('/cuentas_cobro', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    //console.log('Cuentas Cobro');
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        //console.log('Paso 1');
        //console.log(query);
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('cuentas_cobro', { message: 'error de sesión', title: 'Configuracion de Cuentas de Cobro'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        let query2 = `select    id_cuenta_bancaria,` +
                                `id_oficina,` +
                                `oficina,` +
                                `nombre,` +
                                `alias,` +
                                `cbu,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MM') as fecha_hora_creacion,` +
                                `marca_baja ` +
                        `from v_Cuentas_Bancarias`;
        if (id_rol > 1) {
            query2 = query2 + ` where id_oficina = ${id_oficina}`;
        }
        query2 = query2 + ` order by marca_baja, nombre, alias, cbu`;
        //console.log('Paso 2');
        //console.log(query2);
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('cuentas_cobro', { message: 'No hay Cuentas de Cobro', title: 'Configuracion de Cuentas de Cobro', id_oficina : id_oficina});
            return;
        }
        const datos = result2.rows;

        res.render('cuentas_cobro', { message: 'ok', title: 'Configuracion de Cuentas de Cobro', id_oficina : id_oficina, datos : datos });
    }
    catch (error) {
        res.render('cuentas_cobro', { message: 'error', title: 'Configuracion de Cuentas de Cobro'});
    }
});

app.get('/cuentas_cobro_descargas', async (req, res) => {
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('cuentas_cobro_descargas', { message: 'error de sesión', title: 'Descargas de Cuentas de Cobro'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        let query3 = `select    id_cuenta_bancaria,` +
                                `id_oficina,` +
                                `oficina,` +
                                `nombre,` +
                                `alias,` +
                                `cbu,` +
                                `monto_cargas,` +
                                `cantidad_cargas,` +
                                `marca_baja ` +
                        `from v_Cuenta_Bancaria_Activa`;
        if (id_rol > 1) {
            query3 = query3 + ` where id_oficina = ${id_oficina}`;
        }
        query3 = query3 + ` order by orden desc`;

        const result3 = await db.handlerSQL(query3);
        if (result3.rows.length == 0) {
            res.render('cuentas_cobro_descargas', { message: 'No hay Cuentas de Cobro', title: 'Descargas de Cuentas de Cobro'});
            return;
        }
        datos_cobros = result3.rows;
        
        res.render('cuentas_cobro_descargas', { message: 'ok', title: 'Descargas de Cuentas de Cobro', datos_cobros : datos_cobros });
    }
    catch (error) {
        res.render('cuentas_cobro_descargas', { message: 'error', title: 'Descargas de Cuentas de Cobro'});
    }
});

app.get('/cuentas_cobro_descargas_confirmar', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_cuenta_bancaria = parseInt(req.query.id_cuenta_bancaria, 10);
    res.render('cuentas_cobro_descargas_confirmar', { id_cuenta_bancaria : id_cuenta_bancaria});
});

app.get('/cuentas_cobro_descargas_historial', async (req, res) => {
    const id_cuenta_bancaria = parseInt(req.query.id_cuenta_bancaria, 10);
    try {
        let query3 = `select    nombre,` +
                                `alias,` +
                                `cbu,` +
                                `nombre_aplicacion,` +
                                `id_usuario,` +
                                `usuario,` +
                                `TO_CHAR(fecha_hora_descarga, 'DD/MM/YYYY HH24') as fecha_hora_descarga,` +
                                `cargas_monto,` +
                                `cargas_cantidad ` +
                        `from v_Cuentas_Bancarias_Descargas Where id_cuenta_bancaria = ${id_cuenta_bancaria} ` +
                        `and (fecha_hora_descarga > CURRENT_DATE - INTERVAL '${dias_historial} days') ` +
                        `order by id_cuenta_bancaria_descarga desc;`;

        const result3 = await db.handlerSQL(query3);
        if (result3.rows.length === 0) {
            res.render('cuentas_cobro_descargas_historial', { message: 'No hay Historial', title: 'Historial de Cuenta Bancaria'});
            return;
        }
        datos = result3.rows;
        const nombre = result3.rows[0].nombre;
        const alias = result3.rows[0].alias;
        const cbu = result3.rows[0].cbu;

        res.render('cuentas_cobro_descargas_historial', { message: 'ok', title: 'Historial de Cuenta Bancaria', nombre : nombre, alias : alias, cbu : cbu, datos : datos });
    }
    catch (error) {
        res.render('cuentas_cobro_descargas_historial', { message: 'No hay Historial', title: 'Historial de Cuenta Bancaria'});
    }
});

app.get('/cuentas_cobro_nueva', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_oficina = parseInt(req.query.id_oficina, 10);
    try {
        let query = `select oficina from oficina where id_oficina = ${id_oficina} `;
        const result = await db.handlerSQL(query);
        const oficina = result.rows[0].oficina;

        res.render('cuentas_cobro_nueva', { message: 'ok', title: 'Creación de Cuenta de Cobro', id_oficina : id_oficina, oficina : oficina });
    }
    catch (error) {
        res.render('cuentas_cobro_nueva', { message: 'error', title: 'Creación de Cuenta de Cobro'});
    }
});

app.get('/cuentas_cobro_editar', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_cuenta = parseInt(req.query.id_cuenta, 10);
    try {
        //console.log(`select * from v_Sesion_Bot where orden = 1 and id_operador = ${id_operador};`);

        let query2 = `select    id_cuenta_bancaria,` +
                                `id_oficina,` +
                                `oficina,` +
                                `nombre,` +
                                `alias,` +
                                `cbu,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MM') as fecha_hora_creacion,` +
                                `marca_baja ` +
                        `from v_Cuentas_Bancarias where id_cuenta_bancaria = ${id_cuenta}`;
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length === 0) {
            res.render('cuentas_cobro_editar', { message: 'Cuentas de Cobro no encontrada', title: 'Edición de Cuenta de Cobro'});
            return;
        }
        const datos = result2.rows;

        res.render('cuentas_cobro_editar', { message: 'ok', title: 'Edición de Cuenta de Cobro', datos: datos });
    }
    catch (error) {
        res.render('cuentas_cobro_editar', { message: 'error', title: 'Edición de Cuenta de Cobro'});
    }
});

app.get('/monitoreo_landingweb', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    //console.log('Cuentas Cobro');
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        //console.log('Paso 1');
        //console.log(query);
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('cuentas_cobro', { message: 'error de sesión', title: 'Configuracion de Cuentas de Cobro'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        let query2 = `select    id_cuenta_bancaria,` +
                                `id_oficina,` +
                                `oficina,` +
                                `nombre,` +
                                `alias,` +
                                `cbu,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MM') as fecha_hora_creacion,` +
                                `marca_baja ` +
                        `from v_Cuentas_Bancarias`;
        if (id_rol > 1) {
            query2 = query2 + ` where id_oficina = 0 and id_oficina = ${id_oficina}`;
        }
        query2 = query2 + ` order by marca_baja, nombre, alias, cbu`;
        //console.log('Paso 2');
        //console.log(query2);
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('monitoreo_landingweb', { message: 'No hay Actividad', title: 'Monitoreo LandingWeb', id_oficina : id_oficina});
            return;
        }
        const datos = result2.rows;

        res.render('monitoreo_landingweb', { message: 'ok', title: 'Monitoreo LandingWeb', id_oficina : id_oficina, datos : datos });
    }
    catch (error) {
        res.render('monitoreo_landingweb', { message: 'error', title: 'Monitoreo LandingWeb'});
    }
});

// Páginas Generales
app.post('/modificar_agente/:id_agente/:id_usuario/:password/:estado/:oficina', async (req, res) => {
    const { id_agente, id_usuario, password, estado, oficina } = req.params;
    try {
        const query = `select Modificar_Agente(${id_agente}, ${id_usuario}, '${password}', ${estado}, ${oficina})`;
        const result = await db.handlerSQL(query);
        res.status(201).json({ message: 'Agente Modificado Exitosamente!' });
    } catch (error) {
        res.status(500).json({ message: 'Error al Modificar Agente!' });
    }
});

app.post('/modificar_usuario/:id_usuario_modi/:id_usuario/:password/:estado/:rol/:oficina', async (req, res) => {
    const { id_usuario_modi, id_usuario, password, estado, rol, oficina } = req.params;
    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const query = `select Modificar_Usuario(${id_usuario_modi}, ${id_usuario}, '${hashedPassword}', ${estado}, ${rol}, ${oficina})`;
        const result = await db.handlerSQL(query);
        res.status(201).json({ message: 'Usuario Modificado Exitosamente!' });
    } catch (error) {
        res.status(500).json({ message: 'Error al Modificar Usuario!' });
    }
});

app.post('/registrar_usuario/:id_usuario/:usuario/:password/:id_rol/:id_oficina', async (req, res) => {
    const { id_usuario, usuario, password, id_rol, id_oficina } = req.params;
    try {
        const queryChek = `select * from Obtener_Usuario('${usuario}', false)`;
        const result1 = await db.handlerSQL(queryChek);
        if (result1.rows.length > 0) {
            res.status(201).json({ message: 'El usuario ya existe!' });
            return;
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const query = `select Insertar_Usuario(${id_usuario}, '${usuario}', '${hashedPassword}', ${id_rol}, ${id_oficina})`;
        const result2 = await db.handlerSQL(query);

        res.status(201).json({ message: 'Usuario registrado exitosamente.' });
    } catch (error) {
        res.status(500).json({ message: 'Error al registrar usuario.' });
    }
});

app.post('/registrar_agente/:id_usuario/:usuario/:password/:id_oficina', async (req, res) => {
    const { id_usuario, usuario, password, id_rol, id_oficina } = req.params;
    try {
        const queryChek = `select * from v_Agentes where agente_usuario = '${usuario}';`;
        const result1 = await db.handlerSQL(queryChek);
        if (result1.rows.length > 0) {
            res.status(401).json({ message: 'El usuario ya existe!' });
            return;
        }

        const query = `select Insertar_Agente(${id_usuario}, '${usuario}', '${password}', ${id_oficina})`;
        const result2 = await db.handlerSQL(query);

        res.status(201).json({ message: 'Agente registrado exitosamente.' });
    } catch (error) {
        res.status(500).json({ message: 'Error al registrar Agente.' });
    }
});

app.post('/login', async (req, res) => {
    try {    
        const { username, password, version, ipAddress } = req.body;
        const query = `select * from Obtener_Usuario('${username}', true)`;
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.status(401).json({ message: 'Nombre de usuario incorrecto.' });
            return;
        }
        const user = result.rows[0];
        const isPasswordValid = await bcrypt.compare(password, user.password);
        
        if (isPasswordValid) {
            req.session.id_usuario = user.id_usuario; // Guardar el ID del usuario en la sesión
            const id_token = generarToken(30);
            const consulta2 = `select Modificar_Usuario_Token(${req.session.id_usuario}, '${id_token}', '${ipAddress}')`;
            await db.handlerSQL(consulta2);

            res.status(201).json({ message: 'ok', id_rol: user.id_rol, id_usuario: user.id_usuario, id_token : id_token });
        } else {
            res.status(401).json({ message: 'Contraseña incorrecta.' });
        }
    } catch (error) {
        console.error('Error al buscar usuario:', error);
        res.status(500).json({ message: 'Error al iniciar sesión.' });
    }
});

app.post('/login_token', async (req, res) => {
    try {    
            const { id_usuario, id_token } = req.body;
            const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
            const result = await db.handlerSQL(query);
            if (result.rows.length === 0) {
                res.status(401).json({ message: 'Token o usuario incorrecto.' });
                return;
            }
            const user = result.rows[0];
            res.status(201).json({ message: 'ok', id_rol: user.id_rol });
        }
    catch (error) {
        res.status(500).json({ message: 'token invalido' });
    }
});

app.get('/logout', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    //req.session.destroy();
    //console.log(`Finalización de sesión usuario ${id_usuario} (${id_rol}): '${id_token}'`);
    const cierre = `Select Cerrar_Sesion_Usuario(${id_usuario}, '${id_token}')`;
    await db.handlerSQL(cierre);
});

// para establecer las distintas rutas, necesitamos instanciar el express router
var router = express.Router();        

router.post('/login', async (req, res) => {
    try {    
        const { username, password, version } = req.body;
        if (version == 'web' || version == 'v4') 
        {
            const query = `select * from Obtener_Usuario('${username}', true)`;
            const result = await db.handlerSQL(query);
            if (result.rows.length === 0) {
                res.status(401).json({ message: 'Nombre de usuario incorrecto.' });
                return;
            }
            const user = result.rows[0];
            
            const isPasswordValid = await bcrypt.compare(password, user.password);
            
            if (isPasswordValid) {
                res.status(201).json({ message: user.id_usuario });
            } else {
                res.status(401).json({ message: 'Contraseña incorrecta.' });
            }
        } else {
            res.status(402).json({ message: 'Por Favor Actualizar App PanelesNoti' });
        }
    } catch (error) {
        console.error('Error al buscar usuario:', error);
        res.status(500).json({ message: 'Error al iniciar sesión.' });
    }
});

app.post('/usuarios_clientes_carga_manual/:id_cliente_usuario/:id_operador/:id_bot/:id_usuario/:notificacion_aplicacion/:cliente_usuario/:carga_monto/:carga_bono/:carga_usuario/:carga_cbu/:id_motivo/:observacion', async (req, res) => {
    try {
        const { id_cliente_usuario, id_operador, id_bot, id_usuario, notificacion_aplicacion, cliente_usuario, carga_monto, carga_bono, carga_usuario, carga_cbu, id_motivo, observacion } = req.params;
        //console.log(`select * from bot where id_bot = ${id_bot};`);
        const query = `select * from bot where id_bot = ${id_bot};`;
        const result = await db.handlerSQL(query);
        const query2 = `select * from operador where id_operador = ${id_operador};`;
        const result2 = await db.handlerSQL(query2);
        const pagina_panel_admin = result.rows[0].pagina_panel_admin;
        let usuario_panel_nombre = '';
        let usuario_panel_pass = '';
        if (id_bot == 1) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot1;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot1;
        } else if (id_bot == 2) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot2;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot2;
        } else if (id_bot == 3) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot3;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot3;
        } else if (id_bot == 4) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot4;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot4;
        } else {
            res.status(500).json({ message: 'Error al Identificar Bot' });
        }
        //db.insertLogMessage(`Obtener_Datos_Bot: Panel : ${result.rows[0].usuario_panel_nombre}`);
        const variables_utiles_manual = {
            ADMIN : usuario_panel_nombre,
            ADMIN_PASS : usuario_panel_pass,
            PAGE_NAME : pagina_panel_admin,
            //BRIDGE_PAGE_NAME : 'https://paneles365vip.online',
            LAUNCH_OPTIONS : {  headless: true, executablePath: pahtChromium }};
        const carga_manual1 = require('./scrap_bot1/cargar.js');
        const carga_manual2 = require('./scrap_bot2/cargar.js');
        const carga_manual3 = require('./scrap_bot3/cargar.js');
        const carga_manual4 = require('./scrap_bot4/cargar.js');
        const monto = Number(carga_monto.trim()) + Number(carga_bono.trim());
        //console.log(`Monto carga = ${monto}`);
        let resultado = '';
        if (id_bot == 1) {
            resultado = await carga_manual1(cliente_usuario.trim(), String(monto), variables_utiles_manual);
        } else if (id_bot == 2) {
            resultado = await carga_manual2(cliente_usuario.trim(), String(monto), variables_utiles_manual);
        } else if (id_bot == 3) {
            resultado = await carga_manual3(cliente_usuario.trim(), String(monto), variables_utiles_manual);
        } else if (id_bot == 4) {
            resultado = await carga_manual4(cliente_usuario.trim(), String(monto), variables_utiles_manual);
        } else {
            res.status(500).json({ message: 'Error al Identificar Bot' });
        }
        //console.log(`Resultado carga = ${resultado}`);
        if (resultado === 'ok') {
            const query2 = `select * from Obtener_Sesion_Cliente_Carga_Manual(${id_cliente_usuario},${id_bot},${id_operador});`;
            //console.log(query2);
            const result2 = await db.handlerSQL(query2);
            const id_sesion_cliente = result2.rows[0].id_sesion_cliente;
          
            const query3 = `select * from Registrar_Notificacion('-----',${id_usuario},'${notificacion_aplicacion}','Carga Manual','Usuario: ${cliente_usuario}, Monto: ${carga_monto}','${id_sesion_cliente}-${id_cliente_usuario}', 2)`;
            //console.log(query3);
            const result3 = await db.handlerSQL(query3);
            //console.log('Paso 1');
            if (result3.rows.length > 0) {
                const id_notificacion = result3.rows[0].id_notificacion;
                const query4 = `select * from Registrar_Notificacion_Carga(${id_notificacion},'${carga_usuario}',${carga_monto.trim()})`;
                //console.log(query4);
                const result4 = await db.handlerSQL(query4);
                //console.log('Paso 2');
                if (result4.rows.length > 0) { 
                    //console.log('Paso 2.1');
                    const id_notificacion_carga = result4.rows[0].id_notificacion_carga;
                    //console.log('Paso 2.2');
                    const query5 = `select * from Notificacion_Carga_Manual(${id_sesion_cliente}, ${id_notificacion_carga}, '${carga_cbu}', ${id_motivo}, '${observacion}');`;
                    //console.log(query5);
                    const result5 = await db.handlerSQL(query5);
                    //console.log('Paso 2.3');
                    let observacion_log = '';
                    //console.log('Paso 3');
                    if (Number(carga_bono.trim()) > 0) {
                        //console.log('Paso 3.1');
                        observacion_log = `${cliente_usuario} : ${carga_monto} - BONO : ${carga_bono}`;
                    } else {
                        //console.log('Paso 3.2');
                        observacion_log = `${cliente_usuario} : ${carga_monto}`;
                    }
                    const query6 = `select Registrar_Accion_Sesion_Cliente(${id_sesion_cliente}, 6,'${observacion_log}')`;
                    //console.log(query6);
                    const result6 = await db.handlerSQL(query6);

                    const mensaje = `¡Hola ${cliente_usuario}! 🤖\n ¡El Operador ya cargó tus ${monto} fichas! 😁`;
                    const query7 = `select Mensaje_Usuario_Cliente(${id_cliente_usuario}, '${mensaje}', ${id_usuario})`;
                    //console.log(query);
                    const result = await db.handlerSQL(query7);

                    //console.log('Paso 4');
                    res.status(201).json({ message: 'Carga registrada exitosamente.' });
                } else {
                    res.status(500).json({ message: 'Error al Cargar en Notificación Detalle' });
                }
            } else {
                res.status(500).json({ message: 'Error al Cargar en Notificación' });
            }
        } else if (resultado === 'error') {
            res.status(500).json({ message: 'Error de Scrapping al Cargar' });
        } else if (resultado === 'en_espera') {
            res.status(500).json({ message: 'Servidor con Demora. Por favor, volver a intentar en unos segundos' });
        }
    } catch (error) {
        //console.error('Error al Cargar', error);
        res.status(500).json({ message: 'Error al Cargar' });
    }
});

app.post('/usuarios_clientes_retiro_manual/:id_cliente_usuario/:id_operador/:id_bot/:id_usuario/:cliente_usuario/:carga_monto/:cbu', async (req, res) => {
    try {
        const { id_cliente_usuario, id_operador, id_bot, id_usuario, cliente_usuario, carga_monto, cbu } = req.params;
        //console.log(`select * from bot where id_bot = ${id_bot};`);
        const query = `select * from bot where id_bot = ${id_bot};`;
        const result = await db.handlerSQL(query);
        const query2 = `select * from operador where id_operador = ${id_operador};`;
        const result2 = await db.handlerSQL(query2);
        const pagina_panel_admin = result.rows[0].pagina_panel_admin;
        let usuario_panel_nombre = '';
        let usuario_panel_pass = '';
        if (id_bot == 1) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot1;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot1;
        } else if (id_bot == 2) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot2;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot2;
        } else if (id_bot == 3) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot3;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot3;
        } else if (id_bot == 4) {
            usuario_panel_nombre = result2.rows[0].usuario_panel_nombre_bot4;
            usuario_panel_pass = result2.rows[0].usuario_panel_pass_bot4;
        } else {
            res.status(500).json({ message: 'Error al Identificar Bot' });
        }
        //db.insertLogMessage(`Obtener_Datos_Bot: Panel : ${result.rows[0].usuario_panel_nombre}`);
        const variables_utiles_manual = {
            ADMIN : usuario_panel_nombre,
            ADMIN_PASS : usuario_panel_pass,
            PAGE_NAME : pagina_panel_admin,
            LAUNCH_OPTIONS : {  headless: true, executablePath: pahtChromium }};
        const retiro_manual1 = require('./scrap_bot1/retirar.js');
        const retiro_manual2 = require('./scrap_bot2/retirar.js');
        const retiro_manual3 = require('./scrap_bot3/retirar.js');
        const retiro_manual4 = require('./scrap_bot4/retirar.js');
        let resultado = '';
        if (id_bot == 1) {
            resultado = await retiro_manual1(cliente_usuario.trim(), carga_monto.trim(), variables_utiles_manual);
        } else if (id_bot == 2) {
            resultado = await retiro_manual2(cliente_usuario.trim(), carga_monto.trim(), variables_utiles_manual);
        } else if (id_bot == 3) {
            resultado = await retiro_manual3(cliente_usuario.trim(), carga_monto.trim(), variables_utiles_manual);
        } else if (id_bot == 4) {
            resultado = await retiro_manual4(cliente_usuario.trim(), carga_monto.trim(), variables_utiles_manual);
        } else {
            res.status(500).json({ message: 'Error al Identificar Bot' });
        }
        //console.log(`Resultado carga = ${resultado}`);
        if (resultado === 'ok') {
            const query3 = `select * from Obtener_Sesion_Cliente_Carga_Manual(${id_cliente_usuario},${id_bot},${id_operador});`;
            //console.log(query2);
            const result3 = await db.handlerSQL(query3);
            const id_sesion_cliente = result3.rows[0].id_sesion_cliente;

            const query4 = `select Registrar_Accion_Sesion_Cliente(${id_sesion_cliente}, 9,'${cliente_usuario} - Monto : ${carga_monto} - CBU : ${cbu}')`;
            //console.log(query6);
            const result4 = await db.handlerSQL(query4);

            res.status(201).json({ message: 'Retiro registrado exitosamente.' });
        } else if (resultado === 'faltante') {
            res.status(201).json({ message: '¡¡El usuario no tiene suficientes fichas!!' });
        } else {
            res.status(500).json({ message: 'Error Scrapping al Retirar Fichas' });
        }
    } catch (error) {
        //console.error('Error al Retirar Fichas', error);
        res.status(500).json({ message: 'Error al Retirar Fichas' });
    }
});

app.post('/crear_cuenta_bancaria/:id_oficina/:id_usuario/:nombre/:alias/:cbu/:estado', async (req, res) => {
    try {    
            const { id_oficina, id_usuario, nombre, alias, cbu, estado } = req.params;
            let alias_aux  = '';
            if (alias !== 'XXXXX') {
                alias_aux = alias;
            }
            const query = `select * from Crear_Cuenta_Bancaria(${id_oficina}, ${id_usuario}, '${nombre}', '${alias_aux}', '${cbu}' , ${estado})`;
            //console.log(query);
            const result = await db.handlerSQL(query);
            if (result.rows[0].id_cuenta_bancaria == 0) {
                res.status(401).json({ message: `Cuenta ${alias_aux} - ${cbu} ya existe` });
            } else {
                res.status(201).json({ message: `Cuenta ${alias_aux} - ${cbu} creada` });
            }
        }
    catch (error) {
        //console.log('crear cta bancaria nook');
        res.status(500).json({ message: 'Error al Crear Cuenta Bancaria' });
    }
});
       
app.post('/descargar_cuenta_bancaria/:id_usuario/:id_cuenta_bancaria', async (req, res) => {
    try {    
            const { id_usuario, id_cuenta_bancaria } = req.params;
            const query = `select * from Descargar_Cuenta_Bancaria(${id_usuario}, ${id_cuenta_bancaria})`;
            //console.log(query);
            const result = await db.handlerSQL(query);
            const r_cbu = result.rows[0].cbu;
            const r_cantidad = result.rows[0].cargas_cantidad;
            const r_monto = result.rows[0].cargas_monto;
            if (r_cantidad == 0) {
                res.status(401).json({ message: `Cuenta CBU ${r_cbu} NO Tiene Cargas!` });
            } else {
                res.status(201).json({ message: `Cuenta CBU ${r_cbu} Descargó $ ${r_monto} Con ${r_cantidad} Cargas!`});
            }
        }
    catch (error) {
        //console.log('crear cta bancaria nook');
        res.status(500).json({ message: 'Error al Descargar Cuenta Bancaria' });
    }
});

app.post('/modificar_cuenta_bancaria/:id_usuario_modi/:id_usuario/:id_cuenta_bancaria/:nombre/:alias/:cbu/:estado', async (req, res) => {
    try {    
            const { id_usuario, id_cuenta_bancaria, nombre, alias, cbu, estado } = req.params;
            let alias_aux  = '';
            if (alias != 'XXXXX') {
                alias_aux = alias;
            }
            let alertaInactivas = 0;
            //console.log(`Estado = ${estado}`);
            if (estado == 'true') {
                const query0 = `select count(*) as cantidad ` +
                                `from cuenta_bancaria ` +
                                `where id_oficina in  ` +
                                `(select id_oficina from  ` +
                                `cuenta_bancaria where id_cuenta_bancaria = ${id_cuenta_bancaria}) ` +
                                `and marca_baja = false and id_cuenta_bancaria != ${id_cuenta_bancaria}`;
                //console.log(query0);
                const result0 = await db.handlerSQL(query0);
                console.log(result0.rows[0].cantidad);
                if (result0.rows[0].cantidad == 0) {
                    alertaInactivas = 1;
                }
            } 
            //console.log(alertaInactivas);
            if (alertaInactivas == 0) {
                const query = `select * from Modificar_Cuenta_Bancaria(${id_usuario}, ${id_cuenta_bancaria}, '${nombre}', '${alias_aux}', '${cbu}', ${estado})`;
                //console.log(query);
                const result = await db.handlerSQL(query);
                if (result.rows[0].id_cuenta_bancaria == 0) {
                    res.status(401).json({ message: `Cuenta ${alias_aux} - ${cbu} ya existe` });
                } else {
                    res.status(201).json({ message: `Cuenta ${alias_aux} - ${cbu} modificada` });
                }
            } else {
                res.status(401).json({ message: `¡Siempre debe quedar al menos una Cuenta Activa en la Oficina!` });
            }
        }
    catch (error) {
        //console.log('modif cta bancaria nook');
        res.status(500).json({ message: 'Error al Modificar Cuenta Bancaria' });
    }
});
 
app.post('/modificar_oficina/:id_usuario/:id_oficina/:oficina/:contactoWhatsapp/:contactoTelegram/:estado/:bonoPrimeraCarga/:bonoCargaPerpetua/:minimoCarga/:minimoRetiro/:minimoEsperaRetiro', async (req, res) => {
    try {    
            let { id_usuario, id_oficina , oficina, contactoWhatsapp, contactoTelegram, estado, bonoPrimeraCarga, bonoCargaPerpetua, minimoCarga, minimoRetiro, minimoEsperaRetiro } = req.params;
            contactoTelegram = contactoTelegram.replace('<<','/');
            const query = `select Modificar_Oficina(${id_oficina}, ${id_usuario}, '${oficina}', '${contactoWhatsapp}', '${contactoTelegram}', ${estado}, ${bonoPrimeraCarga}, ${bonoCargaPerpetua}, ${minimoCarga}, ${minimoRetiro}, ${minimoEsperaRetiro})`;
            //console.log(query);
            const result = await db.handlerSQL(query);
            res.status(201).json({ message: 'Oficina Modificada' });
        }
    catch (error) {
        //console.log('baja cliente nook');
        res.status(500).json({ message: 'Error al Modificar Oficina' });
    }
});

app.post('/crear_oficina/:id_usuario/:operador/:numeroOperador/:linkOperadorTelegram/:linkCanalTelegram/:estado/:bonoInicial/:bonoPrimeraCarga/:bonoRecupero/:bonoCargaPerpetua/:minimoCarga/:minimoRetiro/:minimoEsperaRetiro/:diasRecuperoUltimo/:diasRecuperoMensaje/:usuarioPanelNombreBot1/:usuarioPanelPassBot1/:usuarioPanelNombreBot2/:usuarioPanelPassBot2/:usuarioPanelNombreBot3/:usuarioPanelPassBot3/:usuarioPanelNombreBot4/:usuarioPanelPassBot4', async (req, res) => {
    try {    
            let { id_usuario , operador, numeroOperador, linkOperadorTelegram, linkCanalTelegram, estado, bonoInicial, bonoPrimeraCarga, bonoRecupero, bonoCargaPerpetua, minimoCarga, minimoRetiro, minimoEsperaRetiro, diasRecuperoUltimo, diasRecuperoMensaje, usuarioPanelNombreBot1, usuarioPanelPassBot1, usuarioPanelNombreBot2, usuarioPanelPassBot2, usuarioPanelNombreBot3, usuarioPanelPassBot3, usuarioPanelNombreBot4, usuarioPanelPassBot4 } = req.params;
            numeroOperador = numeroOperador.replace('<<','/');
            linkOperadorTelegram = linkOperadorTelegram.replace('<<','/');
            linkCanalTelegram = linkCanalTelegram.replace('<<','/');
            const query = `select * from Insertar_Operador(${id_usuario}, '${operador}', '${numeroOperador}', ${estado}, ${bonoInicial}, ${bonoPrimeraCarga}, ${bonoRecupero}, ${bonoCargaPerpetua}, ${minimoCarga}, ${minimoRetiro}, ${minimoEsperaRetiro}, ${diasRecuperoUltimo}, ${diasRecuperoMensaje}, '${usuarioPanelNombreBot1}', '${usuarioPanelPassBot1}', '${usuarioPanelNombreBot2}', '${usuarioPanelPassBot2}', '${usuarioPanelNombreBot3}', '${usuarioPanelPassBot3}', '${usuarioPanelNombreBot4}', '${usuarioPanelPassBot4}')`;
            console.log(query);
            const result = await db.handlerSQL(query);
            if (result.rows[0].id_operador == 0) {
                res.status(401).json({ message: `Oficina ${operador} ya existe` });
            } else {
                res.status(201).json({ message: `Oficina ${operador} ya creada` });
            }
        }
    catch (error) {
        //console.log('baja cliente nook');
        res.status(500).json({ message: 'Error al Crear Oficina' });
    }
});

function generarToken(length) {
    const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let token = '';
    for (let i = 0; i < length; i++) {
      const indice = Math.floor(Math.random() * caracteres.length);
      token += caracteres.charAt(indice);
    }
    return token;
  }