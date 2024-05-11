const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const session = require('express-session');
const bcrypt = require('bcrypt');
const db = require(__dirname + '/db');
const ejs = require('ejs');
const axios = require('axios');
const { Console } = require('console');
const multer  = require('multer');
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

app.get('/tokens_ayuda', async (req, res) => {
    res.render('tokens_ayuda', { title: 'Tutorial de Tokens de Registro' });
});

app.get('/usuarios_ayuda', async (req, res) => {
    res.render('usuarios_ayuda', { title: 'Tutorial de Usuarios' });
});

app.get('/usuarios_clientes_ayuda', async (req, res) => {
    res.render('usuarios_clientes_ayuda', { title: 'Tutorial de Clientes' });
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

app.get('/monitoreo_landingweb_ayuda', async (req, res) => {
    res.render('monitoreo_landingweb_ayuda', { title: 'Monitoreo de Solicitudes' });
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

app.get('/usuarios_clientes', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    // const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('agentes', { message: 'error de sesión', title: 'Clientes'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        const id_rol = result.rows[0].id_rol;
        let query2 = `select    id_cliente,` +
                                `cliente_usuario,` +
                                `cliente_password,` +
                                `bloqueado,` +
                                `id_agente,` +
                                `agente_usuario, ` +
                                `id_plataforma,` +
                                `plataforma, ` +
                                `id_oficina,` +
                                `oficina,` +
                                `visto_cliente,` +
                                `visto_operador ` +
                        `from v_Clientes`;
        if (result.rows[0].id_rol > 1) {
            query2 = query2 + ` where id_oficina = ${id_oficina}`;
        }
        query2 = query2 + ` order by ult_operacion desc`;
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('usuarios_clientes', { message: 'No hay Clientes', title: 'Clientes'});
            return;
        }
        const datos = result2.rows;
        res.render('usuarios_clientes', { message: 'ok', title: 'Clientes', datos: datos, id_rol: id_rol});
    }
    catch (error) {
        res.render('usuarios_clientes', { message: 'error', title: 'Clientes'});
    }
});

app.get('/usuarios_clientes_info', async (req, res) => {
    try 
    {
        // Obtener los parámetros de la URL
        const id_cliente = parseInt(req.query.id_cliente, 10);
        const query2 = `select id_cliente,` +
                                `cliente_usuario,` +
                                `cliente_password,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI') as fecha_hora_creacion,` +
                                `correo_electronico, ` +
                                `telefono, ` +
                                `id_token, ` +
                                `ingresos, ` +
                                `registros, ` +
                                `cargaron, ` +
                                `total_cargas, ` +
                                `total_importe, ` +
                                `total_bono, ` +
                                `id_registro_token, ` +
                                `de_agente, ` +
                                `cliente_referente ` +
                        `from v_Cliente_Registro where id_cliente = ${id_cliente}`;
        
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('usuarios_clientes_info', { message: 'Cliente No encontrado', title: 'Información de Registro'});
            return;
        }
        const datos = result2.rows[0];

        const query3 = `select ip,` +
                            `moneda,` +
                            `monto,` +
                            `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
                            `fecha_hora_cierre ` +
                        `from v_Clientes_Sesiones where id_cliente = ${id_cliente} ` +
                        `order by id_cliente_sesion desc`;

        const result3 = await db.handlerSQL(query3);
        const datos_sesiones = result3.rows;

        //console.log(datos);
        res.render('usuarios_clientes_info', { message: 'ok', title: 'Información de Registro', datos : datos, datos_sesiones : datos_sesiones });
    }
    catch (error) {
        res.render('usuarios_clientes_info', { message: 'error', title: 'Información de Registro'});
    }
});

app.get('/usuarios_clientes_chat', async (req, res) => {
    try 
    {
        // Obtener los parámetros de la URL
        const id_cliente = parseInt(req.query.id_cliente, 10);
        const query0 = `select cliente_usuario, en_sesion from cliente where id_cliente = ${id_cliente};`;
        //console.log(query);
        const result0 = await db.handlerSQL(query0);
        const en_sesion = result0.rows[0].en_sesion;
        const chat_title = 'Chat con Cliente ' + result0.rows[0].cliente_usuario;

        const query = `select id_cliente_chat,` +
                                `id_cliente, ` +
                                `mensaje, ` +
                                `nombre_original, ` +
                                `nombre_guardado, ` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY') as fecha_mensaje,` +
                                `TO_CHAR(fecha_hora_creacion, 'HH24:MI') as horario_mensaje, ` +
                                `enviado_cliente, ` +
                                `visto_cliente, ` +
                                `visto_operador, ` +
                                `id_usuario, ` +
                                `usuario, ` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY') = LAG(TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY')) ` +
                                `OVER (ORDER BY fecha_hora_creacion) AS misma_fecha ` +
                        `from Obtener_Cliente_Chat(${id_cliente}, false);`;
        //console.log(query);
        const result = await db.handlerSQL(query);
        const datos = result.rows;
        //console.log(datos);
        res.render('usuarios_clientes_chat', { message: 'ok', title: chat_title, id_cliente : id_cliente, datos : datos, en_sesion : en_sesion });
    }
    catch (error) {
        res.render('usuarios_clientes_chat', { message: 'error', title: 'Chat'});
    }
});

app.get('/usuarios_clientes_chat_detalle', async (req, res) => {
    try 
    {
        // Obtener los parámetros de la URL
        const id_cliente = parseInt(req.query.id_cliente, 10);
        const id_usuario = parseInt(req.query.id_usuario, 10);
        const mensaje_operador = req.query.mensaje.replace('<<','/');

        let query = `select id_cliente_chat,` +
                                `id_cliente, ` +
                                `mensaje, ` +
                                `nombre_original, ` +
                                `nombre_guardado, ` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY') as fecha_mensaje,` +
                                `TO_CHAR(fecha_hora_creacion, 'HH24:MI') as horario_mensaje, ` +
                                `enviado_cliente, ` +
                                `visto_cliente, ` +
                                `visto_operador, ` +
                                `id_usuario, ` +
                                `usuario, ` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY') = LAG(TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY')) ` +
                                `OVER (ORDER BY fecha_hora_creacion) AS misma_fecha `;
        
        if (mensaje_operador == '') {        
            query = query + `from Obtener_Cliente_Chat(${id_cliente}, false);`;
        } else {        
            query = query + `from Insertar_Cliente_Chat(${id_cliente}, false, '${mensaje_operador}', ${id_usuario});`;
        }
        //console.log(query);
        const result = await db.handlerSQL(query);
        const datos = result.rows;
        //console.log(datos);
        res.render('usuarios_clientes_chat_detalle', { message: 'ok', datos : datos });
    }
    catch (error) {
        res.render('usuarios_clientes_chat_detalle', { message: 'sin mensajes' });
    }
});

app.get('/usuarios_clientes_bloqueo', async (req, res) => {
    try 
    {
        // Obtener los parámetros de la URL
        const id_cliente = parseInt(req.query.id_cliente, 10);
        const query2 = `select id_cliente,` +
                                `bloqueado ` +
                        `from v_Clientes where id_cliente = ${id_cliente}`;
        
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('usuarios_clientes_bloqueo', { message: 'error', title : 'Cliente No encontrado', title: 'Bloqueo de Clientes'});
            return;
        }
        const bloqueado = result2.rows[0].bloqueado;
        //console.log(datos);
        res.render('usuarios_clientes_bloqueo', { message: 'ok', title: 'Bloqueo de Clientes', id_cliente : id_cliente, bloqueado : bloqueado });
    }
    catch (error) {
        res.render('usuarios_clientes_bloqueo', { message: 'error', title: 'Bloqueo de Clientes'});
    }
});

app.get('/usuarios_clientes_carga', async (req, res) => {
    try 
    {
        // Obtener los parámetros de la URL
        const id_cliente = parseInt(req.query.id_cliente, 10);
        const query2 = `select id_cliente,` +
                                `cliente_usuario,` +
                                `agente_usuario, ` +
                                `plataforma, ` +
                                `id_oficina, ` +
                                `oficina ` +
                        `from v_Clientes where id_cliente = ${id_cliente}`;
        
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('usuarios_clientes_carga', { message: 'Cliente No encontrado', title: 'Carga de Fichas'});
            return;
        }
        const datos = result2.rows[0];
        
        const query3 = `select id_cuenta_bancaria, ` +
                                `nombre || ' - ' || alias || ' - ' || cbu as cuenta_bancaria ` +
                        `from v_Cuentas_Bancarias where id_oficina = ${datos.id_oficina} and marca_baja = false`;
        const result3 = await db.handlerSQL(query3);

        if (result3.rows.length == 0) {
            res.render('usuarios_clientes_carga', { message: 'error', title: 'No Hay Cuentas Bancarias Disponibles!'});
            return;
        }
        const datos_cuentas = result3.rows;

        //console.log(datos);
        res.render('usuarios_clientes_carga', { message: 'ok', title: 'Carga de Fichas', datos : datos, datos_cuentas : datos_cuentas });
    }
    catch (error) {
        res.render('usuarios_clientes_carga', { message: 'error', title: 'Carga de Fichas'});
    }
});

app.get('/usuarios_clientes_retiro', async (req, res) => {
    try 
    {
        // Obtener los parámetros de la URL
        const id_cliente = parseInt(req.query.id_cliente, 10);
        const query2 = `select id_cliente,` +
                                `cliente_usuario,` +
                                `agente_usuario, ` +
                                `plataforma, ` +
                                `id_oficina, ` +
                                `oficina ` +
                        `from v_Clientes where id_cliente = ${id_cliente}`;
        
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('usuarios_clientes_retiro', { message: 'Cliente No encontrado', title: 'Retiro de Fichas'});
            return;
        }
        const datos = result2.rows[0];

        //console.log(datos);
        res.render('usuarios_clientes_retiro', { message: 'ok', title: 'Retiro de Fichas', datos : datos });
    }
    catch (error) {
        res.render('usuarios_clientes_retiro', { message: 'error', title: 'Retiro de Fichas'});
    }
});

app.get('/tokens', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query = `select * from Obtener_Usuario_Token(${id_usuario},'${id_token}')`;
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('agentes', { message: 'error de sesión', title: 'Tokens de Registro'});
            return;
        }
        const id_oficina = result.rows[0].id_oficina;
        let query2 = `select    id_registro_token,` +
                                `id_token,` +
                                `activo,` +
                                `id_oficina,` +
                                `oficina,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `url_juegos,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `de_agente,` +
                                `bono_creacion,` +
                                `bono_carga_1,` +
                                `ingresos,` +
                                `registros,` +
                                `cargaron,` +
                                `total_cargas,` +
                                `total_importe,` +
                                `total_bono ` +
                        `from v_Tokens_Completo`;
        if (result.rows[0].id_rol > 1) {
            query2 = query2 + ` where id_oficina = ${id_oficina}`;
        }
        query2 = query2 + ` order by cargaron desc, registros desc, ingresos desc, plataforma`;
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('tokens', { message: 'No hay Tokens de Registro', title: 'Tokens de Registro', id_rol : id_rol, id_oficina : id_oficina});
            return;
        }
        const datos = result2.rows;
        res.render('tokens', { message: 'ok', title: 'Tokens de Registro', datos: datos, id_rol : id_rol, id_oficina : id_oficina});
    }
    catch (error) {
        res.render('tokens', { message: 'error', title: 'Tokens de Registro'});
    }
});

app.get('/tokens_ver', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_agente = parseInt(req.query.id_agente, 10);
    const id_rol = parseInt(req.query.id_rol, 10);
    try {
        const query2 = `select  id_registro_token,` +
                                `id_token,` +
                                `agente_usuario,` +
                                `cliente_usuario,` +
                                `activo,` +
                                `bono_carga_1,` +
                                `ingresos,` +
                                `registros,` +
                                `cargaron,` +
                                `total_cargas,` +
                                `total_importe,` +
                                `total_bono ` +
                        `from v_Tokens_Completo_Clientes where id_agente = ${id_agente} ` +
                        `order by cargaron desc, registros desc, ingresos desc`;
        //console.log(query2);
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('tokens_ver', { message: 'No hay Tokens de Registro', title: 'Tokens de Registro de Clientes', id_rol : id_rol, id_oficina : id_oficina});
            return;
        }
        const datos = result2.rows;
        res.render('tokens_ver', { message: 'ok', title: 'Tokens de Registro de Clientes', datos: datos, id_rol : id_rol});
    }
    catch (error) {
        res.render('tokens_ver', { message: 'error', title: 'Tokens de Registro de Clientes'});
    }
});

app.get('/tokens_nuevo', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_oficina = req.query.id_oficina;
    const id_rol = req.query.id_rol;
    try {
        let query2 = `select    id_agente,` +
                                `Concat(oficina, ' - ', plataforma, ' - ', agente_usuario) as agente ` +
                        `from v_Agentes where marca_baja = false`;
        if (id_rol > 1) {
            query2 = query2 + ` and id_oficina = ${id_oficina}`;
        }
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('tokens_nuevo', { message: 'Token Inexistente', title: 'Creación de Token'});
            return;
        }
        const datos = result2.rows;
        res.render('tokens_nuevo', { message: 'ok', title: 'Creación de Token', datos: datos});
    }
    catch (error) {
        res.render('tokens_nuevo', { message: 'error', title: 'Creación de Token'});
    }
});


app.get('/tokens_editar', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_token = req.query.id_token;
    try {
        const query2 = `select    id_registro_token,` +
                                `id_token,` +
                                `activo,` +
                                `bono_creacion,` +
                                `bono_carga_1,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `id_oficina,` +
                                `oficina,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `url_juegos,` +
                                `observaciones ` +
                        `from v_Tokens where id_registro_token = ${id_token}`;
        
        const result2 = await db.handlerSQL(query2);
        //console.log(query2);
        if (result2.rows.length == 0) {
            res.render('tokens_editar', { message: 'Token Inexistente', title: 'Edición de Token'});
            return;
        }
        const datos = result2.rows[0];
        res.render('tokens_editar', { message: 'ok', title: 'Edición de Token', datos: datos});
    }
    catch (error) {
        res.render('tokens_editar', { message: 'error', title: 'Edición de Token'});
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
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
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
    try
    {
        // Obtener los parámetros de la URL
        const id_agente = parseInt(req.query.id_agente, 10);
        const id_rol = parseInt(req.query.id_rol, 10);
        let query2 = `select    id_agente,` +
                                `agente_usuario,` +
                                `agente_password,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
                                `marca_baja,` +
                                `tokens_bono_carga_1,` +
                                `tokens_bono_creacion,` +
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
                tokens_bono_carga_1 : result2.rows[0].tokens_bono_carga_1,
                tokens_bono_creacion : result2.rows[0].tokens_bono_creacion,
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

        const query4 = `select id_plataforma, plataforma from v_Plataformas where marca_baja = false`;
        const result4 = await db.handlerSQL(query4);
        const datos_plataforma = result4.rows;

        //console.log(datos);
        res.render('agentes_editar', { message: 'ok', title: 'Edición de Agente', datos: datos, datos_oficina : datos_oficina, id_rol : id_rol, datos_plataforma : datos_plataforma });
    }
    catch (error) {
        res.render('agentes_editar', { message: 'error', title: 'Edición de Agente'});
    }
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

        const query4 = `select id_plataforma, plataforma from v_Plataformas where marca_baja = false`;
        const result4 = await db.handlerSQL(query4);
        const datos_plataforma = result4.rows;


        res.render('agentes_nuevo', { message: 'ok', title: 'Creación de Agente', datos_oficina : datos_oficina, datos_plataforma : datos_plataforma });
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
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
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
                            `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
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
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
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
                            `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
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
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
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
                                `id_usuario,` +
                                `usuario,` +
                                `TO_CHAR(fecha_hora_descarga, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_descarga,` +
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
                                `TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_creacion,` +
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

app.get('/monitoreo_landingweb_retiro', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_operacion = parseInt(req.query.id_operacion, 10);
    const id_oficina = parseInt(req.query.id_oficina, 10);
    try {
        const query = `select    id_cliente,` +
                                `cliente_usuario,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `id_oficina,` +
                                `oficina,` +
                                `id_operacion,` +
                                `codigo_operacion,` +
                                `id_estado,` +
                                `estado,` +
                                `TO_CHAR(fecha_hora_operacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_operacion,` +
                                `retiro_importe,` +
                                `retiro_titular, ` +
                                `retiro_cbu ` +
        `from v_Clientes_Operaciones where id_operacion = ${id_operacion}`;
        
        const result = await db.handlerSQL(query);
        if (result.rows.length === 0) {
            res.render('monitoreo_landingweb_retiro', { message: 'Operacion no encontrada', title: 'Verificación de Retiro'});
            return;
        }
        const datos = result.rows;

        res.render('monitoreo_landingweb_retiro', { message: 'ok', title: 'Verificación de Retiro', datos: datos });
    }
    catch (error) {
        res.render('monitoreo_landingweb_retiro', { message: 'error', title: 'Verificación de Retiro'});
    }
});

app.get('/monitoreo_landingweb_carga', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_operacion = parseInt(req.query.id_operacion, 10);
    const id_oficina = parseInt(req.query.id_oficina, 10);
    try {
        const query = `select    id_cliente,` +
                                `cliente_usuario,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `id_oficina,` +
                                `oficina,` +
                                `id_operacion,` +
                                `codigo_operacion,` +
                                `id_estado,` +
                                `estado,` +
                                `TO_CHAR(fecha_hora_operacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_operacion,` +
                                `carga_importe,` +
                                `carga_bono, ` +
                                `carga_titular, ` +
                                `carga_id_cuenta_bancaria ` +
        `from v_Clientes_Operaciones where id_operacion = ${id_operacion}`;
        
        const result = await db.handlerSQL(query);
        if (result.rows.length === 0) {
            res.render('monitoreo_landingweb_carga', { message: 'Operacion no encontrada', title: 'Verificación de Carga'});
            return;
        }
        const datos = result.rows;
        const id_cliente = result.rows[0].id_cliente;

        const query2 = `select   id_cuenta_bancaria,` +
                                `nombre || ' - ' || alias || ' - ' || cbu as cuenta_bancaria ` +
        `from v_Cuentas_Bancarias where marca_baja = false and id_oficina = ${id_oficina}`;
        const result2 = await db.handlerSQL(query2);
        const datos_cuentas = result2.rows;

        let fecha_ult_carga_titular = '';
        const query3 = `select TO_CHAR(fecha_hora_operacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_operacion ` +
                        `from v_Clientes_Operaciones where id_oficina = ${id_oficina} ` +
                        `and id_estado = 2 and id_accion in (1,5) ` +
                        `and carga_importe = ${datos[0].carga_importe} ` +
                        `and LOWER(carga_titular) = LOWER('${datos[0].carga_titular}') ` +
                        `order by fecha_hora_operacion desc limit 1`;
        //console.log(query3);
        const result3 = await db.handlerSQL(query3);
        if (result3.rows.length > 0) {
            fecha_ult_carga_titular = result3.rows[0].fecha_hora_operacion;
        } else {
            fecha_ult_carga_titular = '(Sin Registro)';
        }

        const query4 = `select id_cliente_usuario_referente, cliente_usuario_referente, cantidad_cargas ` +
                        `from v_Clientes_Cargas where id_cliente = ${id_cliente}`;
        //console.log(query4);
        const result4 = await db.handlerSQL(query4);
        let datos_referente = '';
        if (result4.rows.length > 0) {
            datos_referente = result4.rows[0];
        }

        res.render('monitoreo_landingweb_carga', { message: 'ok', 
                                                    title: 'Verificación de Carga', 
                                                    datos: datos, 
                                                    datos_cuentas : datos_cuentas, 
                                                    fecha_ult_carga_titular : fecha_ult_carga_titular, 
                                                    datos_referente : datos_referente });
    }
    catch (error) {
        res.render('monitoreo_landingweb_carga', { message: 'error', title: 'Verificación de Carga'});
    }
});

app.get('/monitoreo_landingweb', async (req, res) => {
    // Obtener los parámetros de la URL
    const id_usuario = parseInt(req.query.id_usuario, 10);
    const id_token = req.query.id_token;
    const id_rol = parseInt(req.query.id_rol, 10);
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
        let query2 = `select    id_cliente,` +
                                `cliente_usuario,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `id_oficina,` +
                                `oficina,` +
                                `id_operacion,` +
                                `codigo_operacion,` +
                                `id_estado,` +
                                `estado,` +
                                `id_accion,` +
                                `accion,` +
                                `cliente_confianza,` +
                                `TO_CHAR(fecha_hora_operacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_operacion,` +
                                `TO_CHAR(fecha_hora_proceso, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_proceso,` +
                                `TO_CHAR(retiro_importe, '999,999,999,999') as retiro_importe_formato,` +
                                `retiro_importe,` +
                                `retiro_cbu,` +
                                `retiro_titular,` +
                                `TO_CHAR(carga_importe + carga_bono, '999,999,999,999') as carga_importe_total_formato,` +
                                `TO_CHAR(carga_importe, '999,999,999,999') as carga_importe_formato,` +
                                `TO_CHAR(carga_bono, '999,999,999,999') as carga_bono_formato,` +
                                `carga_importe,` +
                                `carga_bono, ` +
                                `carga_titular, ` +
                                `carga_observaciones ` +
                        `from v_Clientes_Operaciones where marca_baja = false`;
        if (id_rol > 1) {
            query2 = query2 + ` and id_oficina = ${id_oficina}`;
        }
        query2 = query2 + ` order by id_operacion desc`;
        //console.log('Paso 2');
        //console.log(query2);
        const result2 = await db.handlerSQL(query2);
        if (result2.rows.length == 0) {
            res.render('monitoreo_landingweb', { message: 'No hay Actividad', title: 'Monitoreo LandingWeb', id_oficina : id_oficina});
            return;
        }
        const datos = result2.rows;

        //console.log('Paso 3');
        res.render('monitoreo_landingweb', { message: 'ok', title: 'Monitoreo LandingWeb', id_oficina : id_oficina, datos : datos });
    }
    catch (error) {
        res.render('monitoreo_landingweb', { message: 'error', title: 'Monitoreo LandingWeb'});
    }
});

app.get('/monitoreo_landingweb_detalle', async (req, res) => {
    try {
        // Obtener los parámetros de la URL
        const id_operacion = parseInt(req.query.id_operacion, 10);
        const query = `select    id_cliente,` +
                                `cliente_usuario,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `id_plataforma,` +
                                `plataforma,` +
                                `id_oficina,` +
                                `oficina,` +
                                `id_operacion,` +
                                `codigo_operacion,` +
                                `id_estado,` +
                                `estado,` +
                                `id_accion,` +
                                `accion,` +
                                `usuario,` +
                                `TO_CHAR(fecha_hora_operacion, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_operacion,` +
                                `TO_CHAR(fecha_hora_proceso, 'DD/MM/YYYY HH24:MI:SS') as fecha_hora_proceso,` +
                                `retiro_importe,` +
                                `retiro_cbu, ` +
                                `retiro_titular, ` +
                                `retiro_observaciones, ` +
                                `carga_importe,` +
                                `carga_bono, ` +
                                `carga_titular, ` +
                                `carga_cuenta_bancaria, ` +
                                `carga_observaciones ` +
                        `from v_Clientes_Operaciones where id_operacion = ${id_operacion}`;
        //console.log('Paso 2');
        //console.log(query2);
        const result = await db.handlerSQL(query);
        if (result.rows.length == 0) {
            res.render('monitoreo_landingweb_detalle', { message: 'No hay Detalle', title: 'Operacion Detalle'});
            return;
        }
        const datos = result.rows;

        //console.log('Paso 3');
        res.render('monitoreo_landingweb_detalle', { message: 'ok', title: 'Operacion Detalle', datos : datos });
    }
    catch (error) {
        res.render('monitoreo_landingweb_detalle', { message: 'error', title: 'Operacion Detalle'});
    }
});

// Páginas Generales
app.post('/alerta_usuarios_clientes/:id_cliente/:id_usuario', async (req, res) => {
    try {
        let { id_cliente, id_usuario } = req.params;
        const query = `select id_cliente from Alerta_Cliente_Usuario(${id_cliente}, ${id_usuario})`;
        const result = await db.handlerSQL(query);
        result.rows[0].id_cliente;
        if (result.rows[0].id_cliente > 0) {
            res.status(201).json({ message: `ok`});
        } else {
            res.status(201).json({ message: `nook`});
        }
    } catch (error) {
        res.status(500).json({ message: 'error' });
    }
});

app.post('/cargar_retiro_manual/:id_cliente/:id_usuario/:monto_importe/:cbu/:titular/:observacion', async (req, res) => {
    try {
        let { id_cliente, id_usuario, monto_importe, cbu, titular, observacion } = req.params;
        observacion = observacion.replace('<<','/');
        titular = titular.replace('<<','/');
        const query = `select    id_cliente,` +
                                `cliente_usuario,` +
                                `agente_usuario,` +
                                `agente_password,` +
                                `id_plataforma ` +
                        `from v_Clientes where id_cliente = ${id_cliente}`;
        const result = await db.handlerSQL(query);

        const cliente_usuario = result.rows[0].cliente_usuario;
        const agente_nombre = result.rows[0].agente_usuario;
        const agente_password = result.rows[0].agente_password;

        let resultado = '';
        if (result.rows[0].id_plataforma == 1) {
            const retiro_manual3 = require('./scrap_bot3/retirar.js');
            resultado = await retiro_manual3(cliente_usuario.trim(), String(monto_importe), agente_nombre, agente_password);
        }
        //console.log(`Resultado carga = ${resultado}`);
        if (resultado == 'ok')
        {
            const query3 = `select * from Registrar_Retiro_Manual(${id_cliente}, ${id_usuario}, ${monto_importe}, '${cbu}', '${titular}', '${observacion}')`;
            const result3 = await db.handlerSQL(query3);
            const codigo_operacion = result3.rows[0].codigo_operacion;
            if (codigo_operacion != 0) {
                res.status(201).json({ codigo: 1 , message: `Retiro Registrado con Éxito! Código de Operación: ${codigo_operacion}`});
            } else {
                res.status(201).json({ codigo: 2 , message: `Error en la Operación de Retiro!`});
            }
        } else if (resultado === 'error') {
            res.status(500).json({ codigo: 3 , message: 'Error al Retirar Fichas' });
        } else if (resultado === 'en_espera') {
            res.status(500).json({ codigo: 4 , message: 'Servidor con Demora. Por favor, volver a intentar en unos segundos' });
        } else if (resultado === 'faltante') {
            res.status(201).json({ codigo: 5 , message: 'Saldo Insuficiente!' });
        }   
    } catch (error) {
        res.status(500).json({ codigo: 6 , message: 'Error al Registrar Retiro!' });
    }
});

app.post('/cargar_cobro_manual/:id_cliente/:id_usuario/:monto_importe/:monto_bono/:titular/:id_cuenta_bancaria/:observacion', async (req, res) => {
    try {
        let { id_cliente, id_usuario, monto_importe, monto_bono, titular, id_cuenta_bancaria, observacion } = req.params;
        observacion = observacion.replace('<<','/');
        titular = titular.replace('<<','/');
        const query = `select    id_cliente,` +
                                `cliente_usuario,` +
                                `agente_usuario,` +
                                `agente_password,` +
                                `id_plataforma ` +
                        `from v_Clientes where id_cliente = ${id_cliente}`;
        const result = await db.handlerSQL(query);

        const cliente_usuario = result.rows[0].cliente_usuario;
        const agente_nombre = result.rows[0].agente_usuario;
        const agente_password = result.rows[0].agente_password;
        const monto_total = Number(monto_importe) + Number(monto_bono);

        let resultado = '';
        if (result.rows[0].id_plataforma == 1) {
            const carga_manual3 = require('./scrap_bot3/cargar.js');
            resultado = await carga_manual3(cliente_usuario.trim(), String(monto_total), agente_nombre, agente_password);
        }
        //console.log(`Resultado carga = ${resultado}`);
        if (resultado == 'ok') 
        {
            const query3 = `select * from Registrar_Carga_Manual(${id_cliente}, ${id_usuario}, ${monto_importe}, ${monto_bono}, '${titular}', ${id_cuenta_bancaria}, '${observacion}')`;
            const result3 = await db.handlerSQL(query3);
            const codigo_operacion = result3.rows[0].codigo_operacion;
            if (codigo_operacion != 0) {
                res.status(201).json({ message: `Carga Registrada con Éxito! Código de Operación: ${codigo_operacion}`});
            } else {
                res.status(201).json({ message: `Error en la Operación de Carga!`});
            }
        } else if (resultado === 'error') {
            res.status(500).json({ message: 'Error al Cargar Fichas' });
        } else if (resultado === 'en_espera') {
            res.status(500).json({ message: 'Servidor con Demora. Por favor, volver a intentar en unos segundos' });
        }        
    } catch (error) {
        res.status(500).json({ message: 'Error al Registrar Cobro!' });
    }
});

app.post('/bloqueo_cliente/:id_usuario/:id_cliente/:bloqueo', async (req, res) => {
    const { id_usuario, id_cliente, bloqueo } = req.params;
    try {
        let query = '';
        let mensaje = '';
        if (bloqueo == 1) {
            query = `select Bloqueo_Cliente(${id_usuario}, ${id_cliente}, true)`;
            mensaje = 'Cliente Bloqueado Exitosamente!';
        } else {
            query = `select Bloqueo_Cliente(${id_usuario}, ${id_cliente}, false)`;
            mensaje = 'Cliente Desbloqueado Exitosamente!';
        }
        const result = await db.handlerSQL(query);
        res.status(201).json({ message: mensaje });
    } catch (error) {
        res.status(500).json({ message: 'Error al Modificar Cliente!' });
    }
});

app.post('/modificar_token/:id_registro_token/:id_usuario/:observaciones/:activo/:bono_carga_1', async (req, res) => {
    const { id_registro_token, id_usuario, observaciones, activo, bono_carga_1 } = req.params;
    try {
        const query = `select Modificar_Token_Agente(${id_registro_token}, ${id_usuario}, '${observaciones}', ${bono_carga_1}, ${activo})`;
        await db.handlerSQL(query);
        res.status(201).json({ message: 'Token Modificado Exitosamente!' });
    } catch (error) {
        res.status(500).json({ message: 'Error al Modificar Token!' });
    }
});

app.post('/modificar_datos_registro/:id_cliente/:id_usuario/:telefono/:email', async (req, res) => {
    const { id_cliente, id_usuario, telefono, email } = req.params;
    try {
        const query = `select Modificar_Cliente_Registro(${id_cliente}, ${id_usuario}, '${telefono}', '${email}')`;
        const result = await db.handlerSQL(query);
        res.status(201).json({ message: 'Datos de Registro Modificados Exitosamente!' });
    } catch (error) {
        res.status(500).json({ message: 'Error al Modificar Datos de Registro!' });
    }
});

app.post('/modificar_agente/:id_agente/:id_usuario/:password/:estado/:oficina/:id_plataforma/:bono_carga_1/:bono_creacion', async (req, res) => {
    const { id_agente, id_usuario, password, estado, oficina, id_plataforma, bono_carga_1, bono_creacion } = req.params;
    try {
        const query = `select Modificar_Agente(${id_agente}, ${id_usuario}, '${password}', ${estado}, ${oficina}, ${id_plataforma}, ${bono_carga_1}, ${bono_creacion})`;
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

app.post('/registrar_token/:id_usuario/:id_agente/:observaciones/:bono_carga_1', async (req, res) => {
    const { id_usuario, id_agente, observaciones, bono_carga_1 } = req.params;
    try {
        const query = `select * from Insertar_Token_Agente(${id_usuario}, ${id_agente}, '${observaciones}', ${bono_carga_1})`;
        const result = await db.handlerSQL(query);
        const id_registro_token = result.rows[0].id_registro_token;
        //console.log(query);
        if (id_registro_token > 0) {
            res.status(201).json({ message: `Token Número ${id_registro_token} registrado exitosamente.` });
        } else {
            res.status(201).json({ message: 'Error al Insertar Token (Servidor)' });
        }        
    } catch (error) {
        res.status(500).json({ message: 'Error al Registrar Token (Servidor)' });
    }
});

app.post('/registrar_agente/:id_usuario/:usuario/:password/:id_oficina/:id_plataforma/:bono_carga_1/:bono_creacion', async (req, res) => {
    const { id_usuario, usuario, password, id_oficina, id_plataforma, bono_carga_1, bono_creacion } = req.params;
    try {
        const queryChek = `select * from v_Agentes where agente_usuario = '${usuario}' and marca_baja = false;`;
        const result1 = await db.handlerSQL(queryChek);
        //console.log(queryChek);
        if (result1.rows.length > 0) {
            res.status(401).json({ message: 'El Agente ya existe!' });
            return;
        }

        const query = `select Insertar_Agente(${id_usuario}, '${usuario}', '${password}', ${id_oficina}, ${id_plataforma}, ${bono_carga_1}, ${bono_creacion})`;
        const result2 = await db.handlerSQL(query);
        //console.log(query);

        res.status(201).json({ message: 'Agente registrado exitosamente.' });
    } catch (error) {
        res.status(500).json({ message: 'Error al registrar Agente.' });
    }
});

app.post('/cargar_retiro/:id_operacion/:id_usuario/:monto', async (req, res) => {
    try {
        const { id_operacion, id_usuario, monto } = req.params;
        const query2 = `select * from Modificar_Cliente_Retiro(${id_operacion}, 2, ${monto}, ${id_usuario})`;
        await db.handlerSQL(query2);
        res.status(201).json({ codigo : 1, message: `Retiro de Fichas Registrado Exitosamente!` });
        /*const query = `select    cliente_usuario,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `agente_password,` +
                                `id_plataforma ` +
        `from v_Clientes_Operaciones where id_operacion = ${id_operacion}`;
        const result = await db.handlerSQL(query);

        const cliente_usuario = result.rows[0].cliente_usuario;
        const agente_nombre = result.rows[0].agente_usuario;
        const agente_password = result.rows[0].agente_password;

        let resultado = '';
        if (result.rows[0].id_plataforma == 1) {
            const retiro_manual3 = require('./scrap_bot3/retirar.js');
            resultado = await retiro_manual3(cliente_usuario.trim(), String(monto), agente_nombre, agente_password);
        }
        if (resultado == 'ok') 
        {
            const query2 = `select * from Modificar_Cliente_Retiro(${id_operacion}, 2, ${monto}, ${id_usuario})`;
            await db.handlerSQL(query2);
            res.status(201).json({ codigo : 1, message: `Retiro de Fichas Registrado Exitosamente!` });
        } else if (resultado == 'error') {
            res.status(500).json({ codigo : 2, message: 'Error al Retirar Fichas' });
        } else if (resultado == 'en_espera') {
            res.status(500).json({ codigo : 3, message: 'Servidor con Demora. Por favor, volver a intentar en unos segundos' });
        } else if (resultado == 'faltante') {
            res.status(201).json({ codigo : 4, message: 'Saldo Insuficiente!' });
        }*/
    } catch (error) {
        res.status(500).json({ message: 'Error en el Retiro' });
    }
});

app.post('/cargar_cobro/:id_operacion/:id_usuario/:monto/:bono/:id_cuenta_bancaria', async (req, res) => {
    try {
        const { id_operacion, id_usuario, monto, bono, id_cuenta_bancaria } = req.params;
        const query = `select    cliente_usuario,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `agente_password,` +
                                `id_plataforma ` +
        `from v_Clientes_Operaciones where id_operacion = ${id_operacion}`;
        const result = await db.handlerSQL(query);

        const cliente_usuario = result.rows[0].cliente_usuario;
        const agente_nombre = result.rows[0].agente_usuario;
        const agente_password = result.rows[0].agente_password;
        const monto_carga = Number(monto.trim());
        const monto_bono = Number(bono.trim());
        const monto_total = monto_carga + monto_bono;

        let resultado = '';
        if (result.rows[0].id_plataforma == 1) {
            const carga_manual3 = require('./scrap_bot3/cargar.js');
            resultado = await carga_manual3(cliente_usuario.trim(), String(monto_total), agente_nombre, agente_password);
        }
        //console.log(`Resultado carga = ${resultado}`);
        if (resultado == 'ok') 
        {
            const query2 = `select * from Modificar_Cliente_Carga(${id_operacion}, 2, ${monto_carga}, ${monto_bono}, ${id_cuenta_bancaria}, ${id_usuario})`;
            await db.handlerSQL(query2);
            res.status(201).json({ codigo : 1, message: `Carga de Fichas Registrada Exitosamente!` });
        } else if (resultado === 'error') {
            res.status(500).json({ codigo : 2, message: 'Error al Cargar Fichas' });
        } else if (resultado === 'en_espera') {
            res.status(500).json({ codigo : 3, message: 'Servidor con Demora. Por favor, volver a intentar en unos segundos' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error al Cargar Cobro' });
    }
});

app.post('/cargar_bono_referido/:id_cliente/:id_usuario/:bono/:id_cuenta_bancaria/:id_operacion', async (req, res) => {
    try {
        const { id_cliente, id_usuario, bono, id_cuenta_bancaria, id_operacion } = req.params;
        const query = `select    cliente_usuario,` +
                                `id_agente,` +
                                `agente_usuario,` +
                                `agente_password,` +
                                `id_plataforma ` +
        `from v_Clientes where id_cliente = ${id_cliente}`;
        const result = await db.handlerSQL(query);

        const cliente_usuario = result.rows[0].cliente_usuario;
        const agente_nombre = result.rows[0].agente_usuario;
        const agente_password = result.rows[0].agente_password;
        const monto_total = Number(bono.trim());

        let resultado = '';
        if (result.rows[0].id_plataforma == 1) {
            const carga_manual3 = require('./scrap_bot3/cargar.js');
            resultado = await carga_manual3(cliente_usuario.trim(), String(monto_total), agente_nombre, agente_password);
        }
        //console.log(`Resultado carga = ${resultado}`);
        if (resultado == 'ok') 
        {
            const query2 = `select * from Cargar_Bono_Referido(${id_cliente}, ${id_usuario}, ${monto_total}, ${id_cuenta_bancaria}, ${id_operacion})`;
            await db.handlerSQL(query2);
            res.status(201).json({ codigo : 1, message: `Carga de Bono Referido Exitosa!` });
        } else if (resultado === 'error') {
            res.status(500).json({ codigo : 2, message: 'Error al Cargar Fichas Bono Referente' });
        } else if (resultado === 'en_espera') {
            res.status(500).json({ codigo : 3, message: 'Servidor con Demora. Por favor, volver a intentar en unos segundos' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error al Cargar Fichas Bono Referente' });
    }
});

app.post('/rechazar_cobro/:id_operacion/:id_usuario', async (req, res) => {
    try {
        const { id_operacion, id_usuario } = req.params;
        const query2 = `select * from Modificar_Cliente_Carga(${id_operacion}, 3, 0, 0, 0, ${id_usuario})`;
        await db.handlerSQL(query2);
        res.status(201).json({ codigo : 1, message: `Cobro Rechazado Exitosamente.` });
    } catch (error) {
        res.status(500).json({ codigo : 2, message: 'Error al Rechazar Cobro.' });
    }
});

app.post('/rechazar_retiro/:id_operacion/:id_usuario', async (req, res) => {
    try {
        const { id_operacion, id_usuario } = req.params;
        const query2 = `select * from Modificar_Cliente_Retiro(${id_operacion}, 3, 0, ${id_usuario})`;
        await db.handlerSQL(query2);
        res.status(201).json({ codigo : 1, message: `Retiro Rechazado Exitosamente.` });
    } catch (error) {
        res.status(500).json({ codigo : 2, message: 'Error al Rechazar Retiro de Fichas.' });
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

app.post('/crear_oficina/:id_usuario/:oficina/:contactoWhatsapp/:contactoTelegram/:estado/:bonoPrimeraCarga/:bonoCargaPerpetua/:minimoCarga/:minimoRetiro/:minimoEsperaRetiro', async (req, res) => {
    try {    
            let { id_usuario , oficina, contactoWhatsapp, contactoTelegram, estado, bonoPrimeraCarga, bonoCargaPerpetua, minimoCarga, minimoRetiro, minimoEsperaRetiro } = req.params;
            //console.log('llego');
            contactoTelegram = contactoTelegram.replace('<<','/');
            const query = `select * from Insertar_Oficina(${id_usuario}, '${oficina}', '${contactoWhatsapp}', '${contactoTelegram}', ${estado}, ${bonoPrimeraCarga}, ${bonoCargaPerpetua}, ${minimoCarga}, ${minimoRetiro}, ${minimoEsperaRetiro})`;
            //console.log(query);
            const result = await db.handlerSQL(query);
            if (result.rows[0].id_oficina == 0) {
                res.status(401).json({ message: `Oficina ${oficina} ya existe` });
            } else {
                res.status(201).json({ message: `Oficina ${oficina} ya creada` });
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

/*Archivos Adjuntos*/
// Configuración de multer para la gestión de archivos
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'uploads/') // Ruta donde se almacenarán los archivos
    },
    filename: function (req, file, cb) {
      cb(null, file.originalname) // Nombre del archivo almacenado en el servidor
    }
})
  
const upload = multer({ 
    storage: storage,
    limits: {
        fileSize: 20 * 1024 * 1024 // Límite de 20MB
    },
    fileFilter: function (req, file, cb) {
        const extname = path.extname(file.originalname).toLowerCase();
        if (extname === '.jpg' || extname === '.png' || extname === '.pdf') {
            cb(null, true);
        } else {
            cb(new Error('Solo se permiten archivos .jpg, .png o .pdf'));
        }
}
});
  
// Ruta para subir un archivo
app.post('/upload', upload.single('file'), async (req, res) => {
    const id_cliente = req.body.id_cliente;
    const id_usuario = req.body.id_usuario;
    const nombre_guardado = req.body.nombre_guardado;
    const nombre_original = req.body.nombre_original;
    
    //console.log(`Cliente: ${id_cliente} - Archivo ${nombre_original} - Guardado como ${nombre_guardado} - Usuario: ${id_usuario}`);
    const query= `select Insertar_Cliente_Chat_Adjunto(${id_cliente}, false, '${nombre_original}', '${nombre_guardado}', ${id_usuario})`;
    await db.handlerSQL(query);
    res.status(201).json({ resultado: 'ok', mensaje: 'Archivo enviado exitosamente' });
});
  
// Manejador de errores
app.use((err, req, res, next) => {
    if (err instanceof multer.MulterError) {
        res.status(400).send('Error al subir archivo: ' + err.message);
    }
});

// Directorio donde se encuentran los archivos a servir
const directorioArchivos = path.join(__dirname, '../uploads/');

// Endpoint para servir archivos
app.get('/descargar/:nombreArchivo', (req, res) => {
  const nombreArchivo = req.params.nombreArchivo;
  const rutaArchivo = path.join(directorioArchivos, nombreArchivo);
  res.download(rutaArchivo);
});