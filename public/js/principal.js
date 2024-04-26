let id_usuario = 0;
let id_token = '';
let id_rol = 0;
let id_cliente = 0;
let abriendo_sesion_bot = 0;
let bajando_usuario_cliente = 0;
let modificando_estado_cuenta_usuario_cliente = 0;
let lista_negra_cliente = 0;
let enviando_mensaje_cliente = 0;
let registrando_agente = 0;
let modificando_agente = 0;
let creando_oficina = 0;
let modificando_oficina = 0;
let creando_cuenta_cobro = 0;
let modificando_cuenta_cobro = 0;
let descargando_cuenta_cobro = 0;
let creando_whatsapp = 0;
let modificando_whatsapp = 0;
let url_ultima_invocada = '';
let modificando_usuario = 0;
let registrando_usuario = 0;
let cargando_cobro = 0;
let rechazando_cobro = 0;
let cargando_retiro = 0;
let rechazando_retiro = 0;
let anulando_notificacion_cobro = 0;
let bloqueando_cliente = 0;
let cargando_cobro_manual = 0;
let cargando_retiro_manual = 0;
const numFilasPorPagina = 10;
let paginaActual = 1;
let datos = [];
let datosOriginales = [];
let paginacionActual = 1;
let ws = null;

// Función para cargar el contenido dinámico desde el servidor
function cargarContenido(url) {
    // Realizar una solicitud AJAX al servidor para obtener el contenido del archivo EJS
    fetch(url)
      .then(response => response.text())
      .then(data => {
        // Actualizar el contenido del div con id 'contenido-dinamico'
        document.getElementById('contenido-dinamico').innerHTML = data;
        let tiene_busqueda = false;
        if (url.indexOf('usuarios') !== -1 ) {
            tiene_busqueda = true;
        }
        if (url.indexOf('agentes') !== -1 ) {
            tiene_busqueda = true;
        }
        if (url.indexOf('monitoreo_landingweb') !== -1 ) {
            tiene_busqueda = true;
        }
        if (url.indexOf('cuentas_cobro') !== -1 ) {
            tiene_busqueda = true;
        }
        if (url.indexOf('cuentas_cobro_descargas') !== -1 ) {
            tiene_busqueda = true;
        }
        //Código para funcionalidad de búsqueda en tablas:
        if (tiene_busqueda) {
            const inputBusqueda = document.getElementById('search-input');
            const tabla = document.getElementById('miTabla');
            const paginacion = document.getElementById('paginacion');
            //console.log('Llegue!');
            inputBusqueda.addEventListener('keyup', function() {
                const textoBusqueda = inputBusqueda.value.toLowerCase();                
                //console.log(textoBusqueda);
                if (textoBusqueda.trim() === '') {
                  datos = [...datosOriginales]; // Restaurar datos originales si el campo de búsqueda está vacío
                } else {
                  // Filtrar los datos según el texto de búsqueda
                  //datos = datosOriginales.filter(fila => fila.some(celda => celda.includes(textoBusqueda)));
                  datos = datosOriginales.filter(fila => fila.some(celda => {
                        /*console.log('**********************');
                        console.log(celda.contenidoTexto);
                        console.log(celda.contenidoTexto.includes(textoBusqueda));*/
                        return celda.contenidoTexto.includes(textoBusqueda);
                  }));
                }
                mostrarDatosEnTabla(tabla);
                crearBotonesPaginacion(tabla, paginacion);
              });
              
              obtenerDatosTabla(tabla);
              mostrarDatosEnTabla(tabla);
              crearBotonesPaginacion(tabla, paginacion);
        }
      })
      .catch(error => {
        console.error('Error:', error);
      });
}

function cargarContenidoChats(id_cliente, mensaje, alerta) {
    if ((mensaje != '' || alerta) && document.getElementById("chat-messages")) 
    {
        let mensaje_envio = mensaje;
        if (alerta) {
            mensaje_envio = '';
        } else {
            mensaje_envio = mensaje_envio.replace('/','<<');
        }
        const url = `/usuarios_clientes_chat_detalle?id_cliente=${encodeURIComponent(id_cliente)}&mensaje=${encodeURIComponent(mensaje_envio)}&id_usuario=${encodeURIComponent(id_usuario)}`;
        fetch(url)
        .then(response => response.text())
        .then(data => {
            const chatMessages = document.getElementById("chat-messages");
            chatMessages.innerHTML = data;
            chatMessages.scrollTop = chatMessages.scrollHeight;
            if (!alerta) {
                const texto_mensaje = document.getElementById('message-input');
                texto_mensaje.value = '';
                texto_mensaje.focus();
                enviarMensaje('chat', id_cliente);
            }
        })
        //.then(enviarMensaje('chat', id_cliente))
        .catch(error => {
            console.error('Error:', error);
        });
    } 
}

function cargarContenidoModal(url) {
    fetch(url)
      .then(response => response.text())
      .then(data => {
        document.getElementById('modal-contenido').innerHTML = data;
      })
      .then(scrollToBottom(url))
      .catch(error => {
        console.error('Error:', error);
      });
}
            
function scrollToBottom(url) {
    if (url.indexOf('usuarios_clientes_chat') !== -1 ) 
    {
        const chatMessages = document.getElementById("chat-messages");
        //chatMessages.scrollTop = chatMessages.scrollHeight;
    }
}

function abrirModal(opcion = 0, par1 = '', par2 = '', par3 = '') {
    const modal = document.getElementById('miModal');
    let id_agente = '';
    let id_rol_par = '';
    let id_usuario_par = '';
    let id_cuenta_bancaria = '';
    let id_operacion = '';
    let id_oficina = '';
    let url = '';
    modal.style.display = 'block';
    switch (opcion)
    {
        case 0:
            console.log('Modal de Prueba');
            break;
        case 1:
            id_agente = par1;
            id_rol_par = par2;
            url = `/agentes_editar?id_agente=${encodeURIComponent(id_agente)}&id_rol=${encodeURIComponent(id_rol_par)}`;
            cargarContenidoModal(url);
            break;
        case 2:
            id_rol_par = par1;
            id_oficina = par2
            url = `/agentes_nuevo?id_rol=${encodeURIComponent(id_rol_par)}&id_oficina=${encodeURIComponent(id_oficina)}`;
            cargarContenidoModal(url);
            break;
        case 3:
            id_operacion = par1;
            id_oficina = par3;
            if (parseInt(par2, 10) == 1) {
                url = `/monitoreo_landingweb_carga?id_operacion=${encodeURIComponent(id_operacion)}&id_oficina=${encodeURIComponent(id_oficina)}`;
            } else {
                url = `/monitoreo_landingweb_retiro?id_operacion=${encodeURIComponent(id_operacion)}&id_oficina=${encodeURIComponent(id_oficina)}`;
            }
            cargarContenidoModal(url);
            break;
        case 4:
            id_oficina = par1;
            url = `/configuracion_oficinas_editar?id_oficina=${encodeURIComponent(id_oficina)}`;
            cargarContenidoModal(url);
            break;
        case 5:
            url = `/configuracion_oficinas_nueva`;
            cargarContenidoModal(url);
            break;
        case 8:
            id_cuenta = par1;
            url = `/cuentas_cobro_editar?id_cuenta=${encodeURIComponent(id_cuenta)}`;
            cargarContenidoModal(url);
            break;
        case 9:
            id_oficina = par1;
            url = `/cuentas_cobro_nueva?id_oficina=${encodeURIComponent(id_oficina)}`;
            cargarContenidoModal(url);
            break;
        case 10:
            id_cuenta_bancaria = par1;
            url = `/cuentas_cobro_descargas_confirmar?id_cuenta_bancaria=${encodeURIComponent(id_cuenta_bancaria)}`;
            cargarContenidoModal(url);
            break;
        case 11:
            id_cuenta_bancaria = par1;
            url = `/cuentas_cobro_descargas_historial?id_cuenta_bancaria=${encodeURIComponent(id_cuenta_bancaria)}`;
            cargarContenidoModal(url);
            break;
        case 12:
            id_usuario_par = par1;
            id_rol_par = par2;
            url = `/usuarios_editar?id_usuario=${encodeURIComponent(id_usuario_par)}&id_rol=${encodeURIComponent(id_rol_par)}`;
            cargarContenidoModal(url);
            break;
        case 13:
            id_usuario_par = par1;
            id_rol_par = par2;
            url = `/usuarios_nuevo?id_usuario=${encodeURIComponent(id_usuario_par)}&id_rol=${encodeURIComponent(id_rol_par)}`;
            cargarContenidoModal(url);
            break;
        case 14:
            url = `/usuarios_ayuda`;
            cargarContenidoModal(url);
            break;
        case 15:
            url = `/agentes_ayuda`;
            cargarContenidoModal(url);
            break;
        case 16:
            url = `/usuarios_clientes_ayuda`;
            cargarContenidoModal(url);
            break;
        case 18:
            url = `/monitoreo_landingweb_ayuda`;
            cargarContenidoModal(url);
            break;
        case 19:
            url = `/monitoreo_cuentas_cobro_ayuda`;
            cargarContenidoModal(url);
            break;
        case 21:
            url = `/cuentas_cobro_ayuda`;
            cargarContenidoModal(url);
            break;
        case 22:
            url = `/cuentas_cobro_descargas_ayuda`;
            cargarContenidoModal(url);
            break;
        case 23:
            url = `/configuracion_oficinias_ayuda`;
            cargarContenidoModal(url);
            break;
        case 24:
            id_cliente = Number(par1);
            url = `/usuarios_clientes_chat?id_cliente=${encodeURIComponent(id_cliente)}`;
            cargarContenidoModal(url);
            enviarMensaje('actualiza', id_cliente);
            break;
        case 25:
            id_cliente = par1;
            url = `/usuarios_clientes_carga?id_cliente=${encodeURIComponent(id_cliente)}`;
            cargarContenidoModal(url);
            break;
        case 28:
            id_cliente = par1;
            url = `/usuarios_clientes_retiro?id_cliente=${encodeURIComponent(id_cliente)}`;
            cargarContenidoModal(url);
            break;
        case 27:
            id_cliente = par1;
            url = `/usuarios_clientes_bloqueo?id_cliente=${encodeURIComponent(id_cliente)}`;
            cargarContenidoModal(url);
            break;
        case 26: 
            id_usuario_par = par1;
            url = `/usuarios_historial?id_usuario=${encodeURIComponent(id_usuario_par)}`;
            cargarContenidoModal(url);
            break;
        case 29:
            id_operacion = par1;
            url = `/monitoreo_landingweb_detalle?id_operacion=${encodeURIComponent(id_operacion)}`;
            cargarContenidoModal(url);
            break;
        default:
            console.log('Modal Vacío');
    }
}

function cerrarModal() {
    const modal = document.getElementById('miModal');
    modal.style.display = 'none';
    document.getElementById('modal-contenido').innerHTML = '';
    cargarContenido(url_ultima_invocada);
}

const bloqueo_Cliente = async (id_cliente, bloqueo) => {
    if (bloqueando_cliente == 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    bloqueando_cliente = 1;
    const msgResultado = document.getElementById('msgResultado');
    
    try {
        const response = await fetch(`/bloqueo_cliente/${id_usuario}/${id_cliente}/${bloqueo}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        if (response.ok) {
            const data = await response.json();
            msgResultado.innerHTML = data.message;
        } else {
            msgResultado.innerHTML = 'Error al Bloquear Cliente';
        }
        bloqueando_cliente = 0;
    } catch (error) {
        bloqueando_cliente = 0;
        msgResultado.innerHTML = 'Error al Bloquear';
    }
};

const modificar_Agente = async (id_agente) => {
    if (modificando_agente=== 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    modificando_agente = 1;
    const msgResultado = document.getElementById('msgResultado');
    const password = document.getElementById('password');
    const comboEstado = document.getElementById('estado');
    const comboOficina = document.getElementById('oficina');
    const estado = comboEstado.options[comboEstado.selectedIndex].value;
    const oficina = comboOficina.options[comboOficina.selectedIndex].value;
    const comboPlataforma = document.getElementById('plataforma');
    const plataforma = comboPlataforma.options[comboPlataforma.selectedIndex].value;

    if (password.value == '') {
        msgResultado.innerHTML = 'Contraseña Vacía!';
        modificando_agente = 0;
        return;
    }
    try {
        const response = await fetch(`/modificar_agente/${id_agente}/${id_usuario}/${password.value}/${estado}/${oficina}/${plataforma}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        if (response.ok) {
            const data = await response.json();
            msgResultado.innerHTML = data.message;
        } else {
            msgResultado.innerHTML = 'Error al Modificar Agente';
        }
        modificando_agente = 0;
    } catch (error) {
        modificando_agente = 0;
        msgResultado.innerHTML = 'Error al Modificar Agente';
    }
};

const registrar_Agente = async () => {
    if (registrando_agente=== 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    registrando_agente = 1;
    const msgResultado = document.getElementById('msgResultado');
    const usuario = document.getElementById('usuario');
    const password = document.getElementById('password');
    const comboOficina = document.getElementById('oficina');
    const oficina = comboOficina.options[comboOficina.selectedIndex].value;
    const comboPlataforma = document.getElementById('plataforma');
    const plataforma = comboPlataforma.options[comboPlataforma.selectedIndex].value;

    if (usuario.value == '') {
        msgResultado.innerHTML = 'Usuario Vacío!';
        registrando_agente = 0;
        return;
    }
    if (password.value == '') {
        msgResultado.innerHTML = 'Contraseña Vacía!';
        registrando_agente = 0;
        return;
    }
    try {
        const response = await fetch(`/registrar_agente/${id_usuario}/${usuario.value}/${password.value}/${oficina}/${plataforma}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        if (response.ok) {
            const data = await response.json();
            msgResultado.innerHTML = data.message;
        } else {
            msgResultado.innerHTML = data.message;
        }
        registrando_agente = 0;
    } catch (error) {
        registrando_agente = 0;
        msgResultado.innerHTML = 'Error al Registrar Agente (Cliente)';
    }
};

const registrar_Usuario = async () => {
    if (registrando_usuario=== 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    registrando_usuario = 1;
    const msgResultado = document.getElementById('msgResultado');
    const usuario = document.getElementById('usuario');
    const password = document.getElementById('password');
    const comboRol = document.getElementById('rol');
    const comboOficina = document.getElementById('oficina');
    const rol = comboRol.options[comboRol.selectedIndex].value;
    const oficina = comboOficina.options[comboOficina.selectedIndex].value;
    
    if (usuario.value == '') {
        msgResultado.innerHTML = 'Usuario Vacío!';
        registrando_usuario = 0;
        return;
    }
    if (password.value == '') {
        msgResultado.innerHTML = 'Contraseña Vacía!';
        registrando_usuario = 0;
        return;
    }
    try {
        const response = await fetch(`/registrar_usuario/${id_usuario}/${usuario.value}/${password.value}/${rol}/${oficina}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        if (response.ok) {
            const data = await response.json();
            msgResultado.innerHTML = data.message;
        } else {
            msgResultado.innerHTML = 'Error al Registrar Usuario';
        }
        registrando_usuario = 0;
    } catch (error) {
        registrando_usuario = 0;
        msgResultado.innerHTML = 'Error al Registrar Usuario';
    }
};

const modificar_Usuario = async (id_usuario_act) => {
    if (modificando_usuario=== 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    modificando_usuario = 1;
    const msgResultado = document.getElementById('msgResultado');
    const password = document.getElementById('password');
    const comboEstado = document.getElementById('estado');
    const comboRol = document.getElementById('rol');
    const comboOficina = document.getElementById('oficina');
    const estado = comboEstado.options[comboEstado.selectedIndex].value;
    const rol = comboRol.options[comboRol.selectedIndex].value;
    const oficina = comboOficina.options[comboOficina.selectedIndex].value;

    if (password.value == '') {
        msgResultado.innerHTML = 'Contraseña Vacía!';
        modificando_usuario = 0;
        return;
    }
    try {
        const response = await fetch(`/modificar_usuario/${id_usuario}/${id_usuario_act}/${password.value}/${estado}/${rol}/${oficina}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        if (response.ok) {
            const data = await response.json();
            msgResultado.innerHTML = data.message;
        } else {
            msgResultado.innerHTML = 'Error al Modificar Usuario';
        }
        modificando_usuario = 0;
    } catch (error) {
        modificando_usuario = 0;
        msgResultado.innerHTML = 'Error al Modificar Usuario';
    }
};

const modificar_Oficina = async (id_oficina) => {
    if (modificando_oficina === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    modificando_oficina = 1;
    const msgResultado = document.getElementById('msgResultado');
    const oficina = document.getElementById('oficina');
    let contactoWhatsapp = document.getElementById('contactoWhatsapp');
    let contactoTelegram = document.getElementById('contactoTelegram');
    const comboEstado = document.getElementById('estado');
    const bonoPrimeraCarga = document.getElementById('bonoPrimeraCarga');
    const bonoCargaPerpetua = document.getElementById('bonoCargaPerpetua');
    const minimoCarga = document.getElementById('minimoCarga');
    const minimoRetiro = document.getElementById('minimoRetiro');
    const minimoEsperaRetiro = document.getElementById('minimoEsperaRetiro');
    const estado = comboEstado.options[comboEstado.selectedIndex].value;
    //console.log(operador.value);
    //console.log(estado);
    //console.log(id_usuario);

    if (oficina.value == '') {
        msgResultado.innerHTML = 'Oficina Vacía!';
        modificando_oficina = 0;
        return;
    }
    if (contactoWhatsapp.value == '' && contactoTelegram.value == '') {
        msgResultado.innerHTML = 'Contactos de Whatsapp y Telegram Vacíos, Cargar al menos uno!';
        modificando_oficina = 0;
        return;
    }
    contactoTelegram.value = contactoTelegram.value.replace('/','<<');
    if (bonoPrimeraCarga.value == '') {
        msgResultado.innerHTML = 'Porcentaje Bono Primero Carga Vacío!';
        modificando_oficina = 0;
        return;
    }
    if (bonoCargaPerpetua.value == '') {
        msgResultado.innerHTML = 'Porcentaje Bono Perpetuo Vacío!';
        modificando_oficina = 0;
        return;
    }
    if (minimoCarga.value == '') {
        msgResultado.innerHTML = 'Mínimo de Carga Vacío!';
        modificando_oficina = 0;
        return;
    }
    if (minimoRetiro.value == '') {
        msgResultado.innerHTML = 'Mínimo de Retiro Vacío!';
        modificando_oficina = 0;
        return;
    }
    if (minimoEsperaRetiro.value == '') {
        msgResultado.innerHTML = 'Espera de Retiro Vacío!';
        modificando_oficina = 0;
        return;
    }
    if (parseInt(bonoPrimeraCarga.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        modificando_oficina = 0;
        return;
    }
    if (parseInt(bonoCargaPerpetua.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        modificando_oficina = 0;
        return;
    }
    if (parseInt(minimoCarga.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        modificando_oficina = 0;
        return;
    }
    if (parseInt(minimoRetiro.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        modificando_oficina = 0;
        return;
    }
    if (parseInt(minimoEsperaRetiro.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        modificando_oficina = 0;
        return;
    }
    try {
        const response = await fetch(`/modificar_oficina/${id_usuario}/${id_oficina}/${oficina.value}/${contactoWhatsapp.value}/${contactoTelegram.value}/${estado}/${bonoPrimeraCarga.value}/${bonoCargaPerpetua.value}/${minimoCarga.value}/${minimoRetiro.value}/${minimoEsperaRetiro.value}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        if (response.ok) {
            const data = await response.json();
            msgResultado.innerHTML = data.message;
        } else {
            msgResultado.innerHTML = 'Error al Modificar Oficina';
        }
        modificando_oficina = 0;
    } catch (error) {
        modificando_oficina = 0;
        msgResultado.innerHTML = 'Error al Modificar Oficina';
    }
};

const nueva_Oficina = async () => {
    //console.log('Crea Ofi 1');
    if (creando_oficina === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    creando_oficina = 1;
    //console.log('Crea Ofi 2');
    const msgResultado = document.getElementById('msgResultado');
    const oficina = document.getElementById('oficina');
    const contactoWhatsapp = document.getElementById('contactoWhatsapp');
    const contactoTelegram = document.getElementById('contactoTelegram');
    const comboEstado = document.getElementById('estado');
    const bonoPrimeraCarga = document.getElementById('bonoPrimeraCarga');
    const bonoCargaPerpetua = document.getElementById('bonoCargaPerpetua');
    const minimoCarga = document.getElementById('minimoCarga');
    const minimoRetiro = document.getElementById('minimoRetiro');
    const minimoEsperaRetiro = document.getElementById('minimoEsperaRetiro');
    const estado = comboEstado.options[comboEstado.selectedIndex].value;
    //console.log(operador.value);
    //console.log(estado);
    //console.log(id_usuario);
    //console.log('Crea Ofi 3');
    if (oficina.value == '') {
        msgResultado.innerHTML = 'Oficina Vacía!';
        creando_oficina = 0;
        return;
    }
    if (contactoWhatsapp.value == '') {
        msgResultado.innerHTML = 'Contacto Whatsapp Vacío!';
        creando_oficina = 0;
        return;
    }
    if (contactoTelegram.value == '') {
        msgResultado.innerHTML = 'Contacto Telegram Vacío!';
        creando_oficina = 0;
        return;
    }
    contactoTelegram.value = contactoTelegram.value.replace('/','<<');
    if (bonoPrimeraCarga.value == '') {
        msgResultado.innerHTML = 'Porcentaje Bono Primero Carga Vacío!';
        creando_oficina = 0;
        return;
    }
    if (bonoCargaPerpetua.value == '') {
        msgResultado.innerHTML = 'Porcentaje Bono Perpetuo Vacío!';
        creando_oficina = 0;
        return;
    }
    if (minimoCarga.value == '') {
        msgResultado.innerHTML = 'Mínimo de Carga Vacío!';
        creando_oficina = 0;
        return;
    }
    if (minimoRetiro.value == '') {
        msgResultado.innerHTML = 'Mínimo de Retiro Vacío!';
        creando_oficina = 0;
        return;
    }
    if (minimoEsperaRetiro.value == '') {
        msgResultado.innerHTML = 'Espera de Retiro Vacío!';
        creando_oficina = 0;
        return;
    }
    if (parseInt(bonoPrimeraCarga.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        creando_oficina = 0;
        return;
    }
    if (parseInt(bonoCargaPerpetua.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        creando_oficina = 0;
        return;
    }
    if (parseInt(minimoCarga.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        creando_oficina = 0;
        return;
    }
    if (parseInt(minimoRetiro.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        creando_oficina = 0;
        return;
    }
    if (parseInt(minimoEsperaRetiro.value, 10) < 0){
        msgResultado.innerHTML = 'No puede ser menor a cero!';
        creando_oficina = 0;
        return;
    }
    
    try {
        const response = await fetch(`/crear_oficina/${id_usuario}/${oficina.value}/${contactoWhatsapp.value}/${contactoTelegram.value}/${estado}/${bonoPrimeraCarga.value}/${bonoCargaPerpetua.value}/${minimoCarga.value}/${minimoRetiro.value}/${minimoEsperaRetiro.value}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        //console.log('Crea Ofi');
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        creando_oficina = 0;
    } catch (error) {
        creando_oficina = 0;
        msgResultado.innerHTML = 'Error al Crear Oficina';
    }
};

const modificar_Cuenta_Cobro = async (id_cuenta_bancaria) => {
    if (modificando_cuenta_cobro === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    modificando_cuenta_cobro = 1;
    const msgResultado = document.getElementById('msgResultado');
    const nombre = document.getElementById('nombre');
    const alias = document.getElementById('alias');
    const cbu = document.getElementById('cbu');
    const comboEstado = document.getElementById('estado');
    const estado = comboEstado.options[comboEstado.selectedIndex].value;
    let alias_aux = alias.value;

    if (nombre.value == '') {
        msgResultado.innerHTML = 'Nonmbre Vacío!';
        modificando_cuenta_cobro = 0;
        return;
    }
    if (alias.value == '') {
        /*msgResultado.innerHTML = 'Alias Vacío!';
        modificando_cuenta_cobro = 0;
        return;*/
        alias_aux = 'XXXXX';
    }
    if (cbu.value == '') {
        msgResultado.innerHTML = 'CBU Vacío!';
        modificando_cuenta_cobro = 0;
        return;
    }
    
    try {
        const response = await fetch(`/modificar_cuenta_bancaria/${id_usuario}/${id_cuenta_bancaria}/${nombre.value}/${alias_aux}/${cbu.value}/${estado}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        modificando_cuenta_cobro = 0;
    } catch (error) {
        modificando_cuenta_cobro = 0;
        msgResultado.innerHTML = 'Error al Modificar Cuenta de Cobro';
    }
};

const descarga_Cuenta_Cobro = async (id_cuenta_bancaria) => {
    if (descargando_cuenta_cobro === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    descargando_cuenta_cobro = 1;
    
    try {
        const response = await fetch(`/descargar_cuenta_bancaria/${id_usuario}/${id_cuenta_bancaria}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        descargando_cuenta_cobro = 0;
    } catch (error) {
        descargando_cuenta_cobro = 0;
        msgResultado.innerHTML = 'Error al Descargar Cuenta de Cobro';
    }
};

const crear_Cuenta_Cobro = async (id_oficina) => {
    if (creando_cuenta_cobro === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    creando_cuenta_cobro = 1;
    const msgResultado = document.getElementById('msgResultado');
    const nombre = document.getElementById('nombre');
    const alias = document.getElementById('alias');
    const cbu = document.getElementById('cbu');
    const comboEstado = document.getElementById('estado');
    const estado = comboEstado.options[comboEstado.selectedIndex].value;
    let alias_aux = alias.value;

    if (nombre.value == '') {
        msgResultado.innerHTML = 'Nonmbre Vacío!';
        creando_cuenta_cobro = 0;
        return;
    }
    if (alias.value == '') {
        alias_aux = 'XXXXX';
    }
    if (cbu.value == '') {
        msgResultado.innerHTML = 'CBU Vacío!';
        creando_cuenta_cobro = 0;
        return;
    }
    try {
        const response = await fetch(`/crear_cuenta_bancaria/${id_oficina}/${id_usuario}/${nombre.value}/${alias_aux}/${cbu.value}/${estado}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        creando_cuenta_cobro = 0;
    } catch (error) {
        creando_cuenta_cobro = 0;
        msgResultado.innerHTML = 'Error al Crear Cuenta de Cobro';
    }
};

const cargar_Retiro = async (id_operacion, id_cliente) => {
    if (cargando_retiro === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    cargando_retiro = 1;
    const msgResultado = document.getElementById('msgResultado');
    const btnRechazar = document.getElementById('btnRechazar');
    const monto_retiro = document.getElementById('monto_retiro');

    if (monto_retiro.value == '') {
        msgResultado.innerHTML = 'Importe Vacío!';
        cargando_retiro = 0;
        return;
    }
    try {
        const response = await fetch(`/cargar_retiro/${id_operacion}/${id_usuario}/${monto_retiro.value}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        if (data.message != 'Saldo Insuficiente!') {
            btnRechazar.innerHTML = '';
        }
        if (data.codigo == 1) {
            enviarMensaje('sol_retiro_aceptada', id_cliente);
        }
        cargando_retiro = 0;
    } catch (error) {
        cargando_retiro = 0;
        msgResultado.innerHTML = 'Error al Cargar Cobro';
    }
};

const cargar_Retiro_Manual = async (id_cliente) => {
    if (cargando_retiro_manual === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    cargando_retiro_manual = 1;
    const msgResultado = document.getElementById('msgResultado');
    const monto_importe = document.getElementById('monto');
    const cbu = document.getElementById('cbu');
    const titular = document.getElementById('titular');
    const observacion = document.getElementById('observacion');

    if (monto_importe.value == '') {
        msgResultado.innerHTML = 'Importe Vacío!';
        cargando_retiro_manual = 0;
        return;
    }
    if (Number(monto_importe.value) == 0) {
        msgResultado.innerHTML = 'El Importe debe ser mayor a Cero!';
        cargando_retiro_manual = 0;
        return;
    }
    if (cbu.value == '') {
        msgResultado.innerHTML = 'CBU Vacío!';
        cargando_retiro_manual = 0;
        return;
    }
    if (titular.value == '') {
        msgResultado.innerHTML = 'Titular Vacío!';
        cargando_retiro_manual = 0;
        return;
    }
    if (observacion.value == '') {
        observacion.value = '-';
    }
    observacion.value = observacion.value.replace('/','<<');
    titular.value = titular.value.replace('/','<<');
    try {
        const response = await fetch(`/cargar_retiro_manual/${id_cliente}/${id_usuario}/${monto_importe.value}/${cbu.value}/${titular.value}/${observacion.value}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        if (data.codigo == 1) {
            enviarMensaje('sol_carga_aceptada', id_cliente);
        }
        cargando_retiro_manual = 0;
    } catch (error) {
        cargando_retiro_manual = 0;
        msgResultado.innerHTML = 'Error al Cargar Retiro Manual';
    }
};

const cargar_Cobro_Manual = async (id_cliente) => {
    if (cargando_cobro_manual === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    cargando_cobro_manual = 1;
    const msgResultado = document.getElementById('msgResultado');
    const monto_importe = document.getElementById('monto');
    const monto_bono = document.getElementById('bono');
    const titular = document.getElementById('titular');
    const observacion = document.getElementById('observacion');
    const comboCuenta = document.getElementById('cuentaBancaria');
    const id_cuenta_bancaria = comboCuenta.options[comboCuenta.selectedIndex].value;

    if (monto_importe.value == '') {
        msgResultado.innerHTML = 'Importe Vacío!';
        cargando_cobro_manual = 0;
        return;
    }
    if (Number(monto_importe.value) == 0) {
        msgResultado.innerHTML = 'El Importe debe ser mayor a Cero!';
        cargando_cobro_manual = 0;
        return;
    }
    if (monto_bono.value == '') {
        msgResultado.innerHTML = 'Bono Vacío!';
        cargando_cobro_manual = 0;
        return;
    }
    if (titular.value == '') {
        msgResultado.innerHTML = 'Titular Vacío!';
        cargando_cobro_manual = 0;
        return;
    }
    if (observacion.value == '') {
        observacion.value = '-';
    }
    observacion.value = observacion.value.replace('/','<<');
    titular.value = titular.value.replace('/','<<');
    try {
        const response = await fetch(`/cargar_cobro_manual/${id_cliente}/${id_usuario}/${monto_importe.value}/${monto_bono.value}/${titular.value}/${id_cuenta_bancaria}/${observacion.value}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        enviarMensaje('sol_carga_aceptada', id_cliente);
        cargando_cobro_manual = 0;
    } catch (error) {
        cargando_cobro_manual = 0;
        msgResultado.innerHTML = 'Error al Cargar Cobro Manual';
    }
};

const cargar_Cobro = async (id_operacion, id_cliente) => {
    if (cargando_cobro === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    cargando_cobro = 1;
    const msgResultado = document.getElementById('msgResultado');
    const monto_importe = document.getElementById('monto_importe');
    const monto_bono = document.getElementById('monto_bono');
    const comboCuenta = document.getElementById('cuenta_bancaria');
    const id_cuenta_bancaria = comboCuenta.options[comboCuenta.selectedIndex].value;

    if (monto_importe.value == '') {
        msgResultado.innerHTML = 'Importe Vacío!';
        cargando_cobro = 0;
        return;
    }
    if (monto_bono.value == '') {
        msgResultado.innerHTML = 'Bono Vacío!';
        cargando_cobro = 0;
        return;
    }
    try {
        const response = await fetch(`/cargar_cobro/${id_operacion}/${id_usuario}/${monto_importe.value}/${monto_bono.value}/${id_cuenta_bancaria}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        if (data.codigo == 1) {
            enviarMensaje('sol_carga_aceptada', id_cliente);
        }
        cargando_cobro = 0;
    } catch (error) {
        cargando_cobro = 0;
        msgResultado.innerHTML = 'Error al Cargar Cobro';
    }
};

const rechazar_Retiro = async (id_operacion, id_cliente) => {
    if (rechazando_retiro === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    rechazando_retiro = 1;
    const msgResultado = document.getElementById('msgResultado');
    const btnRechazar = document.getElementById('btnRechazar');

    try {
        const response = await fetch(`/rechazar_retiro/${id_operacion}/${id_usuario}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        btnRechazar.innerHTML = '';
        if (data.codigo == 1) {
            enviarMensaje('sol_retiro_rechazada', id_cliente);
        }
        rechazando_retiro = 0;
    } catch (error) {
        rechazando_retiro = 0;
        msgResultado.innerHTML = 'Error al Rechazar Retiro';
    }
};

const rechazar_Cobro = async (id_operacion, id_cliente) => {
    if (rechazando_cobro === 1) {
        alert('Por Favor Aguardar. Se está Procesando la Solicitud.');
        return;
    }
    rechazando_cobro = 1;
    const msgResultado = document.getElementById('msgResultado');

    try {
        const response = await fetch(`/rechazar_cobro/${id_operacion}/${id_usuario}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        msgResultado.innerHTML = data.message;
        if (data.codigo == 1) {
            enviarMensaje('sol_carga_rechazada', id_cliente);
        }
        rechazando_cobro = 0;
    } catch (error) {
        rechazando_cobro = 0;
        msgResultado.innerHTML = 'Error al Rechazar Cobro';
    }
};

const actualizarAlertaUsuariosClientes = async (id_cliente) => {
    const msgResultado = document.getElementById('alerta_usuarios_clientes');
    try {
        const response = await fetch(`/alerta_usuarios_clientes/${id_cliente}/${id_usuario}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        if (data.message == 'ok') {
            msgResultado.innerHTML = '<h3 class="warning">!!!</h3>';
        }
    } catch (error) {
        msgResultado.innerHTML = '<h3 class="warning">error en alerta</h3>';
    }
};

const actualizarAlertaMonitoreo = async (id_cliente) => {
    const msgResultado = document.getElementById('alerta_monitoreo');
    try {
        const response = await fetch(`/alerta_usuarios_clientes/${id_cliente}/${id_usuario}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'}
        });
        const data = await response.json();
        if (data.message == 'ok') {
            msgResultado.innerHTML = '<h3 class="warning">!!!</h3>';
        }
    } catch (error) {
        msgResultado.innerHTML = '<h3 class="warning">error en alerta</h3>';
    }
};

document.addEventListener('DOMContentLoaded', async (req, res) => {
    // Obtener los parámetros de la URL
    const urlParams = new URLSearchParams(window.location.search);
    id_usuario = parseInt(urlParams.get('id_usuario'), 10);
    id_token = urlParams.get('id_token');
    const usuario = urlParams.get('usuario');

    try {
        const response = await fetch('/login_token', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id_usuario, id_token })
        });

        const data = await response.json();
        
        if (data.message === 'token invalido') {
            window.location.href = `../index.html`;
        } else {
            id_rol = parseInt(data.id_rol, 10);
            const usuario_rol = document.getElementById('usuario_rol');
            const usuario_usuario = document.getElementById('usuario_usuario');
            const menu01 = document.getElementById('menu01');
            const menu02 = document.getElementById('menu02');
            const menu03 = document.getElementById('menu03');
            const menu04 = document.getElementById('menu04');
            const menu05 = document.getElementById('menu05');
            const menu06 = document.getElementById('menu06');
            const menu07 = document.getElementById('menu07');
            const menu08 = document.getElementById('menu08');
            //const indicador01 = document.getElementById('indicador01');
            //const indicador02 = document.getElementById('indicador02');
            const logout = document.getElementById('logout');

            usuario_usuario.innerHTML = usuario;
            usuario_rol.innerHTML = '';
    
            if (id_rol === 1){
                usuario_rol.innerHTML = 'Administrador';
            } else if (id_rol === 2){
                usuario_rol.innerHTML = 'Encargado';
                menu07.style.display = 'none';
            } else {
                usuario_rol.innerHTML = 'Operador';
                menu02.style.display = 'none';
                menu03.style.display = 'none';
                menu05.style.display = 'none';
                menu07.style.display = 'none';
            }
            //console.log(`Usuario: ${id_usuario}, Rol: ${id_rol}`);
            // Manejar eventos de clic en los enlaces del menú
            const enlace_menu01 = document.getElementById('menu01');
            const enlace_menu02 = document.getElementById('menu02');
            const enlace_menu03 = document.getElementById('menu03');
            const enlace_menu04 = document.getElementById('menu04');
            const enlace_menu05 = document.getElementById('menu05');
            const enlace_menu06 = document.getElementById('menu06');
            const enlace_menu07 = document.getElementById('menu07');
            const enlace_menu08 = document.getElementById('menu08');
            
            enlace_menu01.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
            });

            enlace_menu02.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
            });

            enlace_menu03.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
            });

            enlace_menu04.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
            });

            enlace_menu05.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
            });

            enlace_menu06.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
                document.getElementById('alerta_monitoreo').innerHTML = '';
            });
            
            enlace_menu07.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
            });
            
            enlace_menu08.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                cargarContenido(url_ultima_invocada);
                document.getElementById('alerta_usuarios_clientes').innerHTML = '';
            });

            // Obtén el modal y el botón para cerrar el modal
            const spanCerrarModal = document.getElementById('btn_cerrar_modal');
            //const btnMostrarModal = document.getElementById('btn_abrir_modal');
            
            // Cuando el usuario hace clic en botón "Mostrar Modal"
            /*btnMostrarModal.addEventListener('click', function(event) {
                event.preventDefault();
                abrirModal(0);
            });*/

            // Cuando el usuario hace clic en (x), cierra el modal
            spanCerrarModal.addEventListener('click', function(event) {
                event.preventDefault();
                cerrarModal();
            });

            logout.addEventListener('click', function(event) {
                event.preventDefault();
                url_ultima_invocada = `${this.getAttribute('href')}?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
                fetch(url_ultima_invocada);
                window.location.href = `/`;
            });
            //Inicializar cliente Websocket********************************/
            ws = new WebSocket('wss://paneleslanding.com:8080');

            ws.onopen = function(event) {
                enviarMensaje('', 0);
            };

            // Evento cuando se recibe un mensaje del servidor
            ws.onmessage = function(event) {
                // Aquí puedes manipular el mensaje recibido, por ejemplo, mostrarlo en la página
                const data = JSON.parse(event.data);
                //alert(`Alerta = ${data.alerta}`);
                if (data.alerta == 'chat') { 
                    if (id_cliente == data.id_cliente) {
                        //alert('Actualizar Chats');
                        cargarContenidoChats(id_cliente, '', true); 
                    }
                    actualizarAlertaUsuariosClientes(data.id_cliente);
                } else {
                    if (url_ultima_invocada.indexOf('monitoreo_landingweb') !== -1 ) {
                        cargarContenido(url_ultima_invocada);
                    } else {
                        actualizarAlertaMonitoreo(data.id_cliente);
                    }
                }
                alertaSistemaOperativo(data.alerta);
            };
            /******************************************************************/

            // Carga el menú de actividad de clientes al inicio:
            url_ultima_invocada = `/monitoreo_landingweb?id_usuario=${encodeURIComponent(id_usuario)}&id_rol=${id_rol}&id_token=${encodeURIComponent(id_token)}`;
            cargarContenido(url_ultima_invocada);
        }
    } catch (error) {
        window.location.href = `../index.html`;
    }
});

function enviarMensaje(mensaje, id_cliente) {
    const message = { 
                es_cliente: 0,
                ws_cliente: id_usuario,
                id_cliente : id_cliente,
                alerta : mensaje
    };
    ws.send(JSON.stringify(message));
}

function alertaSistemaOperativo(alerta) {
    const titulo = 'PanelesLanding';
    const icon = '../img/logo.ico';
    let contenido = '';
    if (alerta == 'chat') {
        contenido = 'Nuevo Mensaje de Cliente'; 
    } else {
        contenido = 'Nueva Solicitud de Cliente'; 
    }    
    if (Notification.permission === 'granted') {
        // El navegador admite notificaciones y ya se ha otorgado permiso
        new Notification(titulo, {
            body: contenido,
            icon: icon
        });
    } else if (Notification.permission !== 'denied') {
        // Solicitar permiso al usuario para mostrar notificaciones
        Notification.requestPermission().then(function (permission) {
            if (permission === 'granted') {
                // Se ha otorgado permiso, mostrar la notificación
                new Notification(titulo, {
                    body: contenido,
                    icon: icon
                });
            }
        });
    }
}
/*********************Búsqueda en Tablas***************************/
function obtenerDatosTabla(tabla) {
    datos = [];
    datosOriginales = [];
    const filas = tabla.getElementsByTagName('tr');
    for (let i = 1; i < filas.length; i++) {
      const fila = filas[i];
      const celdas = fila.getElementsByTagName('td');
      const filaDatos = [];
      for (let j = 0; j < celdas.length; j++) {
        //filaDatos.push(celdas[j].textContent.trim().toLowerCase());
        //filaDatos.push(celdas[j].innerHTML);
        const contenidoHTML = celdas[j].innerHTML.trim();
        const contenidoTexto = celdas[j].textContent.trim().toLowerCase();
        // Agregar el contenido HTML y el texto al arreglo de datos
        filaDatos.push({ contenidoHTML, contenidoTexto });
      }
      datos.push(filaDatos);
      datosOriginales.push(filaDatos);
    }
  }
  
  function mostrarDatosEnTabla(tabla) {
    // Obtener el cuerpo de la tabla (tbody)
    let tbody = tabla.getElementsByTagName('tbody')[0];
    // Eliminar el contenido del cuerpo de la tabla
    tbody.innerHTML = '';
    
    const inicio = (paginaActual - 1) * numFilasPorPagina;
    const fin = paginaActual * numFilasPorPagina;
  
    for (let i = inicio; i < fin && i < datos.length; i++) {
      const filaActual = datos[i];
      const fila = tbody.insertRow();
      for (let j = 0; j < filaActual.length; j++) {
        const celda = fila.insertCell();
        celda.textContent = filaActual[j].contenidoTexto;
        celda.innerHTML = filaActual[j].contenidoHTML;
      }
    }
  }
 
function crearBotonesPaginacion(tabla, paginacion) {
    const totalPaginas = Math.ceil(datos.length / numFilasPorPagina);
    paginacion.innerHTML = '';
  
    for (let i = 1; i <= totalPaginas; i++) {
        const boton = document.createElement('button');
        boton.textContent = i;
        boton.id = 'boton_pagina_' + i;

        boton.addEventListener('click', function() {
            paginaActual = i;
            mostrarDatosEnTabla(tabla);

            boton.classList.add('active');
            const btn_actual = document.getElementById('boton_pagina_' + paginacionActual);
            btn_actual.classList.remove('active');
            paginacionActual = paginaActual;
        });
        paginacion.appendChild(boton);
    }
}