/* Antes y después de creación de índices:
select * from v_Cuenta_Bancaria_Activa;
--217 msec
--203 msec
select * from v_Sesion_Bot;
--277 msec
--242 msec
select * from v_Sesion_Cliente_log;
--359 msec
--302 msec
select * from v_Notificaciones_Cargas;
--445 msec
--369 msec
select * from v_Clientes_Recupero;
--237 msec
--232 msec
select * from v_Clientes_Recupero_Envio;
--217 msec
--190 msec
*/
DROP VIEW v_Cuentas_Bancarias;
DROP VIEW v_Cuenta_Bancaria_Activa;
DROP VIEW v_Cuentas_Bancarias_Descargas;
DROP VIEW v_Console_Logs;
DROP VIEW v_Sesion_Bot;
DROP VIEW v_Sesion_Cliente_log;
DROP VIEW v_Notificaciones_Eneplicadas;
DROP VIEW v_Cuentas_Whatsapp_Respaldo;
DROP VIEW v_Cuentas_Whatsapp;
DROP VIEW v_Operadores;
DROP VIEW v_Notificaciones_Cargas;
DROP VIEW v_Notificaciones_Eneplicadas
DROP VIEW v_Cliente_Bot_Operador;
DROP VIEW v_Cliente_Usuario;
DROP VIEW v_Clientes_Recupero;
DROP VIEW v_Clientes_Recupero_Envio;
DROP VIEW v_Usuarios;
DROP VIEW v_Usuarios_Sesiones;

DROP TABLE IF EXISTS usuario;

CREATE TABLE IF NOT EXISTS usuario
(
    id_usuario serial NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    id_rol integer NOT NULL,
    id_operador integer,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp,
    marca_baja boolean NOT NULL DEFAULT false,
    id_token character varying(30) NOT NULL DEFAULT '',
    PRIMARY KEY (id_usuario)
);
CREATE INDEX usuario_id_rol ON usuario (id_rol);
CREATE INDEX usuario_id_operador ON usuario (id_operador);

DROP TABLE IF EXISTS usuario_sesion;
CREATE TABLE IF NOT EXISTS usuario_sesion
(
    id_usuario_sesion serial NOT NULL,
    id_usuario integer NOT NULL,
    id_token character varying(30) NOT NULL DEFAULT '',
    ip character varying(30) NOT NULL DEFAULT '',
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_cierre timestamp,
    cierre_abrupto boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_usuario_sesion)
);
CREATE INDEX usuario_sesion_id_usuario ON usuario_sesion (id_usuario);

DROP TABLE IF EXISTS console_logs;
CREATE TABLE IF NOT EXISTS console_logs
(
    id serial NOT NULL,
    mensaje_log text,
    ip character varying(15),
    fecha_hora timestamp NOT NULL,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS rol;
CREATE TABLE IF NOT EXISTS rol
(
    id_rol serial NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_rol)
);

DROP TABLE IF EXISTS operador;
CREATE TABLE IF NOT EXISTS operador
(
    id_operador serial NOT NULL,
    operador character varying(100) NOT NULL,
    numero_operador character varying(200) NOT NULL,
    numero_operador_telegram character varying(200) NOT NULL DEFAULT '',
	link_operador_telegram character varying(200) NOT NULL DEFAULT '',
	link_canal_telegram character varying(200) NOT NULL DEFAULT '',
	bono_inicial integer NOT NULL DEFAULT 0,
	bono_carga_1 integer NOT NULL DEFAULT 0,
	bono_carga_perpetua integer NOT NULL DEFAULT 20,
	bono_recupero integer NOT NULL DEFAULT 0,
	minimo_carga integer NOT NULL DEFAULT 0,
	minimo_retiro integer NOT NULL DEFAULT 0,
	minimo_espera_retiro integer NOT NULL DEFAULT 24,
	dias_ultima_carga integer NOT NULL DEFAULT 30,
	dias_ultimo_recupero integer NOT NULL DEFAULT 7,
    usuario_panel_nombre_bot1 character varying(200) NOT NULL,
    usuario_panel_pass_bot1 character varying(200) NOT NULL,
    usuario_panel_nombre_bot2 character varying(200) NOT NULL,
    usuario_panel_pass_bot2 character varying(200) NOT NULL,
	usuario_panel_nombre_bot3 character varying(200) NOT NULL DEFAULT '-',
	usuario_panel_pass_bot3 character varying(200) NOT NULL DEFAULT '-',
	usuario_panel_nombre_bot4 character varying(200) NOT NULL DEFAULT '-',
	usuario_panel_pass_bot4 character varying(200) NOT NULL DEFAULT '-',
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_operador)
);

DROP TABLE IF EXISTS cuenta_numero;
CREATE TABLE IF NOT EXISTS cuenta_numero
(
    id_cuenta_numero serial NOT NULL,
    numero_telefono character varying(200) NOT NULL,
    id_usuario integer NOT NULL,
    id_bot integer NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    id_cuenta_numero_respaldo integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_cuenta_numero)
);
CREATE INDEX cuenta_numero_id_usuario ON cuenta_numero (id_usuario);
CREATE INDEX cuenta_numero_id_bot ON cuenta_numero (id_bot);

DROP TABLE IF EXISTS cuenta_numero_telegram;
CREATE TABLE IF NOT EXISTS cuenta_numero_telegram
(
    id_cuenta_numero_telegram serial NOT NULL,
    id_cuenta_numero integer NOT NULL,
    telegram_token character varying(200) NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    PRIMARY KEY (id_cuenta_numero_telegram)
);
CREATE INDEX cuenta_numero_telegram_id_cuenta_numero ON cuenta_numero (id_cuenta_numero);

DROP TABLE IF EXISTS bot;
CREATE TABLE IF NOT EXISTS bot
(
    id_bot serial NOT NULL,
    nombre_bot character varying(50) NOT NULL,
    pagina_panel_admin character varying(200) NOT NULL,
    pagina_panel_usuario character varying(200) NOT NULL,
    casino character varying(50) NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_bot)
);

DROP TABLE IF EXISTS sesion_bot;
CREATE TABLE IF NOT EXISTS sesion_bot
(
    id_sesion_bot serial NOT NULL,
    id_usuario integer NOT NULL,
    id_cuenta_numero integer NOT NULL,
    id_bot integer NOT NULL,
    id_estado integer NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_cierre timestamp,
    PRIMARY KEY (id_sesion_bot)
);
CREATE INDEX sesion_bot_id_usuario ON sesion_bot (id_usuario);
CREATE INDEX sesion_bot_id_cuenta_numero ON sesion_bot (id_cuenta_numero);

DROP TABLE IF EXISTS estado_sesion;
CREATE TABLE IF NOT EXISTS estado_sesion
(
    id_estado serial NOT NULL,
    estado character varying(50) NOT NULL,
    PRIMARY KEY (id_estado)
);

DROP TABLE IF EXISTS sesion_accion;
CREATE TABLE IF NOT EXISTS sesion_accion
(
    id_accion serial NOT NULL,
    nombre_accion character varying(50) NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_accion)
);

DROP TABLE IF EXISTS notificacion_panelesnoti;
CREATE TABLE IF NOT EXISTS notificacion_panelesnoti
(
    id_notificacion_panelesnoti serial NOT NULL,
    id_usuario integer NOT NULL,
    numero_telefono varchar(200) NOT NULL,
    aplicacion varchar(200) NOT NULL,
    titulo varchar(100) NOT NULL,
    mensaje varchar(200) NOT NULL,
    fecha_hora timestamp NOT NULL,
	id_notificacion_origen varchar(200) NOT NULL DEFAULT '-',
	id_notificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_notificacion_panelesnoti)
);
CREATE INDEX notificacion_panelesnoti_id_usuario ON notificacion_panelesnoti (id_usuario);
CREATE INDEX notificacion_panelesnoti_fecha_hora ON notificacion_panelesnoti (fecha_hora DESC);
CREATE INDEX notificacion_panelesnoti_id_notificacion ON notificacion_panelesnoti (id_notificacion);


DROP TABLE IF EXISTS notificacion;
CREATE TABLE IF NOT EXISTS notificacion
(
    id_notificacion serial NOT NULL,
    id_usuario integer NOT NULL,
    numero_telefono varchar(200) NOT NULL,
    aplicacion varchar(200) NOT NULL,
    titulo varchar(100) NOT NULL,
    mensaje varchar(200) NOT NULL,
    fecha_hora timestamp NOT NULL,
	id_notificacion_origen varchar(200) NOT NULL DEFAULT '-',
	id_origen integer NOT NULL DEFAULT 1,
    PRIMARY KEY (id_notificacion)
);
CREATE INDEX notificacion_id_usuario ON notificacion (id_usuario);
CREATE INDEX notificacion_fecha_hora ON notificacion (fecha_hora DESC);

DROP TABLE IF EXISTS notificacion_carga;
CREATE TABLE IF NOT EXISTS notificacion_carga
(
    id_notificacion_carga serial NOT NULL,
    id_notificacion integer NOT NULL,
    id_sesion_cliente integer,
    carga_usuario varchar(100),
    carga_cbu varchar(200),
    carga_monto numeric,
    marca_procesado boolean NOT NULL DEFAULT false,
    fecha_hora_procesado timestamp NOT NULL,
    PRIMARY KEY (id_notificacion_carga)
);
CREATE INDEX notificacion_carga_id_notificacion ON notificacion_carga (id_notificacion DESC);
CREATE INDEX notificacion_carga_id_sesion_cliente ON notificacion_carga (id_sesion_cliente DESC);
CREATE INDEX notificacion_carga_fecha_hora_procesado ON notificacion_carga (fecha_hora_procesado DESC);

DROP TABLE IF EXISTS notificacion_carga_cancelacion;
CREATE TABLE IF NOT EXISTS notificacion_carga_cancelacion
(
    id_notificacion_carga_cancelacion serial NOT NULL,
    id_notificacion_carga integer NOT NULL,
    id_sesion_cliente integer,
    carga_cbu varchar(200),
    fecha_hora_cancelado timestamp NOT NULL,
    PRIMARY KEY (id_notificacion_carga_cancelacion)
);
CREATE INDEX notificacion_carga_cancelacion_id_notificacion_carga ON notificacion_carga_cancelacion (id_notificacion_carga DESC);

DROP TABLE IF EXISTS notificacion_carga_anulacion;
CREATE TABLE IF NOT EXISTS notificacion_carga_anulacion
(
    id_notificacion_carga_anulacion serial NOT NULL,
    id_notificacion_carga integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_hora_anulado timestamp NOT NULL,
    PRIMARY KEY (id_notificacion_carga_anulacion)
);
CREATE INDEX notificacion_carga_anulacion_id_notificacion_carga ON notificacion_carga_anulacion (id_notificacion_carga DESC);

DROP TABLE IF EXISTS notificacion_carga_duplicacion;
CREATE TABLE IF NOT EXISTS notificacion_carga_duplicacion
(
    id_notificacion_carga_duplicacion serial NOT NULL,
    id_notificacion_carga integer NOT NULL,
    fecha_hora_duplicado timestamp NOT NULL,
	observacion varchar(200),
    PRIMARY KEY (id_notificacion_carga_duplicacion)
);
CREATE INDEX notificacion_carga_duplicacion_id_notificacion_carga ON notificacion_carga_duplicacion (id_notificacion_carga DESC);

DROP TABLE IF EXISTS notificacion_carga_motivo;
CREATE TABLE IF NOT EXISTS notificacion_carga_motivo
(
    id_notificacion_carga_motivo serial NOT NULL,
    id_notificacion_carga integer NOT NULL,
    id_notificacion_carga_manual_motivo integer NOT NULL,
    observacion varchar(200),
    fecha_hora_carga timestamp NOT NULL,
    PRIMARY KEY (id_notificacion_carga_motivo)
);
CREATE INDEX notificacion_carga_motivo_id_notificacion_carga ON notificacion_carga_motivo (id_notificacion_carga DESC);

DROP TABLE IF EXISTS notificacion_carga_manual_motivo;
CREATE TABLE IF NOT EXISTS notificacion_carga_manual_motivo
(
    id_notificacion_carga_manual_motivo serial NOT NULL,
    carga_manual_motivo varchar(200),
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_carga timestamp NOT NULL,
    PRIMARY KEY (id_notificacion_carga_manual_motivo)
);

DROP TABLE IF EXISTS notificacion_origen;
CREATE TABLE IF NOT EXISTS notificacion_origen
(
    id_origen serial NOT NULL,
    notificacion_origen varchar(200) NOT NULL,
    PRIMARY KEY (id_origen)
);

DROP TABLE IF EXISTS cuenta_bancaria;
CREATE TABLE IF NOT EXISTS cuenta_bancaria
(
    id_cuenta_bancaria serial NOT NULL,
	id_operador integer not null,
    nombre character varying(200) NOT NULL,
    alias character varying(200) NOT NULL,
    cbu character varying(200) NOT NULL,
	id_cuenta_bancaria_aplicacion integer not null,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_cuenta_bancaria)
);
CREATE INDEX cuenta_bancaria_id_operador ON cuenta_bancaria (id_operador);
CREATE INDEX cuenta_bancaria_id_cuenta_bancaria_aplicacion ON cuenta_bancaria (id_cuenta_bancaria_aplicacion);

DROP TABLE IF EXISTS cuenta_bancaria_aplicacion;
CREATE TABLE IF NOT EXISTS cuenta_bancaria_aplicacion
(
    id_cuenta_bancaria_aplicacion serial NOT NULL,
    nombre_aplicacion character varying(100) NOT NULL,
    notificacion_descripcion character varying(100) NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    id_usuario_ultima_modificacion integer NOT NULL,
    PRIMARY KEY (id_cuenta_bancaria_aplicacion)
);

DROP TABLE IF EXISTS cuenta_bancaria_descarga;
CREATE TABLE IF NOT EXISTS cuenta_bancaria_descarga
(
    id_cuenta_bancaria_descarga serial NOT NULL,
	id_cuenta_bancaria integer NOT NULL,
	id_usuario integer not null,
    fecha_hora_descarga timestamp NOT NULL,
    cargas_monto numeric NOT NULL,
    cargas_cantidad integer NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_cuenta_bancaria_descarga)
);
CREATE INDEX cuenta_bancaria_descarga_id_cuenta_bancaria ON cuenta_bancaria_descarga (id_cuenta_bancaria);
CREATE INDEX cuenta_bancaria_descarga_id_usuario ON cuenta_bancaria_descarga (id_usuario);
CREATE INDEX cuenta_bancaria_descarga_fecha_hora_descarga ON cuenta_bancaria_descarga (fecha_hora_descarga DESC);

DROP TABLE IF EXISTS cuenta_bancaria_mercado_pago;
CREATE TABLE IF NOT EXISTS cuenta_bancaria_mercado_pago
(
    id_cuenta_bancaria_mercado_pago serial NOT NULL,
	id_cuenta_bancaria integer NOT NULL,
    access_token varchar(200) NOT NULL DEFAULT '-',
    public_key varchar(200) NOT NULL DEFAULT '-',
    client_id varchar(200) NOT NULL DEFAULT '-',
    client_secret varchar(200) NOT NULL DEFAULT '-',
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_cuenta_bancaria_mercado_pago)
);
CREATE INDEX cuenta_bancaria_mercado_pago_id_cuenta_bancaria ON cuenta_bancaria_mercado_pago (id_cuenta_bancaria);

DROP TABLE IF EXISTS cliente;
CREATE TABLE IF NOT EXISTS cliente
(
    id_cliente serial NOT NULL,
    cliente_numero varchar(200) NOT NULL,
    cliente_nombre varchar(100),
	lista_negra boolean NOT NULL DEFAULT false, 
    fecha_hora_creacion timestamp NOT NULL,
    PRIMARY KEY (id_cliente)
);

DROP TABLE IF EXISTS cliente_usuario;
CREATE TABLE IF NOT EXISTS cliente_usuario
(
    id_cliente_usuario serial NOT NULL,
    id_cliente integer NOT NULL,
    id_bot integer NOT NULL,
    id_operador integer NOT NULL DEFAULT 1,
    cliente_usuario varchar(200),
    fecha_hora_creacion timestamp NOT NULL,
	marca_baja boolean NOT NULL DEFAULT false, 
    PRIMARY KEY (id_cliente_usuario)
);
CREATE INDEX cliente_usuario_id_cliente ON cliente_usuario (id_cliente);
CREATE INDEX cliente_usuario_id_operador ON cliente_usuario (id_operador);

DROP TABLE IF EXISTS cliente_usuario_chat;
DROP INDEX IF EXISTS cliente_usuario_chat_id_cliente_usuario;
DROP INDEX IF EXISTS cliente_usuario_chat_id_bot;
DROP INDEX IF EXISTS cliente_usuario_chat_id_operador;
CREATE TABLE IF NOT EXISTS cliente_usuario_chat
(
    id_cliente_usuario_chat serial NOT NULL,
    id_cliente_usuario integer NOT NULL,
    id_cuenta_numero integer NOT NULL,
    id_bot integer NOT NULL,
    id_operador integer NOT NULL DEFAULT 1,
    id_usuario integer NOT NULL DEFAULT 0,
    desde_usuario boolean NOT NULL DEFAULT true, 
    fecha_hora_creacion timestamp NOT NULL,
    mensaje character varying(400),
	procesado boolean NOT NULL DEFAULT true,
    PRIMARY KEY (id_cliente_usuario_chat)
);
CREATE INDEX cliente_usuario_chat_id_cliente_usuario ON cliente_usuario_chat (id_cliente_usuario);
CREATE INDEX cliente_usuario_chat_id_bot ON cliente_usuario_chat (id_bot);
CREATE INDEX cliente_usuario_chat_id_operador ON cliente_usuario_chat (id_operador);
CREATE INDEX cliente_usuario_chat_id_usuario ON cliente_usuario_chat (id_usuario);

DROP TABLE IF EXISTS cliente_usuario_cuentas;
CREATE TABLE IF NOT EXISTS cliente_usuario_cuentas
(
    id_cliente_usuario_cuenta serial NOT NULL,
    id_cliente_usuario integer NOT NULL,
    usuario_titular_cuenta varchar(100) NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    usuario_ultima_modificacion integer NOT NULL,
	id_estado_usuario_cuentas integer NOT NULL DEFAULT 1, 
    PRIMARY KEY (id_cliente_usuario_cuenta)
);
CREATE INDEX cliente_usuario_cuentas_id_cliente_usuario ON cliente_usuario_cuentas (id_cliente_usuario);

DROP TABLE IF EXISTS estado_usuario_cuentas;
CREATE TABLE IF NOT EXISTS estado_usuario_cuentas
(
    id_estado_usuario_cuentas serial NOT NULL,
    estado varchar(100) NOT NULL,
    PRIMARY KEY (id_estado_usuario_cuentas)
);

DROP TABLE IF EXISTS sesion_cliente;
CREATE TABLE IF NOT EXISTS sesion_cliente
(
    id_sesion_cliente serial NOT NULL,
    id_sesion_bot integer NOT NULL,
    id_cliente integer NOT NULL,
    id_sesion_cliente_paso integer NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
	aux_monto varchar(30) NOT NULL DEFAULT '0',
	aux_fichas_restantes varchar(30) NOT NULL DEFAULT '0',
	aux_cbu_carga varchar(200) NOT NULL DEFAULT '',
    PRIMARY KEY (id_sesion_bot)
);
CREATE INDEX sesion_cliente_id_sesion_bot ON sesion_cliente (id_sesion_bot DESC);
CREATE INDEX sesion_cliente_id_cliente ON sesion_cliente (id_cliente);

DROP TABLE IF EXISTS sesion_cliente_paso;
CREATE TABLE IF NOT EXISTS sesion_cliente_paso
(
    id_sesion_cliente_paso integer NOT NULL,
    descripcion_paso character varying NOT NULL,
    fecha_hora_creacion timestamp NOT NULL,
    PRIMARY KEY (id_sesion_cliente_paso)
);

DROP TABLE IF EXISTS sesion_cliente_log;
CREATE TABLE IF NOT EXISTS sesion_cliente_log
(
    id_sesion_cliente_log serial NOT NULL,
    id_sesion_cliente integer NOT NULL,
    id_accion integer NOT NULL,
	observacion varchar(200),
    fecha_hora timestamp NOT NULL,
    PRIMARY KEY (id_sesion_cliente_log)
);
CREATE INDEX sesion_cliente_log_id_sesion_cliente ON sesion_cliente_log (id_sesion_cliente DESC);

DROP TABLE IF EXISTS concurrencia;
CREATE TABLE IF NOT EXISTS concurrencia
(
    id_servidor integer NOT NULL DEFAULT 0,
    activos integer NOT NULL DEFAULT 0,
    en_espera integer NOT NULL DEFAULT 0,
    tope integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_servidor)
);

DROP TABLE IF EXISTS concurrencia_registro;
CREATE TABLE IF NOT EXISTS concurrencia_registro
(
    id_concurrencia_registro serial NOT NULL,
    fecha_hora timestamp,
    id_servidor integer NOT NULL DEFAULT 0,
    activos integer NOT NULL DEFAULT 0,
    en_espera integer NOT NULL DEFAULT 0,
    tope integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_concurrencia_registro)
);
/*****************************************************************************/

insert into rol (nombre_rol, fecha_hora_creacion) values ('Administrador', NOW());
insert into rol (nombre_rol, fecha_hora_creacion) values ('Encargado', NOW());
insert into rol (nombre_rol, fecha_hora_creacion) values ('Operador', NOW());
--select * from rol;

insert into operador (operador, numero_operador,bono_carga_1,minimo_carga,minimo_retiro,fecha_hora_creacion,fecha_hora_ultima_modificacion,id_usuario_ultima_modificacion,marca_baja)
values ('Operador Genérico', '5491131961299',20,500,500,now(),now(),1,false);
--select * from operador;

--DROP FUNCTION Insertar_Usuario(usr VARCHAR(50), pass VARCHAR(200), rol INTEGER, ope INTEGER);
CREATE OR REPLACE FUNCTION Insertar_Usuario(usr VARCHAR(50), pass VARCHAR(200), rol INTEGER, ope INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO usuario (username, password, id_rol, id_operador, fecha_hora_creacion, fecha_hora_ultima_modificacion)
	VALUES (usr, pass, rol, ope, now(), now());
END;
$$ LANGUAGE plpgsql;

select Insertar_Usuario('admin', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 1, 1);
select Insertar_Usuario('dario', '$2b$10$rDzcPsghffuJwcHnYCnfkOjTy1DH6zwDL1of2RZAE4vnJOOfxd1Ya', 2, 1);
select Insertar_Usuario('dario_ope', '$2b$10$rDzcPsghffuJwcHnYCnfkOjTy1DH6zwDL1of2RZAE4vnJOOfxd1Ya', 3, 1);
select Insertar_Usuario('guille', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 1, 1);
select Insertar_Usuario('guille_enc', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 1);
select Insertar_Usuario('guille_ope', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 1);
select Insertar_Usuario('mari', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 1, 1);
select Insertar_Usuario('mari_enc', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 1);
select Insertar_Usuario('mari_ope', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 1);
select Insertar_Usuario('lucas', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 1, 1);
select Insertar_Usuario('lucas_enc', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 1);
select Insertar_Usuario('lucas_ope', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 1);
select Insertar_Usuario('franco', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 1, 1);
select Insertar_Usuario('franco_enc', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 1);
select Insertar_Usuario('franco_ope', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 1);
select Insertar_Usuario('guille_enc_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 2);
select Insertar_Usuario('guille_ope_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 2);
select Insertar_Usuario('mari_enc_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 2);
select Insertar_Usuario('mari_ope_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 2);
select Insertar_Usuario('lucas_enc_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 2);
select Insertar_Usuario('lucas_ope_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 2);
select Insertar_Usuario('franco_enc_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 2, 2);
select Insertar_Usuario('franco_ope_of2', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 3, 2);
--select * from usuario;

--DROP FUNCTION Modificar_Usuario(id_usuario integer, pass VARCHAR(200), in_estado BOOLEAN, id_rol INTEGER, id_operador INTEGER);
CREATE OR REPLACE FUNCTION Modificar_Usuario(in_id_usuario integer, pass VARCHAR(200), in_estado BOOLEAN, in_id_rol INTEGER, in_id_operador INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE usuario 
	SET password = pass,
		id_rol = in_id_rol, 
		id_operador = in_id_operador, 
		fecha_hora_ultima_modificacion = now(),
		marca_baja = in_estado
	WHERE id_usuario = in_id_usuario;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Obtener_Usuario_Token(in_id_usuario INTEGER, in_id_token VARCHAR(30));
CREATE OR REPLACE FUNCTION Obtener_Usuario_Token(in_id_usuario INTEGER, in_id_token VARCHAR(30))
RETURNS TABLE (id_usuario INTEGER, id_rol INTEGER, id_token VARCHAR(30), id_operador INTEGER) AS $$
begin
	RETURN QUERY SELECT u.id_usuario, u.id_rol, us.id_token, u.id_operador
	FROM usuario_sesion us JOIN usuario u
		ON (us.id_usuario = u.id_usuario
			AND us.id_usuario = in_id_usuario
			AND us.id_token = in_id_token
		   	AND fecha_hora_cierre IS NULL);
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Usuario_Token(2, 'ejemplo');

--DROP FUNCTION Modificar_Usuario_Token(id_usuario INTEGER, id_token VARCHAR(30), in_dir_ip VARCHAR(30));
CREATE OR REPLACE FUNCTION Modificar_Usuario_Token(in_id_usuario INTEGER, in_id_token VARCHAR(30), in_dir_ip VARCHAR(30)) RETURNS VOID AS $$
BEGIN
	
	UPDATE 	usuario_sesion
	SET 	fecha_hora_cierre = now(),
			cierre_abrupto = true
	WHERE	id_usuario = in_id_usuario
			AND id_token != in_id_token
			AND fecha_hora_cierre IS NULL;
			
	INSERT INTO usuario_sesion (id_usuario, id_token, ip, fecha_hora_creacion)
	VALUES	(in_id_usuario, in_id_token, in_dir_ip, now());
	
END;
$$ LANGUAGE plpgsql;
--select Modificar_Usuario_Token(2, 'ejemplo');

--DROP FUNCTION Cerrar_Sesion_Usuario(in_id_usuario INTEGER, in_id_token VARCHAR(30));
CREATE OR REPLACE FUNCTION Cerrar_Sesion_Usuario(in_id_usuario INTEGER, in_id_token VARCHAR(30)) RETURNS VOID AS $$
BEGIN
	UPDATE 	usuario_sesion
	SET 	fecha_hora_cierre = now()
	WHERE	id_usuario = in_id_usuario
			AND id_token = in_id_token;		
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Obtener_Usuario(usr VARCHAR(50), in_login BOOLEAN);
CREATE OR REPLACE FUNCTION Obtener_Usuario(usr VARCHAR(50), in_login BOOLEAN)
RETURNS TABLE (id_usuario INTEGER, username VARCHAR(50), password VARCHAR(200), id_rol INTEGER, id_operador INTEGER) AS $$
BEGIN
	IF (in_login) THEN
		RETURN query select u.id_usuario, u.username, u.password, u.id_rol, u.id_operador
		from usuario u join operador o
			on (u.id_operador = o.id_operador)
		where u.username = usr
			and u.marca_baja = false
			and o.marca_baja = false;
	ELSE
		RETURN query select u.id_usuario, u.username, u.password, u.id_rol, u.id_operador
		from usuario u join operador o
			on (u.id_operador = o.id_operador)
		where u.username = usr;
	END IF;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Usuario('dario_ope', true);
select * from usuario order by 1 desc

--DROP FUNCTION Obtener_Cuenta_Numero(id_usr INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Cuenta_Numero(id_usr INTEGER)
RETURNS TABLE (id_cuenta_numero INTEGER, numero_telefono VARCHAR(200)) AS $$
begin
	RETURN query select c.id_cuenta_numero, c.numero_telefono
	from cuenta_numero c
	where c.id_usuario = id_usr
	and c.numero_telefono not in (	select c2.numero_telefono
								 	from sesion_bot s join cuenta_numero c2
								 	on (s.id_cuenta_numero = c2.id_cuenta_numero
									   	and s.id_estado <> 2));
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Cuenta_Numero(2);

DROP VIEW v_Cuenta_Bancaria_Activa;
CREATE OR REPLACE VIEW v_Cuenta_Bancaria_Activa AS
SELECT 	cb.id_operador,
		o.operador,
		cb.id_cuenta_bancaria,
		cb.nombre,
		cb.alias,
		cb.cbu,
		cb.marca_baja,
		coalesce(count(nc.carga_monto), 0)		as cantidad_cargas,
		coalesce(sum(nc.carga_monto), 0)		as monto_cargas,
		DENSE_RANK() OVER (PARTITION BY cb.id_operador, o.operador
						   ORDER BY coalesce(sum(nc.carga_monto), 0), coalesce(count(nc.carga_monto), 0)) as orden
FROM 	cuenta_bancaria cb join operador o
			on (cb.id_operador = o.id_operador
			   	AND cb.marca_baja = false)
		left join (select id_cuenta_bancaria, 
				   			max(fecha_hora_descarga) as fecha_descarga
				  from cuenta_bancaria_descarga
				  where marca_baja = false
				  group by id_cuenta_bancaria) cbd
			on (cb.id_cuenta_bancaria = cbd.id_cuenta_bancaria)
		left join notificacion_carga nc
			on (cb.cbu = nc.carga_cbu
		   		and nc.marca_procesado = true
			   	and nc.fecha_hora_procesado > coalesce(cbd.fecha_descarga, '1900-01-01'))
GROUP BY cb.id_operador,
		o.operador,
		cb.id_cuenta_bancaria,
		cb.nombre,
		cb.alias,
		cb.cbu,
		cb.marca_baja
ORDER BY cb.id_operador, monto_cargas, cantidad_cargas;

--DROP FUNCTION Obtener_Datos_Bot(id_bot INTEGER, in_id_usuario INTEGER, in_id_cuenta_numero INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Datos_Bot(in_id_bot INTEGER, in_id_usuario INTEGER, in_id_cuenta_numero INTEGER)
RETURNS TABLE (nombre_bot VARCHAR(50), 
			   usuario_panel_nombre varchar(200),
			   usuario_panel_pass varchar(200),
			   pagina_panel_admin varchar(200),
			   pagina_panel_usuario varchar(200),
			   casino varchar(200),
			   id_cuenta_numero integer,
			   numero_operador varchar(200),
			   numero_operador_telegram varchar(200),
			   cuenta_nombre varchar(200),
			   cuenta_alias varchar(200),
			   cuenta_cbu varchar(200),
			   bono_inicial integer,
			   bono_carga_1 integer,
			   bono_recupero integer,
			   bono_carga_perpetua integer,
			   minimo_carga integer,
			   minimo_retiro integer,
			   minimo_espera_retiro integer) AS $$
BEGIN
	RETURN query select	b.nombre_bot,
			CASE
				WHEN b.id_bot = 1 THEN o.usuario_panel_nombre_bot1
				WHEN b.id_bot = 2 THEN o.usuario_panel_nombre_bot2
				WHEN b.id_bot = 3 THEN o.usuario_panel_nombre_bot3
				WHEN b.id_bot = 4 THEN o.usuario_panel_nombre_bot4
				ELSE '-'
			END AS usuario_panel_nombre,
			CASE
				WHEN b.id_bot = 1 THEN o.usuario_panel_pass_bot1
				WHEN b.id_bot = 2 THEN o.usuario_panel_pass_bot2
				WHEN b.id_bot = 3 THEN o.usuario_panel_pass_bot3
				WHEN b.id_bot = 4 THEN o.usuario_panel_pass_bot4
				ELSE '-'
			END AS usuario_panel_pass,
			b.pagina_panel_admin,
			b.pagina_panel_usuario,
			b.casino,
			cn.id_cuenta_numero,
			o.numero_operador,
			o.numero_operador_telegram,
			c.nombre 	as cuenta_nombre,
			c.alias		as cuenta_alias,
			c.cbu		as cuenta_cbu,
			o.bono_inicial,
			o.bono_carga_1,
			o.bono_recupero,
			o.bono_carga_perpetua,
			o.minimo_carga,
			o.minimo_retiro,
			o.minimo_espera_retiro
	from bot b join cuenta_numero cn
			on (b.id_bot = cn.id_bot
			   	--and cn.id_usuario = in_id_usuario
			 	and cn.id_cuenta_numero = in_id_cuenta_numero
			   	and b.id_bot = in_id_bot)
		join usuario u
			on (u.id_usuario = in_id_usuario)
		join operador o
			on (u.id_operador = o.id_operador)
		join v_Cuenta_Bancaria_Activa c
			on (o.id_operador = c.id_operador
			   and c.orden = 1);
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Datos_Bot(1, 2, 1);
--select * from Obtener_Datos_Bot(1, 18, 3);
--select * from Obtener_Datos_Bot(2, 13, 6);

--DROP FUNCTION Modificar_Usuario_Cliente(in_id_cliente_usuario INTEGER, in_id_operador INTEGER);
CREATE OR REPLACE FUNCTION Modificar_Usuario_Cliente(in_id_cliente_usuario INTEGER, in_id_operador INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE cliente_usuario set marca_baja = true
	WHERE id_cliente_usuario = in_id_cliente_usuario;
	
	-- UPDATE sesion_cliente set id_sesion_cliente_paso = 1 where id_cliente = in_id_cliente;
	UPDATE sesion_cliente 
	set id_sesion_cliente_paso = 1 
	from cliente_usuario, sesion_bot, usuario
	where cliente_usuario.id_cliente_usuario = in_id_cliente_usuario
		and cliente_usuario.id_cliente = sesion_cliente.id_cliente
		and sesion_cliente.id_sesion_bot = sesion_bot.id_sesion_bot
		and sesion_bot.id_usuario = usuario.id_usuario
		and usuario.id_operador = in_id_operador;
END;
$$ LANGUAGE plpgsql;
--select Modificar_Usuario_Cliente(2);

--DROP FUNCTION Lista_Negra_Cliente(in_id_cliente_usuario INTEGER, in_id_operador INTEGER);
CREATE OR REPLACE FUNCTION Lista_Negra_Cliente(in_id_cliente_usuario INTEGER, in_id_operador INTEGER) 
RETURNS TABLE (lista_negra BOOLEAN) AS $$
DECLARE
    aux_id_cliente INTEGER;
	aux_lista_negra BOOLEAN;
BEGIN
	
	SELECT c.id_cliente, c.lista_negra
	INTO aux_id_cliente, aux_lista_negra
	FROM	cliente_usuario cu JOIN cliente c
			ON (cu.id_cliente = c.id_cliente)
	WHERE cu.id_cliente_usuario = in_id_cliente_usuario
		AND cu.id_operador = in_id_operador;
	
	IF aux_lista_negra = true THEN
		update cliente set lista_negra = false where id_cliente = aux_id_cliente;
	ELSE
		update cliente set lista_negra = true where id_cliente = aux_id_cliente;
	END IF;
	
	RETURN query SELECT c.lista_negra FROM cliente c where c.id_cliente = aux_id_cliente;
END;
$$ LANGUAGE plpgsql;
--select * from Lista_Negra_Cliente(346,1)
--select * from Lista_Negra_Cliente(347,1)

--DROP FUNCTION Registrar_Chat(in_id_cuenta_numero INTEGER, in_cliente_numero VARCHAR(200), in_mensaje VARCHAR(200), in_desde_usuario BOOLEAN);
CREATE OR REPLACE FUNCTION Registrar_Chat(in_id_cuenta_numero INTEGER, in_cliente_numero VARCHAR(200), in_mensaje VARCHAR(200), in_desde_usuario BOOLEAN) RETURNS VOID AS $$
BEGIN
	INSERT INTO cliente_usuario_chat (id_cliente_usuario, id_cuenta_numero, id_bot, id_operador, desde_usuario, fecha_hora_creacion, mensaje)
	SELECT		cu.id_cliente_usuario, 
				in_id_cuenta_numero, 
				cu.id_bot, 
				cu.id_operador, 
				in_desde_usuario, 
				now(), 
				in_mensaje
	FROM 	cliente c JOIN cliente_usuario cu
				ON (c.id_cliente = cu.id_cliente
				   	AND c.cliente_numero = in_cliente_numero)
			JOIN cuenta_numero cn
				ON (cn.id_bot = cu.id_bot
				   	AND cn.id_cuenta_numero = in_id_cuenta_numero)
			JOIN usuario u
				ON (cn.id_usuario = u.id_usuario
				   AND u.id_operador = cu.id_operador);
END;
$$ LANGUAGE plpgsql;
--select Registrar_Chat(17, '6603947860', 'Hola', true);
--select * from cliente_usuario_chat

--DROP FUNCTION Mensaje_Usuario_Cliente(in_id_cliente_usuario INTEGER, in_mensaje VARCHAR(200), in_id_usuario INTEGER);
CREATE OR REPLACE FUNCTION Mensaje_Usuario_Cliente(in_id_cliente_usuario INTEGER, in_mensaje VARCHAR(200), in_id_usuario INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO cliente_usuario_chat (id_cliente_usuario, id_cuenta_numero, id_bot, id_operador, desde_usuario, fecha_hora_creacion, mensaje, id_usuario, procesado)
	SELECT		cu.id_cliente_usuario, 
				0 as id_cuenta_numero, 
				cu.id_bot, 
				cu.id_operador, 
				false as in_desde_usuario, 
				now(), 
				in_mensaje,
				in_id_usuario as id_usuario,
				false as procesado
	FROM 	cliente_usuario cu 
	WHERE 	cu.id_cliente_usuario = in_id_cliente_usuario;
	
END;
$$ LANGUAGE plpgsql;
--select Mensaje_Usuario_Cliente(17, '6603947860', 'Hola', true);

--DROP FUNCTION Procesar_Chat(in_id_cliente_usuario_chat INTEGER);
CREATE OR REPLACE FUNCTION Procesar_Chat(in_id_cliente_usuario_chat INTEGER) RETURNS VOID AS $$
BEGIN

	UPDATE cliente_usuario_chat 
	SET procesado = true
	WHERE id_cliente_usuario_chat = in_id_cliente_usuario_chat;
	
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Modificar_Operador(in_id_usuario INTEGER, in_id_operador INTEGER, in_operador VARCHAR(200), in_numero_operador VARCHAR(200), in_link_operador_telegram VARCHAR(200), in_link_canal_telegram VARCHAR(200), in_estado BOOLEAN, in_bono_inicial INTEGER, in_bono_primera_carga INTEGER, in_bono_recupero INTEGER, in_bono_carga_perpetua INTEGER, in_minimo_carga INTEGER, in_minimo_retiro INTEGER, in_minimo_espera_retiro INTEGER, in_dias_ultima_carga INTEGER, in_dias_ultimo_recupero INTEGER, in_usuario_panel_nombre_bot1 VARCHAR(200),in_usuario_panel_pass_bot1 VARCHAR(200),in_usuario_panel_nombre_bot2 VARCHAR(200),in_usuario_panel_pass_bot2 VARCHAR(200),in_usuario_panel_nombre_bot3 VARCHAR(200), in_usuario_panel_pass_bot3 VARCHAR(200),in_usuario_panel_nombre_bot4 VARCHAR(200),in_usuario_panel_pass_bot4 VARCHAR(200))
CREATE OR REPLACE FUNCTION Modificar_Operador(in_id_usuario INTEGER, in_id_operador INTEGER, in_operador VARCHAR(200), in_numero_operador VARCHAR(200), in_link_operador_telegram VARCHAR(200), in_link_canal_telegram VARCHAR(200), in_estado BOOLEAN, in_bono_inicial INTEGER, in_bono_primera_carga INTEGER, in_bono_recupero INTEGER, in_bono_carga_perpetua INTEGER, in_minimo_carga INTEGER, in_minimo_retiro INTEGER, in_minimo_espera_retiro INTEGER, in_dias_ultima_carga INTEGER, in_dias_ultimo_recupero INTEGER, in_usuario_panel_nombre_bot1 VARCHAR(200),in_usuario_panel_pass_bot1 VARCHAR(200),in_usuario_panel_nombre_bot2 VARCHAR(200),in_usuario_panel_pass_bot2 VARCHAR(200),in_usuario_panel_nombre_bot3 VARCHAR(200), in_usuario_panel_pass_bot3 VARCHAR(200),in_usuario_panel_nombre_bot4 VARCHAR(200),in_usuario_panel_pass_bot4 VARCHAR(200)) RETURNS VOID AS $$
BEGIN

	UPDATE operador set operador = in_operador, 
						numero_operador = in_numero_operador, 
						link_operador_telegram = in_link_operador_telegram,
						link_canal_telegram = in_link_canal_telegram,
						marca_baja = in_estado, 
						bono_inicial = in_bono_inicial,
						bono_carga_1 = in_bono_primera_carga, 
						bono_recupero = in_bono_recupero, 
						bono_carga_perpetua = in_bono_carga_perpetua,
						minimo_carga = in_minimo_carga, 
						minimo_retiro = in_minimo_retiro,
						minimo_espera_retiro = in_minimo_espera_retiro,
						dias_ultima_carga = in_dias_ultima_carga,
						dias_ultimo_recupero = in_dias_ultimo_recupero,
						usuario_panel_nombre_bot1 = in_usuario_panel_nombre_bot1,
						usuario_panel_pass_bot1 = in_usuario_panel_pass_bot1,
						usuario_panel_nombre_bot2 = in_usuario_panel_nombre_bot2,
						usuario_panel_pass_bot2 = in_usuario_panel_pass_bot2,
						usuario_panel_nombre_bot3 = in_usuario_panel_nombre_bot3,
						usuario_panel_pass_bot3 = in_usuario_panel_pass_bot3,
						usuario_panel_nombre_bot4 = in_usuario_panel_nombre_bot4,
						usuario_panel_pass_bot4 = in_usuario_panel_pass_bot4,
						fecha_hora_ultima_modificacion = now(),
						id_usuario_ultima_modificacion = in_id_usuario
	WHERE id_operador = in_id_operador;
	
END;
$$ LANGUAGE plpgsql;
--select Modificar_Operador(1, 1 , 'Operador Genérico2', '5491131961299', false, 20, 100, 100)

--DROP FUNCTION Insertar_Operador(in_id_usuario INTEGER, in_operador VARCHAR(200), in_numero_operador VARCHAR(200), in_estado BOOLEAN, in_bono_inicial INTEGER, in_bono_primera_carga INTEGER, in_bono_recupero INTEGER, in_bono_carga_perpetua INTEGER, in_minimo_carga INTEGER, in_minimo_retiro INTEGER, in_minimo_espera_retiro INTEGER, in_dias_ultima_carga INTEGER, in_dias_ultimo_recupero INTEGER, in_usuario_panel_nombre_bot1 VARCHAR(200),in_usuario_panel_pass_bot1 VARCHAR(200),in_usuario_panel_nombre_bot2 VARCHAR(200),in_usuario_panel_pass_bot2 VARCHAR(200),in_usuario_panel_nombre_bot3 VARCHAR(200),in_usuario_panel_pass_bot3 VARCHAR(200),in_usuario_panel_nombre_bot4 VARCHAR(200),in_usuario_panel_pass_bot4 VARCHAR(200));
CREATE OR REPLACE FUNCTION Insertar_Operador(in_id_usuario INTEGER, in_operador VARCHAR(200), in_numero_operador VARCHAR(200), in_estado BOOLEAN, in_bono_inicial INTEGER, in_bono_primera_carga INTEGER, in_bono_recupero INTEGER, in_bono_carga_perpetua INTEGER, in_minimo_carga INTEGER, in_minimo_retiro INTEGER, in_minimo_espera_retiro INTEGER, in_dias_ultima_carga INTEGER, in_dias_ultimo_recupero INTEGER, in_usuario_panel_nombre_bot1 VARCHAR(200),in_usuario_panel_pass_bot1 VARCHAR(200),in_usuario_panel_nombre_bot2 VARCHAR(200),in_usuario_panel_pass_bot2 VARCHAR(200),in_usuario_panel_nombre_bot3 VARCHAR(200),in_usuario_panel_pass_bot3 VARCHAR(200),in_usuario_panel_nombre_bot4 VARCHAR(200),in_usuario_panel_pass_bot4 VARCHAR(200)) 
RETURNS TABLE (id_operador INTEGER) AS $$
DECLARE
    aux_id_operador INTEGER;
BEGIN

	IF NOT EXISTS(	select 1
					from operador o
					where o.operador = in_operador) THEN
		INSERT INTO operador (operador, numero_operador, marca_baja, bono_inicial, bono_carga_1, bono_recupero, bono_carga_perpetua, minimo_carga, minimo_retiro, minimo_espera_retiro, dias_ultima_carga, dias_ultimo_recupero, usuario_panel_nombre_bot1, usuario_panel_pass_bot1, usuario_panel_nombre_bot2, usuario_panel_pass_bot2, usuario_panel_nombre_bot3, usuario_panel_pass_bot3, usuario_panel_nombre_bot4, usuario_panel_pass_bot4, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
		VALUES (in_operador, in_numero_operador, in_estado, in_bono_inicial, in_bono_primera_carga, in_bono_recupero, in_bono_carga_perpetua, in_minimo_carga, in_minimo_retiro, in_minimo_espera_retiro, in_dias_ultima_carga, in_dias_ultimo_recupero, in_usuario_panel_nombre_bot1, in_usuario_panel_pass_bot1, in_usuario_panel_nombre_bot2, in_usuario_panel_pass_bot2, in_usuario_panel_nombre_bot3, in_usuario_panel_pass_bot3, in_usuario_panel_nombre_bot4, in_usuario_panel_pass_bot4, now(), now(), in_id_usuario)
		RETURNING operador.id_operador INTO aux_id_operador;		
	ELSE
		aux_id_operador := 0;
	END IF;
	
	RETURN query SELECT aux_id_operador;
END;
$$ LANGUAGE plpgsql;
--select * from Insertar_Operador(7, 'Operador Genérico2', '5491131961299', false, 20, 100, 100)

--DROP FUNCTION Modificar_Cuenta_Numero(in_id_usuario INTEGER, in_id_cuenta_numero INTEGER, in_numero_celular VARCHAR(200), in_id_bot INTEGER, in_estado BOOLEAN, in_id_numero_telefono_respaldo INTEGER);
CREATE OR REPLACE FUNCTION Modificar_Cuenta_Numero(in_id_usuario INTEGER, in_id_cuenta_numero INTEGER, in_numero_celular VARCHAR(200), in_id_bot INTEGER, in_estado BOOLEAN, in_id_numero_telefono_respaldo INTEGER) 
RETURNS TABLE (id_cuenta_numero INTEGER) AS $$
DECLARE
    aux_id_cuenta_numero INTEGER;
BEGIN

	IF NOT EXISTS(	select 1
					from cuenta_numero cn
					where cn.numero_telefono = in_numero_celular
				 		AND cn.id_cuenta_numero != in_id_cuenta_numero) THEN

		UPDATE cuenta_numero set numero_telefono = in_numero_celular, 
							id_bot = in_id_bot,
							marca_baja = in_estado, 
							id_cuenta_numero_respaldo = in_id_numero_telefono_respaldo, 
							fecha_hora_ultima_modificacion = now()						
		WHERE cuenta_numero.id_cuenta_numero = in_id_cuenta_numero;
	ELSE
		aux_id_cuenta_numero := 0;
	END IF;
	
	RETURN query SELECT aux_id_cuenta_numero;
END;
$$ LANGUAGE plpgsql;
--select Modificar_Cuenta_Numero(in_id_cuenta_numero INTEGER, in_numero_celular VARCHAR(200), in_id_bot INTEGER, in_id_estado INTEGER, in_id_numero_telefono_respaldo INTEGER);

--DROP FUNCTION Insertar_Cuenta_Numero((in_id_usuario INTEGER, in_id_cuenta_numero INTEGER, in_numero_celular VARCHAR(200), in_id_bot INTEGER, in_estado BOOLEAN, in_id_numero_telefono_respaldo INTEGER));
CREATE OR REPLACE FUNCTION Insertar_Cuenta_Numero(in_id_usuario INTEGER, in_numero_celular VARCHAR(200), in_id_bot INTEGER, in_estado BOOLEAN, in_id_numero_telefono_respaldo INTEGER) 
RETURNS TABLE (id_cuenta_numero INTEGER) AS $$
DECLARE
    aux_id_cuenta_numero INTEGER;
BEGIN

	IF NOT EXISTS(	select 1
					from cuenta_numero cn
					where cn.numero_telefono = in_numero_celular) THEN
		INSERT INTO cuenta_numero (numero_telefono, id_usuario, id_bot, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja, id_cuenta_numero_respaldo)
		VALUES (in_numero_celular, in_id_usuario, in_id_bot, now(), now(), in_estado, in_id_numero_telefono_respaldo)
		RETURNING cuenta_numero.id_cuenta_numero INTO aux_id_cuenta_numero;		
	ELSE
		aux_id_cuenta_numero := 0;
	END IF;
	
	RETURN query SELECT aux_id_cuenta_numero;
END;
$$ LANGUAGE plpgsql;
--select * from Insertar_Cuenta_Numero(in_id_usuario, in_numero_celular, in_id_bot, in_estado, in_id_numero_telefono_respaldo) 

--DROP FUNCTION Crear_Cuenta_Bancaria(in_id_operador INTEGER, in_id_usuario INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_id_aplicacion_bancaria INTEGER, in_estado BOOLEAN);
CREATE OR REPLACE FUNCTION Crear_Cuenta_Bancaria(in_id_operador INTEGER, in_id_usuario INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_id_aplicacion_bancaria INTEGER, in_estado BOOLEAN) 
RETURNS TABLE (id_cuenta_bancaria INTEGER) AS $$
DECLARE
    aux_id_cuenta_bancaria INTEGER;
BEGIN
IF 
	IF NOT EXISTS(	select 1
					from cuenta_bancaria cb
					where cb.cbu = in_cbu) THEN
					-- where cb.alias = in_alias OR cb.cbu = in_cbu) THEN

		INSERT INTO cuenta_bancaria (id_operador, 
									 nombre, 
									 alias, 
									 cbu, 
									 id_cuenta_bancaria_aplicacion,
									 fecha_hora_creacion,
									 fecha_hora_ultima_modificacion,
									 marca_baja)
		VALUES (in_id_operador, in_nombre, in_alias, in_cbu, in_id_aplicacion_bancaria, now(), now(), false)
		RETURNING cuenta_bancaria.id_cuenta_bancaria INTO aux_id_cuenta_bancaria;
		
	ELSE
		aux_id_cuenta_bancaria := 0;
		
	END IF;
	
	RETURN query SELECT aux_id_cuenta_bancaria;
END;
$$ LANGUAGE plpgsql;
--select * from Crear_Cuenta_Bancaria(1, 1, 'Noelia Caleza', 'noelia.227.caleza.mp', '0000003100091595755417' , 1, false);
select * from cuenta_bancaria;

--DROP FUNCTION Modificar_Cuenta_Bancaria(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_id_aplicacion_bancaria INTEGER, in_estado BOOLEAN);
CREATE OR REPLACE FUNCTION Modificar_Cuenta_Bancaria(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_id_aplicacion_bancaria INTEGER, in_estado BOOLEAN) 
RETURNS TABLE (id_cuenta_bancaria INTEGER) AS $$
DECLARE
    aux_id_cuenta_bancaria INTEGER;
BEGIN

	IF NOT EXISTS(	select 1
					from cuenta_bancaria cb
					where 	((cb.alias = in_alias AND cb.alias!='') OR cb.cbu = in_cbu)
				 		AND cb.id_cuenta_bancaria != in_id_cuenta_bancaria) THEN

		UPDATE cuenta_bancaria 	set nombre = in_nombre, 
								alias = in_alias,
								cbu = in_cbu,
								id_cuenta_bancaria_aplicacion = in_id_aplicacion_bancaria,
								marca_baja = in_estado,
								fecha_hora_ultima_modificacion = now()						
		WHERE cuenta_bancaria.id_cuenta_bancaria = in_id_cuenta_bancaria;
		aux_id_cuenta_bancaria := in_id_cuenta_bancaria;
	ELSE
		aux_id_cuenta_bancaria := 0;
	END IF;
	
	RETURN query SELECT aux_id_cuenta_bancaria;
END;
$$ LANGUAGE plpgsql;
--select * from Modificar_Cuenta_Bancaria(1, 1, 'Noelia Caleza', 'noelia.227.caleza.mp', '0000003100091595755417' , 1, false);

--DROP FUNCTION Descargar_Cuenta_Bancaria(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER);
CREATE OR REPLACE FUNCTION Descargar_Cuenta_Bancaria(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER) 
RETURNS TABLE (cbu VARCHAR(200), cargas_monto NUMERIC, cargas_cantidad INTEGER) AS $$
DECLARE
    aux_cbu VARCHAR(200);
    aux_cargas_monto NUMERIC;
    aux_cargas_cantidad INTEGER;
BEGIN	
	IF EXISTS (	SELECT 1 
			   	FROM v_Cuenta_Bancaria_Activa cb
				WHERE cb.id_cuenta_bancaria = in_id_cuenta_bancaria
			  	AND cb.cantidad_cargas > 0) THEN
	
		SELECT cb.cbu, cb.cantidad_cargas, cb.monto_cargas
		INTO aux_cbu, aux_cargas_cantidad, aux_cargas_monto
		FROM v_Cuenta_Bancaria_Activa cb
		WHERE cb.id_cuenta_bancaria = in_id_cuenta_bancaria;	
		
		INSERT INTO cuenta_bancaria_descarga (id_cuenta_bancaria, id_usuario, fecha_hora_descarga, cargas_cantidad, cargas_monto, marca_baja)
		VALUES (in_id_cuenta_bancaria, in_id_usuario, now(), aux_cargas_cantidad, aux_cargas_monto, false);
		
	ELSE
		aux_cbu := '';
		aux_cargas_monto := 0;
		aux_cargas_cantidad := 0;
		
	END IF;	
	
	RETURN query SELECT aux_cbu, aux_cargas_monto, aux_cargas_cantidad;
END;
$$ LANGUAGE plpgsql;
-- select * from Descargar_Cuenta_Bancaria(1,8);

--select * from Obtener_AppsCobro();
insert into cuenta_bancaria_aplicacion (nombre_aplicacion, notificacion_descripcion, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
values ('Mercado Pago', 'com.mercadopago.wallet', false, now(), now(), 1);
insert into cuenta_bancaria_aplicacion (nombre_aplicacion, notificacion_descripcion, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
values ('Open Bank', 'ar.openbank.modelbank', false, now(), now(), 1);
insert into cuenta_bancaria_aplicacion (nombre_aplicacion, notificacion_descripcion, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
values ('Ualá', 'ar.uala', true, now(), now(), 1);
insert into cuenta_bancaria_aplicacion (nombre_aplicacion, notificacion_descripcion, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
values ('Brubank', 'com.brubank', false, now(), now(), 1);
insert into cuenta_bancaria_aplicacion (nombre_aplicacion, notificacion_descripcion, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
values ('Belo', 'com.belo.android', true, now(), now(), 1);
insert into cuenta_bancaria_aplicacion (nombre_aplicacion, notificacion_descripcion, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
values ('Telepagos', 'com.telepagos', false, now(), now(), 1);
--select * from cuenta_bancaria_aplicacion;

insert into cuenta_bancaria (id_operador, nombre, alias, cbu, id_cuenta_bancaria_aplicacion, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values (1, 'Noelia Caleza', 'noelia.227.caleza.mp', '0000003100091595755417', 1, now(), now());
insert into cuenta_bancaria (id_operador, nombre, alias, cbu, id_cuenta_bancaria_aplicacion, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values (1, 'Noelia Abiche', 'noelia.227.abiche.mp', '0000003100050560592091', 1, now(), now());
insert into cuenta_bancaria (id_operador, nombre, alias, cbu, id_cuenta_bancaria_aplicacion, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values (1, 'Sebastian Galo', 'vega.494.cura.mp', '0000003100088557473289', 1, now(), now());
insert into cuenta_bancaria (id_operador, nombre, alias, cbu, id_cuenta_bancaria_aplicacion, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values (1, 'Sebastian Galo', 'mancha.gafas.aceto', '1580001101030010902239', 2, now(), now());
insert into cuenta_bancaria (id_operador, nombre, alias, cbu, id_cuenta_bancaria_aplicacion, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values (1, 'Silvina Suarez', 'ssuarez.bru.3860', '1430001713033674440010', 4, now(), now());
insert into cuenta_bancaria (id_operador, nombre, alias, cbu, id_cuenta_bancaria_aplicacion, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values (1, 'Silvina Suarez', '27315625403.belo', '0000139300000002189802', 5, now(), now());
insert into cuenta_bancaria (id_operador, nombre, alias, cbu, id_cuenta_bancaria_aplicacion, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values (1, 'Sebastian Galo', '20348614941.belo', '0000139300000002189819', 5, now(), now());
--select * from cuenta_bancaria;

insert into bot (nombre_bot, pagina_panel_admin, pagina_panel_usuario, casino, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Bots365', 'botcasino365', 'hola1234', 'https://admin.casino365vip.com', 'https://casino365vip.com', 'Casino 365 Vip', now(), now(), false);
insert into bot (nombre_bot, pagina_panel_admin, pagina_panel_usuario, casino, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Bots365', 'botcasino365', 'hola123', 'https://agentes.casino365online.net', 'https://casino365online.net', 'Casino 365 OnLine', now(), now(), false);
insert into bot (nombre_bot, pagina_panel_admin, pagina_panel_usuario, casino, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Bots365', 'https://bo.casinoenvivo.club', 'https://www.casino365online.club', 'Casino 365 Club', now(), now(), false);
--select * from bot;
--'botcasino365', 'hola1234', 'https://admin.casino365vip.com'
--'botcasino365', 'hola123', 'https://agentes.casino365online.net'

insert into cuenta_numero (numero_telefono, id_usuario, id_bot, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values ('5491133682345', 2, 1, now(), now());
insert into cuenta_numero (numero_telefono, id_usuario, id_bot, fecha_hora_creacion, fecha_hora_ultima_modificacion)
values ('5491176205841', 2, 2, now(), now());
--select * from cuenta_numero;

insert into estado_sesion(estado) values ('Abierta');
insert into estado_sesion(estado) values ('Cerrada');
--select * from estado_sesion;

--Carga de los estados asociados a los pasos:
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (1, 'Finalizado', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (0, 'Paso 0', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (20, 'Paso 20: Crear Usuario', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (40, 'Paso 40: Menu', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (100, 'Paso 100: Cargar Fichas Cantidad', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (120, 'Paso 120: Cargar Fichas Nombre', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (130, 'Paso 130: Cargar Fichas Automático', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (200, 'Paso 200: Retirar Fichas Confirmación', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (220, 'Paso 220: Retirar Fichas Cantidad', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (240, 'Paso 240: Retirar Fichas CBU', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (300, 'Paso 300: Cambiar Contraseña', now());
insert into sesion_cliente_paso(id_sesion_cliente_paso, descripcion_paso, fecha_hora_creacion) values (1000, 'Paso 1000', now());
--select * from sesion_cliente_paso;

insert into estado_usuario_cuentas (estado) values ('Habilitada');
insert into estado_usuario_cuentas (estado) values ('No Habilitada');
insert into estado_usuario_cuentas (estado) values ('Habilitada Por Usuario');
insert into estado_usuario_cuentas (estado) values ('No Habilitada por Usuario');
insert into estado_usuario_cuentas (estado) values ('Duplicidad entre Oficinas');

insert into notificacion_origen (notificacion_origen) values ('Paneles Noti');
insert into notificacion_origen (notificacion_origen) values ('Carga Manual');
insert into notificacion_origen (notificacion_origen) values ('API Mercado Pago');
--select * from notificacion_origen

--DROP FUNCTION Iniciar_Sesion_Bot(in_id_usuario INTEGER, in_id_cuenta_numero INTEGER);
CREATE OR REPLACE FUNCTION Iniciar_Sesion_Bot(in_id_usuario INTEGER, in_id_cuenta_numero INTEGER)
RETURNS TABLE (id_sesion_bot INTEGER, id_bot INTEGER) AS $$
DECLARE
    aux_id_bot INTEGER;
	aux_id_sesion_bot INTEGER;
begin
	select c.id_bot into aux_id_bot
	from cuenta_numero c
	where c.id_cuenta_numero = in_id_cuenta_numero;
	
	insert into sesion_bot(id_usuario, id_cuenta_numero, id_bot, id_estado, fecha_hora_creacion)
	values (in_id_usuario, in_id_cuenta_numero, aux_id_bot, 1, now())
	RETURNING sesion_bot.id_sesion_bot INTO aux_id_sesion_bot;
	
	RETURN query SELECT aux_id_sesion_bot, aux_id_bot;
END;
$$ LANGUAGE plpgsql;
--select * from Iniciar_Sesion_Bot(2, 1);

--DROP FUNCTION Finalizar_Sesion_Bot(id_sesion);
CREATE OR REPLACE FUNCTION Finalizar_Sesion_Bot(in_id_sesion INTEGER) RETURNS VOID AS $$
begin
	update sesion_bot set id_estado = 2, fecha_hora_cierre = now()
	where id_sesion_bot = in_id_sesion;
	
	update sesion_cliente set id_sesion_cliente_paso = 1 where id_sesion_bot = in_id_sesion;
END;
$$ LANGUAGE plpgsql;
--select * from Finalizar_Sesion_Bot(11);
--select * from sesion_bot order by 1 desc;

--DROP FUNCTION Obtener_Estado_Sesion_Bot(in_id_sesion_bot);
CREATE OR REPLACE FUNCTION Obtener_Estado_Sesion_Bot(in_id_sesion_bot INTEGER) 
RETURNS TABLE (id_estado INTEGER)AS $$
DECLARE
    aux_id_estado INTEGER;
begin
	select s.id_estado
	into aux_id_estado
	from sesion_bot s
	where s.id_sesion_bot = in_id_sesion_bot;
		
	RETURN query SELECT aux_id_estado;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Estado_Sesion_Bot(10);

--DROP FUNCTION Obtener_Sesion_Cliente(in_id_sesion_bot INTEGER, in_cliente_numero VARCHAR(50), in_cliente_nombre VARCHAR(100));
CREATE OR REPLACE FUNCTION Obtener_Sesion_Cliente(in_id_sesion_bot INTEGER, in_cliente_numero VARCHAR(50), in_cliente_nombre VARCHAR(100))
RETURNS TABLE (id_sesion_cliente INTEGER, id_sesion_cliente_paso INTEGER) AS $$
DECLARE
    aux_id_cliente INTEGER;
    aux_cliente_nombre VARCHAR(100);
	aux_id_sesion_cliente INTEGER;
	aux_id_sesion_cliente_paso INTEGER;
begin
	aux_id_cliente := -1;
	aux_id_sesion_cliente := -1;
	aux_id_sesion_cliente_paso := -1;
	
	IF NOT EXISTS(	select 1
					from cliente c
					where c.cliente_numero = in_cliente_numero) THEN
		
		insert into cliente (cliente_numero, cliente_nombre, fecha_hora_creacion)
		values (in_cliente_numero, in_cliente_nombre, now())
		returning cliente.id_cliente INTO aux_id_cliente;
		
		insert into sesion_cliente (id_sesion_bot, id_cliente, id_sesion_cliente_paso, fecha_hora_creacion)
		values (in_id_sesion_bot, aux_id_cliente, 0, now())
		returning sesion_cliente.id_sesion_cliente into aux_id_sesion_cliente;
		
		aux_id_sesion_cliente_paso := 0;		
	ELSE
		select c.id_cliente, c.cliente_nombre
		into aux_id_cliente, aux_cliente_nombre
		from cliente c
		where c.cliente_numero = in_cliente_numero;
	
		IF aux_cliente_nombre != in_cliente_nombre THEN
			update cliente set cliente_nombre = aux_cliente_nombre where id_cliente = aux_id_cliente;
		END IF;
	
		IF NOT EXISTS(	select 1
						from sesion_cliente s
						where 	s.id_sesion_bot = in_id_sesion_bot
						and 	s.id_cliente = aux_id_cliente
						and 	s.id_sesion_cliente_paso != 1) THEN

			insert into sesion_cliente (id_sesion_bot, id_cliente, id_sesion_cliente_paso, fecha_hora_creacion)
			values (in_id_sesion_bot, aux_id_cliente, 0, now())
			returning sesion_cliente.id_sesion_cliente into aux_id_sesion_cliente;
			
			aux_id_sesion_cliente_paso := 0;
		ELSE
			select s.id_sesion_cliente, s.id_sesion_cliente_paso
			into aux_id_sesion_cliente, aux_id_sesion_cliente_paso
			from sesion_cliente s
			where 	s.id_sesion_bot = in_id_sesion_bot
			and 	s.id_cliente = aux_id_cliente
			and 	s.id_sesion_cliente_paso != 1;
			
		END IF;
	END IF;
		
	RETURN query SELECT aux_id_sesion_cliente, aux_id_sesion_cliente_paso;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Sesion_Cliente(8, '5491157477661', '+54 9 11 5747-7661')
--select * from Obtener_Sesion_Cliente(1, 'numero', 'nombre');
--select * from Obtener_Sesion_Cliente(27, '5491133682345', 'Bot');
--select * from Obtener_Sesion_Cliente(28, '5491133682345', 'Bot');

CREATE OR REPLACE FUNCTION Modificar_Paso_Sesion_Cliente(in_id_sesion_cliente INTEGER, in_paso INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE sesion_cliente SET id_sesion_cliente_paso = in_paso
	WHERE id_sesion_cliente = in_id_sesion_cliente;
END;
$$ LANGUAGE plpgsql;
--select Modificar_Paso_Sesion_Cliente(in_id_sesion_cliente INTEGER, in_paso);

--DROP FUNCTION Modificar_Paso_Sesion_Cliente_Monto(in_id_sesion_cliente INTEGER, in_monto VARCHAR(20));
CREATE OR REPLACE FUNCTION Modificar_Paso_Sesion_Cliente_Monto(in_id_sesion_cliente INTEGER, in_monto INTEGER, in_cbu_carga VARCHAR(200)) RETURNS VOID AS $$
BEGIN
	UPDATE sesion_cliente 
	SET aux_monto = CAST(in_monto AS VARCHAR(20)), 
		aux_cbu_carga = in_cbu_carga
	WHERE id_sesion_cliente = in_id_sesion_cliente;
END;
$$ LANGUAGE plpgsql;
--select Modificar_Paso_Sesion_Cliente_Monto(in_id_sesion_cliente INTEGER, in_paso);

--DROP FUNCTION Modificar_Cuenta_Usuario_Cliente(in_id_cliente_usuario_cuenta INTEGER, in_id_estado INTEGER, in_id_usuario INTEGER);
CREATE OR REPLACE FUNCTION Modificar_Cuenta_Usuario_Cliente(in_id_cliente_usuario_cuenta INTEGER, in_id_estado INTEGER, in_id_usuario INTEGER) RETURNS VOID AS $$
DECLARE aux_id_estado INTEGER;
		aux_id_operador INTEGER;
		aux_titular VARCHAR(200);
BEGIN
	aux_id_operador := 0;
	aux_id_estado := 5;
	aux_titular := '';
	
	IF in_id_estado = 3 THEN
		aux_id_estado := 4;
	END IF;
	IF in_id_estado = 4 THEN
		aux_id_estado := 3;
	END IF;
	
	SELECT	cu.id_operador, cuc.usuario_titular_cuenta
	INTO	aux_id_operador, aux_titular
	FROM 	cliente_usuario_cuentas cuc JOIN cliente_usuario cu
		ON (cuc.id_cliente_usuario = cu.id_cliente_usuario
		   	AND cuc.id_cliente_usuario_cuenta = in_id_cliente_usuario_cuenta);

	UPDATE cliente_usuario_cuentas 
	SET id_estado_usuario_cuentas = in_id_estado,
		fecha_hora_ultima_modificacion = now(),
		usuario_ultima_modificacion = in_id_usuario
	WHERE id_cliente_usuario_cuenta = in_id_cliente_usuario_cuenta;
	
	UPDATE 	cliente_usuario_cuentas
	SET id_estado_usuario_cuentas = aux_id_estado,
		fecha_hora_ultima_modificacion = now(),
		usuario_ultima_modificacion = in_id_usuario
	FROM cliente_usuario
	WHERE cliente_usuario_cuentas.id_cliente_usuario = cliente_usuario.id_cliente_usuario
		AND cliente_usuario_cuentas.id_cliente_usuario_cuenta != in_id_cliente_usuario_cuenta
		AND cliente_usuario.id_operador = aux_id_operador
		AND cliente_usuario_cuentas.usuario_titular_cuenta = aux_titular;	
END;
$$ LANGUAGE plpgsql;
--select Modificar_Cuenta_Usuario_Cliente(in_id_sesion_cliente INTEGER, in_paso);

--DROP FUNCTION Obtener_Sesion_Cliente_Carga_Manual(in_id_cliente_usuario INTEGER, in_id_bot INTEGER, in_id_operador INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Sesion_Cliente_Carga_Manual(in_id_cliente_usuario INTEGER, in_id_bot INTEGER, in_id_operador INTEGER)
RETURNS TABLE (id_sesion_cliente INTEGER) AS $$
DECLARE
	aux_id_sesion_cliente INTEGER;
BEGIN
	aux_id_sesion_cliente := -1;
	
	IF EXISTS(	select 1
				from cliente_usuario cu join sesion_cliente sc
						on (cu.id_cliente_usuario = in_id_cliente_usuario
						   and cu.id_cliente = sc.id_cliente
						   and cu.id_operador = in_id_operador)
					join sesion_bot sb
						on (sc.id_sesion_bot = sb.id_sesion_bot
								and sb.id_bot = in_id_bot)
					join usuario u
						on (sb.id_usuario = u.id_usuario
							and u.id_operador = cu.id_operador)
			 ) THEN

			select max(sc.id_sesion_cliente)
			into aux_id_sesion_cliente
			from cliente_usuario cu join sesion_cliente sc
					on (cu.id_cliente_usuario = in_id_cliente_usuario
					   and cu.id_cliente = sc.id_cliente
					   and cu.id_operador = in_id_operador)
				join sesion_bot sb
					on (sc.id_sesion_bot = sb.id_sesion_bot
							and sb.id_bot = in_id_bot)
				join usuario u
					on (sb.id_usuario = u.id_usuario
						and u.id_operador = cu.id_operador);
	END IF;
		
	RETURN query SELECT aux_id_sesion_cliente;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Sesion_Cliente_Carga_Manual(8, '5491157477661', '+54 9 11 5747-7661')

--DROP FUNCTION Notificacion_Carga_Manual(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER, in_carga_cbu VARCHAR(200), in_id_motivo INTEGER, in_observacion VARCHAR(200));
CREATE OR REPLACE FUNCTION Notificacion_Carga_Manual(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER, in_carga_cbu VARCHAR(200), in_id_motivo INTEGER, in_observacion VARCHAR(200))
RETURNS VOID AS $$
BEGIN
		update notificacion_carga 
		set 	marca_procesado = true, 
				fecha_hora_procesado = now(), 
				carga_cbu = in_carga_cbu,
				id_sesion_cliente = in_id_sesion_cliente
		where id_notificacion_carga = in_id_notificacion_carga;
		
		insert into notificacion_carga_motivo (id_notificacion_carga, id_notificacion_carga_manual_motivo, observacion, fecha_hora_carga)
		values (in_id_notificacion_carga, in_id_motivo, in_observacion, now());
END;
$$ LANGUAGE plpgsql;
--select Notificacion_Carga_Manual(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER, in_carga_cbu VARCHAR(200), in_id_motivo INTEGER, in_observacion VARCHAR(200));

--DROP FUNCTION Notificacion_Carga_Automatica(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER, in_id_operador INTEGER, in_carga_cbu VARCHAR(200));
CREATE OR REPLACE FUNCTION Notificacion_Carga_Automatica(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER, in_id_operador INTEGER, in_carga_cbu VARCHAR(200))
RETURNS TABLE (carga_cbu VARCHAR(200), carga_alias VARCHAR(200), carga_titular VARCHAR(200)) AS $$
DECLARE 
	aux_carga_cbu VARCHAR(200);
	aux_carga_alias VARCHAR(200);
	aux_carga_titular VARCHAR(200);
BEGIN
		aux_carga_cbu := '';

		update sesion_cliente
		set 	id_sesion_cliente_paso = 40,
				aux_monto = 0
	    where id_sesion_cliente = in_id_sesion_cliente;
		
		select s.aux_cbu_carga
		into aux_carga_cbu
	    from sesion_cliente s
	    where s.id_sesion_cliente = in_id_sesion_cliente;
		
		if aux_carga_cbu = '' then
			aux_carga_cbu := in_carga_cbu;
		end if;
		
		update notificacion_carga 
		set 	marca_procesado = true, 
				fecha_hora_procesado = now(), 
				carga_cbu = aux_carga_cbu,
				id_sesion_cliente = in_id_sesion_cliente
		where id_notificacion_carga = in_id_notificacion_carga;
		
		select 	v.cbu, v.alias, v.nombre
		into 	aux_carga_cbu, aux_carga_alias, aux_carga_titular
		from v_Cuenta_Bancaria_Activa v
		where v.id_operador = in_id_operador
		and v.orden = 1;
		
		update 	sesion_cliente
		set 	aux_cbu_carga = aux_carga_cbu
		where id_sesion_cliente = in_id_sesion_cliente;
		
		return query select aux_carga_cbu, aux_carga_alias, aux_carga_titular;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Registrar_Cliente_Usuario(in_id_sesion_cliente INTEGER, usuario VARCHAR(200));
CREATE OR REPLACE FUNCTION Registrar_Cliente_Usuario(in_id_sesion_cliente INTEGER, usuario VARCHAR(200)) RETURNS VOID AS $$
DECLARE
    aux_id_cliente INTEGER;
	aux_id_cliente_usuario INTEGER;
	aux_id_sesion_bot INTEGER;
	aux_id_bot INTEGER;
	aux_id_operador INTEGER;
BEGIN
	aux_id_cliente := -1;
	aux_id_cliente_usuario := -1;

	select id_cliente, id_sesion_bot
	into aux_id_cliente, aux_id_sesion_bot
	from sesion_cliente
	where id_sesion_cliente = in_id_sesion_cliente
	and id_sesion_cliente_paso != 1;
	
	IF EXISTS (	select 1
				from sesion_cliente
				where id_sesion_cliente = in_id_sesion_cliente
				and id_sesion_cliente_paso != 1) THEN
		select s.id_bot, u.id_operador 
		into aux_id_bot, aux_id_operador
		from sesion_bot s join usuario u
			on (s.id_usuario = u.id_usuario)
		where s.id_sesion_bot = aux_id_sesion_bot;

		/*select c.id_cliente_usuario into aux_id_cliente_usuario
		from cliente_usuario c
		where c.id_cliente = aux_id_cliente
		and c.cliente_usuario = usuario
		and c.id_bot = aux_id_bot;*/
		
		IF NOT EXISTS (	select 1
						from cliente_usuario c
						where c.id_cliente = aux_id_cliente
						-- and c.cliente_usuario = usuario
					   	and c.marca_baja = false
						and c.id_bot = aux_id_bot
					  	and c.id_operador = aux_id_operador) THEN
			insert into cliente_usuario (id_cliente, id_bot, cliente_usuario, fecha_hora_creacion, id_operador)
			values (aux_id_cliente, aux_id_bot, usuario, now(), aux_id_operador);
			
			insert into sesion_cliente_log (id_sesion_cliente, id_accion, observacion, fecha_hora)
			values (in_id_sesion_cliente, 1, usuario, now());
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;
--select Registrar_Cliente_Usuario(5, 'robotito789');
	
CREATE OR REPLACE FUNCTION Registrar_Accion_Sesion_Cliente(in_id_sesion_cliente INTEGER, in_id_accion INTEGER, in_usuario VARCHAR(200)) RETURNS VOID AS $$
BEGIN
	insert into sesion_cliente_log (id_sesion_cliente, id_accion, observacion, fecha_hora)
	values (in_id_sesion_cliente, in_id_accion, in_usuario, now());
END;
$$ LANGUAGE plpgsql;
--select Registrar_Accion_Sesion_Cliente();

CREATE OR REPLACE FUNCTION Registrar_Cancelacion_Carga(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO notificacion_carga_cancelacion (id_notificacion_carga, id_sesion_cliente, carga_cbu, fecha_hora_cancelado)
	SELECT 	id_notificacion_carga, 
			id_sesion_cliente, 
			carga_cbu, 
			now()
	FROM 	notificacion_carga
	WHERE 	notificacion_carga.id_notificacion_carga = in_id_notificacion_carga
	AND 	notificacion_carga.id_sesion_cliente = in_id_sesion_cliente;
	
	UPDATE 	notificacion_carga
	SET		marca_procesado = false,
			id_sesion_cliente = null,
			carga_cbu = null
	WHERE 	id_notificacion_carga = in_id_notificacion_carga
	AND 	id_sesion_cliente = in_id_sesion_cliente;
END;
$$ LANGUAGE plpgsql;
--Select Registrar_Cancelacion_Carga(410, 2690);
--select * from notificacion_carga_cancelacion

CREATE OR REPLACE FUNCTION Registrar_Anulacion_Carga(in_id_notificacion_carga INTEGER, in_id_usuario INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO notificacion_carga_anulacion (id_notificacion_carga, id_usuario, fecha_hora_anulado)
	VALUES (in_id_notificacion_carga, in_id_usuario, now());
	
	UPDATE 	notificacion_carga
	SET		marca_procesado = true
	WHERE 	id_notificacion_carga = in_id_notificacion_carga;
END;
$$ LANGUAGE plpgsql;
--Select Registrar_Anulacion_Carga(42, 2);
--select * from notificacion_carga_anulacion
--select * from notificacion_carga where id_notificacion_carga = 42
--update notificacion_carga set marca_procesado = false where id_notificacion_carga = 42

CREATE OR REPLACE FUNCTION Limpiar_Notificaciones_Sin_Procesar() RETURNS VOID AS $$
BEGIN	
	UPDATE 	notificacion_carga
	SET		marca_procesado = false,
			id_sesion_cliente = null,
			carga_cbu = null
	WHERE 	id_notificacion_carga = -25;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Obtener_Usuario_Cliente(in_id_sesion_cliente INTEGER, in_id_bot INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Usuario_Cliente(in_id_sesion_cliente INTEGER, in_id_bot INTEGER)
RETURNS TABLE (cliente_usuario VARCHAR(200), lista_negra BOOLEAN) AS $$
begin
	RETURN QUERY SELECT cu.cliente_usuario, c.lista_negra
	FROM cliente_usuario cu JOIN sesion_cliente sc
			ON (cu.id_cliente = sc.id_cliente
				AND sc.id_sesion_cliente = in_id_sesion_cliente
				and cu.id_bot = in_id_bot
				AND cu.marca_baja = false)
		JOIN cliente c
			ON (c.id_cliente = cu.id_cliente)
		JOIN sesion_bot sb
			ON (sc.id_sesion_bot = sb.id_sesion_bot)
		JOIN usuario u
			ON (sb.id_usuario = u.id_usuario
			   	AND u.id_operador = cu.id_operador)
	ORDER BY cu.fecha_hora_creacion DESC;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Usuario_Cliente(36,1);

--DROP FUNCTION Obtener_Usuario_Titular_Cuentas(in_id_sesion_cliente INTEGER, in_id_bot INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Usuario_Titular_Cuentas(in_id_sesion_cliente INTEGER, in_id_bot INTEGER)
RETURNS TABLE (usuario_titular_cuenta VARCHAR(100)) AS $$
DECLARE
    aux_id_cliente INTEGER;
    aux_id_operador INTEGER;
BEGIN
	aux_id_cliente := -1;
	aux_id_operador := -1;

	select sc.id_cliente, u.id_operador
	into aux_id_cliente, aux_id_operador
	from sesion_cliente sc join sesion_bot sb
			on (sc.id_sesion_bot = sb.id_sesion_bot)
		join usuario u
			on (sb.id_usuario = u.id_usuario)
	where sc.id_sesion_cliente = in_id_sesion_cliente
	LIMIT 1;

	RETURN QUERY
	SELECT	cuc.usuario_titular_cuenta
	FROM 	cliente_usuario_cuentas cuc JOIN cliente_usuario cu
		ON (cuc.id_cliente_usuario = cu.id_cliente_usuario
		   	AND cu.id_cliente = aux_id_cliente
		   	AND cu.id_bot = in_id_bot
			AND cu.id_operador = aux_id_operador
			AND cu.marca_baja = false
		   	AND cuc.id_estado_usuario_cuentas IN (1,3));
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Usuario_Titular_Cuentas(3315,1);
--select * from cliente_usuario_cuentas order by 1 desc
--select * from cliente_usuario_cuentas where usuario_titular_cuenta in ('fulanito gonzalez','dario miguel lopez','guille mengano');
--select * from cliente_usuario where id_cliente_usuario in (1163, 403)
--select * from sesion_cliente where id_cliente = 480 order by 1 desc

DROP FUNCTION Obtener_Usuario_Cargas(in_id_sesion_cliente INTEGER, in_id_bot INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Usuario_Cargas(in_id_sesion_cliente INTEGER, in_id_bot INTEGER)
RETURNS TABLE (id_operador INTEGER, cliente_cargas_cantidad INTEGER, cliente_cargas_total NUMERIC, bono_recupero BOOLEAN) AS $$
DECLARE
    aux_id_cliente INTEGER;
    aux_id_operador INTEGER;
BEGIN
	aux_id_cliente := -1;
	aux_id_operador := -1;

	select sc.id_cliente, u.id_operador
	into aux_id_cliente, aux_id_operador
	from sesion_cliente sc join sesion_bot sb
			on (sc.id_sesion_bot = sb.id_sesion_bot)
		join usuario u
			on (sb.id_usuario = u.id_usuario)
	where sc.id_sesion_cliente = in_id_sesion_cliente
	LIMIT 1;

	RETURN QUERY
	SELECT 	aux_id_operador AS id_operador, 
			CAST(COUNT(*) AS INTEGER) AS cliente_cargas_cantidad, 
			CAST(COALESCE(SUM(carga_monto), 0) AS NUMERIC) AS cliente_cargas_total,
			CASE WHEN CAST(COALESCE(MAX(sclc.fecha_hora), '1900-01-01 00:00:00') AS TIMESTAMP) > CAST(COALESCE(MAX(sclr.fecha_hora), '1900-01-01 00:00:00') AS TIMESTAMP) THEN false
				ELSE true END AS bono_recupero
	FROM notificacion_carga nc JOIN sesion_cliente sc
			ON (nc.id_sesion_cliente = sc.id_sesion_cliente
				AND nc.marca_procesado = true
				AND sc.id_cliente = aux_id_cliente
			   	and nc.id_notificacion_carga NOT IN (SELECT	na.id_notificacion_carga
												FROM	notificacion_carga_anulacion na
												UNION
												SELECT	nc.id_notificacion_carga
												FROM	notificacion_carga_cancelacion nc
												UNION
												SELECT	nd.id_notificacion_carga
												FROM	notificacion_carga_duplicacion nd))
		JOIN sesion_bot sb
			ON (sc.id_sesion_bot = sb.id_sesion_bot
			   AND sb.id_bot = in_id_bot)
		JOIN usuario u
			ON (sb.id_usuario = u.id_usuario
				AND u.id_operador = aux_id_operador)
		LEFT JOIN sesion_cliente_log sclc
			ON (sc.id_sesion_cliente = sclc.id_sesion_cliente
			   AND sclc.id_accion IN (3, 6, 10))
		LEFT JOIN sesion_cliente_log sclr
			ON (sc.id_sesion_cliente = sclr.id_sesion_cliente 
				AND sclr.id_accion IN (7));
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Usuario_Cargas(874,1);

--DROP FUNCTION Obtener_Usuario_Cliente_Monto(in_id_sesion_cliente INTEGER, in_id_bot INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Usuario_Cliente_Monto(in_id_sesion_cliente INTEGER, in_id_bot INTEGER)
RETURNS TABLE (cliente_usuario VARCHAR(200), monto VARCHAR(20)) AS $$
begin
	RETURN query SELECT cu.cliente_usuario, sc.aux_monto
	FROM cliente_usuario cu JOIN sesion_cliente sc
		ON (cu.id_cliente = sc.id_cliente
		   	AND sc.id_sesion_cliente = in_id_sesion_cliente
		   	and cu.id_bot = in_id_bot
		   	AND cu.marca_baja = false)
	JOIN sesion_bot sb
		ON (sc.id_sesion_bot = sb.id_sesion_bot)
	JOIN usuario u
		ON (sb.id_usuario = u.id_usuario
			AND u.id_operador = cu.id_operador)
	ORDER BY cu.fecha_hora_creacion DESC;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Usuario_Cliente_Monto(1,1);

CREATE OR REPLACE FUNCTION CalcularPorcentajePalabrasEncontradas(A TEXT, B TEXT) RETURNS NUMERIC AS $$
DECLARE
    palabras_encontradas INT := 0;
    total_palabras_b INT := 0;
    palabra_b TEXT;
BEGIN
    -- Dividir la cadena B en palabras y contar el total de palabras
    total_palabras_b := array_length(string_to_array(B, ' '), 1);

    -- Recorrer cada palabra de A y contar las palabras encontradas en B
    FOREACH palabra_b IN ARRAY string_to_array(B, ' ') LOOP
        IF palabra_b = ANY(string_to_array(A, ' ')) THEN
            palabras_encontradas := palabras_encontradas + 1;
        END IF;
    END LOOP;

    -- Calcular el porcentaje de palabras encontradas
    IF total_palabras_b > 0 THEN
        RETURN palabras_encontradas::NUMERIC / total_palabras_b::NUMERIC;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;
-- SELECT CalcularPorcentajePalabrasEncontradas('Guillermo Pinarello ola all', 'Guillermo Jorge Hugo Pinarello') AS porcentaje;
-- SELECT CalcularPorcentajePalabrasEncontradas('dario miguel lopez', 'dario lopez') AS porcentaje;

--DROP FUNCTION Chequeo_Transferencia_Sesion_Cliente(in_id_sesion_cliente INTEGER, in_usuario_cuenta VARCHAR(100));
CREATE OR REPLACE FUNCTION Chequeo_Transferencia_Sesion_Cliente(in_id_sesion_cliente INTEGER, in_usuario_cuenta VARCHAR(100))
RETURNS TABLE (out_id_notificacion_carga INTEGER, confirmada BOOLEAN, monto VARCHAR(30)) AS $$
DECLARE aux_tr_confirmada BOOLEAN;
DECLARE aux_id_notificacion_carga INTEGER;
DECLARE aux_monto VARCHAR(30);
DECLARE aux_cbu VARCHAR(200);
begin
	aux_tr_confirmada := false;
	aux_id_notificacion_carga := -1;
	aux_monto := '';
	
	select n.id_notificacion_carga, round(n.carga_monto,0)::varchar(30)
	into aux_id_notificacion_carga, aux_monto
	from notificacion_carga n
	-- where lower(n.carga_usuario) = in_usuario_cuenta
	where CalcularPorcentajePalabrasEncontradas(in_usuario_cuenta, lower(n.carga_usuario)) >= 0.5 
		and n.marca_procesado = false
		and n.carga_monto::numeric in (select s.aux_monto::numeric
										  from sesion_cliente s
										  where s.id_sesion_cliente = in_id_sesion_cliente);
	
	if aux_id_notificacion_carga > -1 then
		select s.aux_cbu_carga
		into aux_cbu
	    from sesion_cliente s
	    where s.id_sesion_cliente = in_id_sesion_cliente;
		
		update notificacion_carga 
		set 	marca_procesado = true, 
				fecha_hora_procesado = now(), 
				carga_cbu = aux_cbu,
				id_sesion_cliente = in_id_sesion_cliente
		where id_notificacion_carga = aux_id_notificacion_carga;
	
		aux_tr_confirmada := true;
	end if;

	RETURN query SELECT aux_id_notificacion_carga, aux_tr_confirmada, aux_monto;
END;
$$ LANGUAGE plpgsql;

--select * from Chequeo_Transferencia_Sesion_Cliente(15, 'pepe');
--select * from Chequeo_Transferencia_Sesion_Cliente(1,1);
--select * from Chequeo_Transferencia_Sesion_Cliente(166, 'maria del rosario');

--DROP FUNCTION Chequeo_Transferencia_Sesion_Cliente_Paso1(in_id_sesion_cliente INTEGER, in_usuario_cuenta VARCHAR(100));
CREATE OR REPLACE FUNCTION Chequeo_Transferencia_Sesion_Cliente_Paso1(in_id_sesion_cliente INTEGER, in_usuario_cuenta VARCHAR(100))
RETURNS TABLE (out_id_notificacion_carga INTEGER, confirmada BOOLEAN, monto VARCHAR(30), cbu VARCHAR(30), titular VARCHAR(200)) AS $$
DECLARE aux_tr_confirmada BOOLEAN;
DECLARE aux_id_notificacion_carga INTEGER;
DECLARE aux_monto VARCHAR(30);
DECLARE aux_cbu VARCHAR(200);
DECLARE aux_titular VARCHAR(200);
DECLARE aux_porcentaje_origen1 DECIMAL(10, 2);
DECLARE aux_porcentaje_origen3 DECIMAL(10, 2);
begin
	aux_tr_confirmada := false;
	aux_id_notificacion_carga := -1;
	aux_monto := '';
	aux_titular := '';
	aux_porcentaje_origen1 = 0.5;
	aux_porcentaje_origen3 = 0.25;
	
	select n.id_notificacion_carga, round(n.carga_monto,0)::varchar(30), lower(n.carga_usuario)
	into aux_id_notificacion_carga, aux_monto, aux_titular
	from notificacion_carga n join notificacion o
		on (n.id_notificacion = o.id_notificacion
		   and o.id_origen = 1)
	where CalcularPorcentajePalabrasEncontradas(in_usuario_cuenta, lower(n.carga_usuario)) >= aux_porcentaje_origen1 
		and n.marca_procesado = false
		and n.carga_monto::numeric in (select s.aux_monto::numeric
										  from sesion_cliente s
										  where s.id_sesion_cliente = in_id_sesion_cliente);
										  
	if aux_id_notificacion_carga is null then
			select n.id_notificacion_carga, round(n.carga_monto,0)::varchar(30), lower(n.carga_usuario)
			into aux_id_notificacion_carga, aux_monto, aux_titular
			from notificacion_carga n join notificacion o
				on (n.id_notificacion = o.id_notificacion
				   and o.id_origen = 3)
			where CalcularPorcentajePalabrasEncontradas(in_usuario_cuenta, lower(n.carga_usuario)) >= aux_porcentaje_origen3
				and n.marca_procesado = false
				and n.carga_monto::numeric in (select s.aux_monto::numeric
												  from sesion_cliente s
												  where s.id_sesion_cliente = in_id_sesion_cliente);
	end if;
		
	if aux_id_notificacion_carga > -1 then
		select s.aux_cbu_carga
		into aux_cbu
	    from sesion_cliente s
	    where s.id_sesion_cliente = in_id_sesion_cliente;
	
		aux_tr_confirmada := true;
	end if;

	RETURN query SELECT aux_id_notificacion_carga, aux_tr_confirmada, aux_monto, aux_cbu, aux_titular;
END;
$$ LANGUAGE plpgsql;
--select * from Chequeo_Transferencia_Sesion_Cliente_Paso1(5571, 'luca0sosa@gmail.com')
--SELECT * from Chequeo_Transferencia_Sesion_Cliente_Paso1(2859, 'lopezdar222@gmail.com')
--SELECT * from Chequeo_Transferencia_Sesion_Cliente_Paso1(2859, 'dariomiguellpez')
--SELECT * from Chequeo_Transferencia_Sesion_Cliente_Paso1(2859, 'dario miguel lopez')
--SELECT * from Chequeo_Transferencia_Sesion_Cliente_Paso1(3240, 'omar ruben')
--SELECT CalcularPorcentajePalabrasEncontradas('luca0sosa@gmail.com', 'luca0sosa@gmail.com autocervicio esqivell');

--DROP FUNCTION Chequeo_Transferencia_Sesion_Cliente_Paso2(in_id_notificacion_carga INTEGER, in_id_sesion_cliente INTEGER, in_cbu VARCHAR(200));
CREATE OR REPLACE FUNCTION Chequeo_Transferencia_Sesion_Cliente_Paso2(in_id_notificacion_carga INTEGER, in_id_sesion_cliente INTEGER, in_cbu VARCHAR(200))
RETURNS VOID AS $$
BEGIN		
		UPDATE notificacion_carga 
		SET 	marca_procesado = true, 
				fecha_hora_procesado = now(), 
				carga_cbu = in_cbu,
				id_sesion_cliente = in_id_sesion_cliente
		WHERE id_notificacion_carga = in_id_notificacion_carga;
END;
$$ LANGUAGE plpgsql;
--select Chequeo_Transferencia_Sesion_Cliente_Paso2(4167, 1910, '1430001713033674440010')

--DROP FUNCTION Chequeo_Transferencia_Sin_Procesar(in_id_sesion_cliente INTEGER, in_id_bot INTEGER);
CREATE OR REPLACE FUNCTION Chequeo_Transferencia_Sin_Procesar(in_id_sesion_cliente INTEGER, in_id_bot INTEGER)
RETURNS TABLE (confirmada BOOLEAN, titular VARCHAR(200), monto NUMERIC) AS $$
DECLARE aux_id_operador INTEGER;
DECLARE aux_tr_encontrada BOOLEAN;
DECLARE aux_titular VARCHAR(200);
DECLARE aux_monto NUMERIC;
BEGIN	
	SELECT	u.id_operador, sc.aux_monto::numeric
	INTO aux_id_operador, aux_monto
	FROM 	sesion_cliente sc JOIN sesion_bot sb
			ON (sc.id_sesion_bot = sb.id_sesion_bot
			   	AND sc.id_sesion_cliente = in_id_sesion_cliente
			   	AND sb.id_bot = in_id_bot)
		JOIN usuario u
			ON (sb.id_usuario = u.id_usuario);

	SELECT	true, nc.carga_usuario
	INTO 	aux_tr_encontrada, aux_titular
	FROM	notificacion_carga nc JOIN notificacion n
			ON (nc.id_notificacion = n.id_notificacion
			   /*AND nc.carga_usuario IN (SELECT cb.nombre
									   	FROM cuenta_bancaria cb
									   	WHERE cb.id_operador = aux_id_operador
									   	AND cb.marca_baja = false)*/
				AND nc.marca_procesado = false
				AND nc.id_sesion_cliente IS NULL
			   	AND nc.carga_monto = aux_monto)
		JOIN usuario u
			ON (u.id_usuario = n.id_usuario
			   	AND u.id_operador = aux_id_operador)
	ORDER BY n.id_notificacion DESC
	LIMIT 1;

	IF aux_tr_encontrada IS NULL THEN
		aux_tr_encontrada := false;
		aux_titular := '';
	END IF;
	
	RETURN QUERY SELECT aux_tr_encontrada, aux_titular, aux_monto;
END;
$$ LANGUAGE plpgsql;
--select * from Chequeo_Transferencia_Sin_Procesar(7787, 1)
--select * from Chequeo_Transferencia_Sin_Procesar(7966, 1)

--DROP FUNCTION Notificacion_Duplicada_PanlesNoti(in_id_notificacion INTEGER, in_id_notificacion_carga INTEGER);
CREATE OR REPLACE FUNCTION Notificacion_Duplicada_PanlesNoti(in_id_notificacion INTEGER, in_id_notificacion_carga INTEGER)
RETURNS TABLE (duplicada BOOLEAN, id_notificacion_carga INTEGER) AS $$
DECLARE aux_id_notificacion_carga INTEGER;
DECLARE aux_marca_procesado BOOLEAN;
DECLARE aux_duplicada BOOLEAN;
BEGIN
	aux_id_notificacion_carga := -1;
	aux_marca_procesado := false;
	aux_duplicada := false;
	
	SELECT	nc2.id_notificacion_carga, nc2.marca_procesado
	INTO aux_id_notificacion_carga, aux_marca_procesado
	FROM	notificacion_carga nc JOIN notificacion n
				ON (nc.id_notificacion = n.id_notificacion
					AND nc.id_notificacion_carga = in_id_notificacion_carga
					AND n.id_notificacion = in_id_notificacion)
			JOIN usuario u
				ON (n.id_usuario = u.id_usuario)
			JOIN notificacion n2 
				ON (n.aplicacion = n2.aplicacion
					AND n2.id_origen = 3
					AND n.fecha_hora >= n2.fecha_hora - INTERVAL '90 seconds'
					AND n.fecha_hora <= n2.fecha_hora + INTERVAL '90 seconds')
			JOIN notificacion_carga nc2
				ON (nc2.id_notificacion = n2.id_notificacion
					AND nc2.carga_monto = nc.carga_monto)
			JOIN usuario u2
				ON (n2.id_usuario = u2.id_usuario
				   AND u.id_operador = u2.id_operador);
	
	IF aux_id_notificacion_carga > -1 THEN
	
			aux_duplicada := true;
	
			UPDATE 	notificacion_carga
			SET		marca_procesado = true
			WHERE 	notificacion_carga.id_notificacion_carga = in_id_notificacion_carga;
			
			IF aux_marca_procesado = false THEN
				UPDATE notificacion_carga
				SET carga_usuario = CONCAT(n2.carga_usuario, ' ', notificacion_carga.carga_usuario)
				FROM 	notificacion_carga n2
				WHERE 	n2.id_notificacion_carga = in_id_notificacion_carga
				AND notificacion_carga.id_notificacion_carga = aux_id_notificacion_carga;				
			END IF;	
			
			INSERT INTO notificacion_carga_duplicacion (id_notificacion_carga, fecha_hora_duplicado, observacion)
			VALUES	(in_id_notificacion_carga,now(),CONCAT('API MP : ', aux_id_notificacion_carga));		
	END IF;

	RETURN query SELECT aux_duplicada, aux_id_notificacion_carga;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Notificacion_Duplicada_PanlesNoti(5830, 5352);
--SELECT * FROM Notificacion_Duplicada_PanlesNoti(5896, 5402);

--DROP FUNCTION Notificacion_Duplicada_API_MercadoPago(in_id_notificacion INTEGER, in_id_notificacion_carga INTEGER);
CREATE OR REPLACE FUNCTION Notificacion_Duplicada_API_MercadoPago(in_id_notificacion INTEGER, in_id_notificacion_carga INTEGER)
RETURNS TABLE (duplicada BOOLEAN, id_notificacion_carga INTEGER) AS $$
DECLARE aux_id_notificacion_carga INTEGER;
DECLARE aux_marca_procesado BOOLEAN;
DECLARE aux_duplicada BOOLEAN;
BEGIN
	aux_id_notificacion_carga := -1;
	aux_marca_procesado := false;
	aux_duplicada := false;
	
	SELECT	nc2.id_notificacion_carga, nc2.marca_procesado
	INTO aux_id_notificacion_carga, aux_marca_procesado
	FROM	notificacion_carga nc JOIN notificacion n
				ON (nc.id_notificacion = n.id_notificacion
					AND nc.id_notificacion_carga = in_id_notificacion_carga
					AND n.id_notificacion = in_id_notificacion)
			JOIN notificacion n2 
				ON (n.aplicacion = n2.aplicacion
					AND n2.id_origen = 1
					AND n.fecha_hora >= n2.fecha_hora - INTERVAL '90 seconds'
					AND n.fecha_hora <= n2.fecha_hora + INTERVAL '90 seconds')
			JOIN notificacion_carga nc2
				ON (nc2.id_notificacion = n2.id_notificacion
					AND nc2.carga_monto = nc.carga_monto);
					
	
	IF aux_id_notificacion_carga > -1 THEN
	
			aux_duplicada := true;
	
			UPDATE 	notificacion_carga
			SET		marca_procesado = true
			WHERE 	notificacion_carga.id_notificacion_carga = in_id_notificacion_carga;
			
			IF aux_marca_procesado = false THEN
				UPDATE notificacion_carga
				SET carga_usuario = CONCAT(notificacion_carga.carga_usuario, ' ', n2.carga_usuario)
				FROM 	notificacion_carga n2
				WHERE 	n2.id_notificacion_carga = in_id_notificacion_carga
				AND notificacion_carga.id_notificacion_carga = aux_id_notificacion_carga;				
			END IF;	
			
			INSERT INTO notificacion_carga_duplicacion (id_notificacion_carga, fecha_hora_duplicado, observacion)
			VALUES	(in_id_notificacion_carga,now(),CONCAT('API MP : ', aux_id_notificacion_carga));		
	END IF;

	RETURN query SELECT aux_duplicada, aux_id_notificacion_carga;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Notificacion_Duplicada_API_MercadoPago(5830, 5352);


--DROP FUNCTION Actualizacion_Cliente_Cuentas(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER, in_titular VARCHAR(200))
CREATE OR REPLACE FUNCTION Actualizacion_Cliente_Cuentas(in_id_sesion_cliente INTEGER, in_id_notificacion_carga INTEGER, in_titular VARCHAR(200))
RETURNS TABLE (out_id_cliente_usuario_cuenta INTEGER, out_id_estado_usuario_cuentas INTEGER, out_titular_cuenta VARCHAR(30)) AS $$
DECLARE aux_titular_cuenta VARCHAR(200);
DECLARE aux_id_cliente_usuario INTEGER;
DECLARE aux_id_operador INTEGER;
DECLARE aux_id_cliente_usuario_cuenta INTEGER;
DECLARE aux_id_cliente_usuario_cuenta_enc INTEGER;
DECLARE aux_id_operador_enc INTEGER;
DECLARE aux_id_cliente_usuario_dif INTEGER;
DECLARE aux_id_operador_dif INTEGER;
DECLARE aux_id_estado_usuario_cuentas_dif INTEGER;
DECLARE aux_id_usuario INTEGER;
DECLARE aux_id_estado_usuario_cuentas INTEGER;
begin
	aux_titular_cuenta := in_titular;
	aux_id_usuario := 0;
	aux_id_cliente_usuario := 0;
	aux_id_operador := 0;
	aux_id_cliente_usuario_cuenta := 0;
	aux_id_estado_usuario_cuentas := 0;
	
	aux_id_cliente_usuario_cuenta_enc := 0;
	aux_id_operador_enc := 0;
	
	aux_id_cliente_usuario_dif := 0;
	aux_id_operador_dif := 0;
	aux_id_estado_usuario_cuentas_dif := 0;
	
	/*SELECT	nc.carga_usuario
	INTO aux_titular_cuenta
	FROM 	notificacion_carga nc
	WHERE nc.id_notificacion_carga = in_id_notificacion_carga
		AND nc.id_sesion_cliente = in_id_sesion_cliente;*/
		
	SELECT	cu.id_cliente_usuario, cu.id_operador
	INTO aux_id_cliente_usuario, aux_id_operador
	FROM 	sesion_cliente sc JOIN sesion_bot sb
			ON (sc.id_sesion_cliente = in_id_sesion_cliente
			   	AND sc.id_sesion_bot = sb.id_sesion_bot)
		JOIN cliente_usuario cu
			ON (sc.id_cliente = cu.id_cliente
			   	AND cu.id_bot = sb.id_bot
			   	AND cu.marca_baja = false)
		JOIN cuenta_numero cn
			ON (cn.id_cuenta_numero = sb.id_cuenta_numero)
		JOIN usuario u
			ON (cn.id_usuario = u.id_usuario
			   AND cu.id_operador = u.id_operador);
				
	SELECT	u.id_usuario
	INTO 	aux_id_usuario
	FROM 	usuario u
	WHERE	u.id_operador = aux_id_operador
		AND id_rol = 2;
	
	IF NOT EXISTS (	SELECT	1
				   	FROM 	cliente_usuario_cuentas cuc
				   	WHERE	cuc.usuario_titular_cuenta = aux_titular_cuenta
		) THEN
			INSERT INTO cliente_usuario_cuentas (id_cliente_usuario, usuario_titular_cuenta, fecha_hora_creacion, fecha_hora_ultima_modificacion, usuario_ultima_modificacion, id_estado_usuario_cuentas)
			VALUES 	(aux_id_cliente_usuario, aux_titular_cuenta, now(), now(), aux_id_usuario, 1)
			RETURNING cliente_usuario_cuentas.id_cliente_usuario_cuenta INTO aux_id_cliente_usuario_cuenta;
			aux_id_estado_usuario_cuentas := 1;
	ELSE
		
		SELECT	cuc.id_cliente_usuario_cuenta, 
				cu.id_operador
		INTO 	aux_id_cliente_usuario_cuenta_enc, 
				aux_id_operador_enc
		FROM 	cliente_usuario_cuentas cuc JOIN cliente_usuario cu
				ON (cuc.id_cliente_usuario = cu.id_cliente_usuario
					AND cu.id_cliente_usuario = aux_id_cliente_usuario
				   	AND cuc.usuario_titular_cuenta = aux_titular_cuenta)
		ORDER BY cuc.id_estado_usuario_cuentas DESC LIMIT 1;

		SELECT	cuc.id_cliente_usuario, 
				cu.id_operador,
				cuc.id_estado_usuario_cuentas
		INTO 	aux_id_cliente_usuario_dif, 
				aux_id_operador_dif, 
				aux_id_estado_usuario_cuentas_dif
		FROM 	cliente_usuario_cuentas cuc JOIN cliente_usuario cu
				ON (cuc.id_cliente_usuario = cu.id_cliente_usuario
					AND cu.id_cliente_usuario <> aux_id_cliente_usuario
				   	AND cuc.usuario_titular_cuenta = aux_titular_cuenta)
		ORDER BY cuc.id_estado_usuario_cuentas DESC LIMIT 1;
		
		IF aux_id_estado_usuario_cuentas_dif = 5 THEN
			IF aux_id_cliente_usuario_cuenta_enc IS NULL THEN
				INSERT INTO cliente_usuario_cuentas (id_cliente_usuario, usuario_titular_cuenta, fecha_hora_creacion, fecha_hora_ultima_modificacion, usuario_ultima_modificacion, id_estado_usuario_cuentas)
				VALUES 	(aux_id_cliente_usuario, aux_titular_cuenta, now(), now(), aux_id_usuario, 5)
				RETURNING cliente_usuario_cuentas.id_cliente_usuario_cuenta INTO aux_id_cliente_usuario_cuenta;
			ELSE
				UPDATE cliente_usuario_cuentas
				SET id_estado_usuario_cuentas = 5,
					usuario_ultima_modificacion = aux_id_usuario,
					fecha_hora_ultima_modificacion = now()
				WHERE id_cliente_usuario_cuenta = aux_id_cliente_usuario_cuenta_enc;
			END IF;
				
			aux_id_estado_usuario_cuentas := 5;				
		END IF;
		
		IF aux_id_estado_usuario_cuentas_dif = 4 THEN
			IF aux_id_cliente_usuario_cuenta_enc IS NULL THEN
				INSERT INTO cliente_usuario_cuentas (id_cliente_usuario, usuario_titular_cuenta, fecha_hora_creacion, fecha_hora_ultima_modificacion, usuario_ultima_modificacion, id_estado_usuario_cuentas)
				VALUES 	(aux_id_cliente_usuario, aux_titular_cuenta, now(), now(), aux_id_usuario, 1)
				RETURNING cliente_usuario_cuentas.id_cliente_usuario_cuenta INTO aux_id_cliente_usuario_cuenta;
			ELSE
				UPDATE cliente_usuario_cuentas
				SET id_estado_usuario_cuentas = 1,
					usuario_ultima_modificacion = aux_id_usuario,
					fecha_hora_ultima_modificacion = now()
				WHERE id_cliente_usuario_cuenta = aux_id_cliente_usuario_cuenta_enc;
			END IF;
			
			aux_id_estado_usuario_cuentas := 1;
		END IF;
		
		IF aux_id_estado_usuario_cuentas_dif = 3 THEN
			IF aux_id_cliente_usuario_cuenta_enc IS NULL THEN
				INSERT INTO cliente_usuario_cuentas (id_cliente_usuario, usuario_titular_cuenta, fecha_hora_creacion, fecha_hora_ultima_modificacion, usuario_ultima_modificacion, id_estado_usuario_cuentas)
				VALUES 	(aux_id_cliente_usuario, aux_titular_cuenta, now(), now(), aux_id_usuario, 2)
				RETURNING cliente_usuario_cuentas.id_cliente_usuario_cuenta INTO aux_id_cliente_usuario_cuenta;
			ELSE
				UPDATE cliente_usuario_cuentas
				SET id_estado_usuario_cuentas = 2,
					usuario_ultima_modificacion = aux_id_usuario,
					fecha_hora_ultima_modificacion = now()
				WHERE id_cliente_usuario_cuenta = aux_id_cliente_usuario_cuenta_enc;
			END IF;
			
			aux_id_estado_usuario_cuentas := 2;
		END IF;

		IF aux_id_estado_usuario_cuentas_dif = 2 THEN
			IF aux_id_cliente_usuario_cuenta_enc IS NULL THEN
				INSERT INTO cliente_usuario_cuentas (id_cliente_usuario, usuario_titular_cuenta, fecha_hora_creacion, fecha_hora_ultima_modificacion, usuario_ultima_modificacion, id_estado_usuario_cuentas)
				VALUES 	(aux_id_cliente_usuario, aux_titular_cuenta, now(), now(), aux_id_usuario, 1)
				RETURNING cliente_usuario_cuentas.id_cliente_usuario_cuenta INTO aux_id_cliente_usuario_cuenta;
			ELSE
				UPDATE cliente_usuario_cuentas
				SET id_estado_usuario_cuentas = 1,
					usuario_ultima_modificacion = aux_id_usuario,
					fecha_hora_ultima_modificacion = now()
				WHERE id_cliente_usuario_cuenta = aux_id_cliente_usuario_cuenta_enc;
			END IF;
			
			aux_id_estado_usuario_cuentas := 1;
		END IF;
		
		IF aux_id_estado_usuario_cuentas_dif = 1 THEN
			UPDATE cliente_usuario_cuentas
			SET id_estado_usuario_cuentas = 2,
				usuario_ultima_modificacion = aux_id_usuario,
				fecha_hora_ultima_modificacion = now()
			WHERE id_cliente_usuario = aux_id_cliente_usuario_dif
				AND usuario_titular_cuenta = aux_titular_cuenta;
			
			IF aux_id_cliente_usuario_cuenta_enc IS NULL THEN
				INSERT INTO cliente_usuario_cuentas (id_cliente_usuario, usuario_titular_cuenta, fecha_hora_creacion, fecha_hora_ultima_modificacion, usuario_ultima_modificacion, id_estado_usuario_cuentas)
				VALUES 	(aux_id_cliente_usuario, aux_titular_cuenta, now(), now(), aux_id_usuario, 1)
				RETURNING cliente_usuario_cuentas.id_cliente_usuario_cuenta INTO aux_id_cliente_usuario_cuenta;
			ELSE
				UPDATE cliente_usuario_cuentas
				SET id_estado_usuario_cuentas = 1,
					usuario_ultima_modificacion = aux_id_usuario,
					fecha_hora_ultima_modificacion = now()
				WHERE id_cliente_usuario_cuenta = aux_id_cliente_usuario_cuenta_enc;
			END IF;
			
			aux_id_estado_usuario_cuentas := 1;
		END IF;
		
		IF aux_id_operador_enc <> aux_id_operador_dif THEN
			IF aux_id_cliente_usuario_cuenta_enc IS NULL THEN
				INSERT INTO cliente_usuario_cuentas (id_cliente_usuario, usuario_titular_cuenta, fecha_hora_creacion, fecha_hora_ultima_modificacion, usuario_ultima_modificacion, id_estado_usuario_cuentas)
				VALUES 	(aux_id_cliente_usuario, aux_titular_cuenta, now(), now(), aux_id_usuario, 5)
				RETURNING cliente_usuario_cuentas.id_cliente_usuario_cuenta INTO aux_id_cliente_usuario_cuenta;
			ELSE
				UPDATE cliente_usuario_cuentas
				SET id_estado_usuario_cuentas = 5,
					usuario_ultima_modificacion = aux_id_usuario,
					fecha_hora_ultima_modificacion = now()
				WHERE id_cliente_usuario_cuenta = aux_id_cliente_usuario_cuenta_enc;
			END IF;
			aux_id_estado_usuario_cuentas := 5;
		END IF;
		
	END IF;	
	
	RETURN query SELECT aux_id_cliente_usuario_cuenta, aux_id_estado_usuario_cuentas, aux_titular_cuenta;
END;
$$ LANGUAGE plpgsql;

--select * from cliente;
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Creación de Usuario', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Desbloqueo de Usuario', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Carga de Fichas', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Retiro de Fichas', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Cambio de Contraseña', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Carga Manual de Fichas', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Mensaje de Recupero', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Advertencia Fraude', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Retiro Manual de Fichas', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Carga Automática de Fichas', now(), now(), false);
insert into sesion_accion(nombre_accion, fecha_hora_creacion, fecha_hora_ultima_modificacion, marca_baja)
values ('Carga Bono Creación Usuario', now(), now(), false);
--select * from sesion_accion;

--DROP FUNCTION Registrar_Notificacion(in_numero_telefono VARCHAR(200), in_id_operador INTEGER, in_aplicacion VARCHAR(200), in_titulo VARCHAR(100), in_mensaje VARCHAR(200), in_id_notificacion_origen VARCHAR(200), in_id_origen INTEGER)
CREATE OR REPLACE FUNCTION Registrar_Notificacion(in_numero_telefono VARCHAR(200), in_id_usuario INTEGER, in_aplicacion VARCHAR(200), in_titulo VARCHAR(100), in_mensaje VARCHAR(200), in_id_notificacion_origen VARCHAR(200), in_id_origen INTEGER)
RETURNS TABLE (id_notificacion INTEGER) AS $$
DECLARE aux_id_notificacion INTEGER;
BEGIN
    -- Iniciar transacción explícita
    BEGIN
        -- Bloquear la tabla notificacion para evitar conflictos
        LOCK TABLE notificacion IN EXCLUSIVE MODE;
		
		IF EXISTS (	SELECT 1
					FROM notificacion
					WHERE id_notificacion_origen = in_id_notificacion_origen
						AND aplicacion = in_aplicacion
						AND titulo = in_titulo
						AND titulo != 'Carga Manual'
						AND mensaje = in_mensaje
						AND id_origen = in_id_origen) THEN
			-- Si ya existe, establecer aux_id_notificacion a -1
			aux_id_notificacion := -1;

		ELSE
			-- Si no existe, insertar nueva notificación y obtener el ID insertado
			INSERT INTO notificacion (numero_telefono, id_usuario, aplicacion, titulo, mensaje, fecha_hora, id_notificacion_origen, id_origen)
			VALUES (in_numero_telefono, in_id_usuario, in_aplicacion, in_titulo, in_mensaje, now(), in_id_notificacion_origen, in_id_origen)
			RETURNING notificacion.id_notificacion into aux_id_notificacion;

		END IF;
    END;
	
	RETURN QUERY SELECT aux_id_notificacion;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Registrar_Notificacion('5491131961299', 'Mercado Pago', 'Recibiste cero pesos', '');
--SELECT * FROM notificacion order by 1 desc;

CREATE OR REPLACE FUNCTION Registrar_Notificacion(in_numero_telefono VARCHAR(200), in_id_usuario INTEGER, in_aplicacion VARCHAR(200), in_titulo VARCHAR(100), in_mensaje VARCHAR(200), in_id_notificacion_origen VARCHAR(200), in_id_origen INTEGER)
RETURNS TABLE (id_notificacion INTEGER) AS $$
DECLARE aux_id_notificacion INTEGER;
BEGIN
	IF EXISTS (	SELECT 1
				FROM notificacion
				WHERE id_notificacion_origen = in_id_notificacion_origen
					AND aplicacion = in_aplicacion
					AND titulo = in_titulo
					AND titulo != 'Carga Manual'
					AND mensaje = in_mensaje
					AND id_origen = in_id_origen) THEN
		-- Si ya existe, establecer aux_id_notificacion a -1
		aux_id_notificacion := -1;

	ELSE
		-- Si no existe, insertar nueva notificación y obtener el ID insertado
		INSERT INTO notificacion (numero_telefono, id_usuario, aplicacion, titulo, mensaje, fecha_hora, id_notificacion_origen, id_origen)
		VALUES (in_numero_telefono, in_id_usuario, in_aplicacion, in_titulo, in_mensaje, now(), in_id_notificacion_origen, in_id_origen)
		RETURNING notificacion.id_notificacion into aux_id_notificacion;

	END IF;
	
	RETURN QUERY SELECT aux_id_notificacion;
END;
$$ LANGUAGE plpgsql;


--DROP FUNCTION Registrar_Notificacion_Panelesnoti(in_numero_telefono VARCHAR(200), in_id_operador INTEGER, in_aplicacion VARCHAR(200), in_titulo VARCHAR(100), in_mensaje VARCHAR(200), in_id_notificacion_origen VARCHAR(200))
CREATE OR REPLACE FUNCTION Registrar_Notificacion_Panelesnoti(in_numero_telefono VARCHAR(200), in_id_usuario INTEGER, in_aplicacion VARCHAR(200), in_titulo VARCHAR(100), in_mensaje VARCHAR(200), in_id_notificacion_origen VARCHAR(200))
RETURNS TABLE (id_notificacion_panelesnoti INTEGER) AS $$
DECLARE aux_id_notificacion_panelesnoti INTEGER;
BEGIN
	IF EXISTS (	SELECT 1
				FROM notificacion_panelesnoti
				WHERE id_notificacion_origen = in_id_notificacion_origen
			   		AND aplicacion = in_aplicacion
			   		AND titulo = in_titulo
			   		AND titulo != 'Carga Manual'
			   		AND mensaje = in_mensaje) THEN
					
		aux_id_notificacion_panelesnoti := -1;
		
	ELSE
	
		INSERT INTO notificacion_panelesnoti (numero_telefono, id_usuario, aplicacion, titulo, mensaje, fecha_hora, id_notificacion_origen)
		VALUES (in_numero_telefono, in_id_usuario, in_aplicacion, in_titulo, in_mensaje, now(), in_id_notificacion_origen)
		RETURNING notificacion_panelesnoti.id_notificacion_panelesnoti into aux_id_notificacion_panelesnoti;
		
	END IF;
	
	RETURN QUERY SELECT aux_id_notificacion_panelesnoti;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Registrar_Notificacion_Panelesnoti('5491131961299', 2, 'Mercado Pago', 'Recibiste cero pesos', 'de alguien', '');
--SELECT * FROM notificacion_panelesnoti order by 1 desc;

--DROP FUNCTION Registrar_Notificacion_Carga(in_id_notificacion INTEGER, in_carga_usuario VARCHAR(100), in_carga_monto NUMERIC)
CREATE OR REPLACE FUNCTION Registrar_Notificacion_Carga(in_id_notificacion INTEGER, in_carga_usuario VARCHAR(100), in_carga_monto NUMERIC)
RETURNS TABLE (id_notificacion_carga INTEGER) AS $$
DECLARE aux_id_notificacion_carga INTEGER;
BEGIN
	insert into notificacion_carga (id_notificacion, carga_usuario, carga_monto, marca_procesado, fecha_hora_procesado)
	values (in_id_notificacion, in_carga_usuario, in_carga_monto, false, now())
	RETURNING notificacion_carga.id_notificacion_carga into aux_id_notificacion_carga;
	
	RETURN QUERY SELECT aux_id_notificacion_carga;
END;
$$ LANGUAGE plpgsql;
--select Registrar_Notificacion_Carga(9, 'pepe', 1500);
--SELECT * FROM notificacion order by 1 desc;
--SELECT * FROM notificacion_carga order by 1 desc;
--SELECT * FROM notificacion_carga_motivo order by 1 desc;

--DROP FUNCTION Registrar_Notificacion_Carga_Manual(in_id_notificacion INTEGER, in_carga_usuario VARCHAR(100), in_carga_monto NUMERIC)
CREATE OR REPLACE FUNCTION Registrar_Notificacion_Carga_Manual(in_id_notificacion INTEGER, in_carga_usuario VARCHAR(100), in_carga_monto NUMERIC)
RETURNS TABLE (id_notificacion_carga INTEGER) AS $$
DECLARE aux_id_notificacion_carga INTEGER;
BEGIN
	insert into notificacion_carga (id_notificacion, carga_usuario, carga_monto, marca_procesado, fecha_hora_procesado)
	values (in_id_notificacion, in_carga_usuario, in_carga_monto, false, now())
	RETURNING notificacion_carga.id_notificacion_carga into aux_id_notificacion_carga;
	
	RETURN QUERY SELECT aux_id_notificacion_carga;
END;
$$ LANGUAGE plpgsql;
--select Registrar_Notificacion_Carga(9, 'pepe', 1500);

Insert into notificacion_carga_manual_motivo (carga_manual_motivo, marca_baja, fecha_hora_carga)
Values ('1) Aplicación PanelesNoti Cerrada', false, now());
Insert into notificacion_carga_manual_motivo (carga_manual_motivo, marca_baja, fecha_hora_carga)
Values ('2) No llegó la notificación', false, now());
Insert into notificacion_carga_manual_motivo (carga_manual_motivo, marca_baja, fecha_hora_carga)
Values ('3) Llegó la notificación a PanelesNoti pero no al Sistema', false, now());
Insert into notificacion_carga_manual_motivo (carga_manual_motivo, marca_baja, fecha_hora_carga)
Values ('4) Envío de transferencia con centavos', false, now());
Insert into notificacion_carga_manual_motivo (carga_manual_motivo, marca_baja, fecha_hora_carga)
Values ('5) Otro Motivo', false, now());
--select * from notificacion_carga_manual_motivo;
--select * from notificacion_carga_motivo;
/*
update notificacion_carga_manual_motivo 
set carga_manual_motivo = '1) Aplicación PanelesNoti Cerrada'
where id_notificacion_carga_manual_motivo = 1;
update notificacion_carga_manual_motivo 
set carga_manual_motivo = '2) No llegó la notificación'
where id_notificacion_carga_manual_motivo = 2;
update notificacion_carga_manual_motivo 
set carga_manual_motivo = '3) Llegó la notificación a PanelesNoti pero no al Sistema'
where id_notificacion_carga_manual_motivo = 5;
update notificacion_carga_manual_motivo 
set carga_manual_motivo = '4) Envío de transferencia con centavos'
where id_notificacion_carga_manual_motivo = 3;
update notificacion_carga_manual_motivo 
set carga_manual_motivo = '5) Otro Motivo'
where id_notificacion_carga_manual_motivo = 4;
*/

--DROP FUNCTION Obtener_AppsCobro();
CREATE OR REPLACE FUNCTION Obtener_AppsCobro()
RETURNS TABLE (id_cuenta_bancaria_aplicacion INTEGER, nombre_aplicacion VARCHAR(100), notificacion_descripcion VARCHAR(100), marca_baja BOOLEAN) AS $$
begin
	RETURN query 
	SELECT 	c.id_cuenta_bancaria_aplicacion, 
			c.nombre_aplicacion, 
			c.notificacion_descripcion,
			c.marca_baja
	FROM cuenta_bancaria_aplicacion c;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_AppsCobro();

--DROP FUNCTION Obtener_Operador();
CREATE OR REPLACE FUNCTION Obtener_Operador()
RETURNS TABLE (id_operador INTEGER, operador VARCHAR(100)) AS $$
begin
	RETURN query 
	SELECT 	o.id_operador, 
			o.operador
	FROM operador o;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Operador();

--DROP FUNCTION Obtener_Ultimo_Retiro_Cliente(in_id_sesion_cliente INTEGER)
CREATE OR REPLACE FUNCTION Obtener_Ultimo_Retiro_Cliente(in_id_sesion_cliente INTEGER)
RETURNS TABLE (horas_transcurridas INTEGER) AS $$
DECLARE aux_horas_transcurridas INTEGER;
BEGIN

 	SELECT FLOOR(EXTRACT(EPOCH FROM (now() - scl.fecha_hora)) / 3600) AS diferencia_horas
 	INTO aux_horas_transcurridas
 	FROM sesion_cliente sc JOIN sesion_bot sb
		ON (sc.id_sesion_bot = sb.id_sesion_bot
		   	AND sc.id_sesion_cliente = in_id_sesion_cliente)
	JOIN sesion_cliente sc2
		ON (sc2.id_cliente = sc.id_cliente)
	JOIN sesion_bot sb2
		ON (sc2.id_sesion_bot = sb2.id_sesion_bot
		   AND sb2.id_bot = sb.id_bot)
	JOIN sesion_cliente_log scl  
 		ON (scl.id_sesion_cliente = sc2.id_sesion_cliente
		   and id_accion IN (4,9)) --Retiro de Fichas
	ORDER BY scl.id_sesion_cliente_log DESC LIMIT 1;

	RETURN QUERY SELECT COALESCE(aux_horas_transcurridas, -1);
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Ultimo_Retiro_Cliente(862);
--select * from Obtener_Ultimo_Retiro_Cliente(861);

--DROP FUNCTION Obtener_Ultimo_Bono_Cliente(in_id_sesion_cliente INTEGER)
CREATE OR REPLACE FUNCTION Obtener_Ultimo_Bono_Cliente(in_id_sesion_cliente INTEGER)
RETURNS TABLE (carga INTEGER, bono INTEGER) AS $$
DECLARE aux_carga INTEGER;
DECLARE aux_bono INTEGER;
DECLARE aux_ult_retiro TIMESTAMP;
BEGIN
	
 	SELECT scl.fecha_hora
 	INTO aux_ult_retiro
 	FROM sesion_cliente sc JOIN sesion_bot sb
		ON (sc.id_sesion_bot = sb.id_sesion_bot
		   	AND sc.id_sesion_cliente = in_id_sesion_cliente)
	JOIN sesion_cliente sc2
		ON (sc2.id_cliente = sc.id_cliente)
	JOIN sesion_bot sb2
		ON (sc2.id_sesion_bot = sb2.id_sesion_bot
		   AND sb2.id_bot = sb.id_bot)
	JOIN sesion_cliente_log scl  
 		ON (scl.id_sesion_cliente = sc2.id_sesion_cliente
		   and id_accion = 4) --Retiro de Fichas
	ORDER BY scl.id_sesion_cliente_log DESC LIMIT 1;
	
	IF aux_ult_retiro IS NULL THEN 
		aux_ult_retiro := '1900-01-01 12:00:00.000000';
	END IF;
	
	SELECT 	SUM(cargas.carga),	SUM(cargas.bono)
	INTO aux_carga, aux_bono
	FROM (
		SELECT 	CAST(TRIM(split_part(split_part(scl.observacion, '-', 1), ':', 2)) AS INTEGER) as carga, 
				CAST(CASE
					WHEN TRIM(split_part(split_part(scl.observacion, '-', 2), ':', 2)) = '' THEN '0'
					ELSE TRIM(split_part(split_part(scl.observacion, '-', 2), ':', 2))
				END AS INTEGER) AS bono
		FROM sesion_cliente sc JOIN sesion_bot sb
			ON (sc.id_sesion_bot = sb.id_sesion_bot
				AND sc.id_sesion_cliente = in_id_sesion_cliente)
		JOIN sesion_cliente sc2
			ON (sc2.id_cliente = sc.id_cliente)
		JOIN sesion_bot sb2
			ON (sc2.id_sesion_bot = sb2.id_sesion_bot
			   AND sb2.id_bot = sb.id_bot)
		JOIN sesion_cliente_log scl  
			ON (scl.id_sesion_cliente = sc2.id_sesion_cliente
				AND scl.fecha_hora > aux_ult_retiro
				AND id_accion = 3)) as cargas;

	RETURN QUERY SELECT COALESCE(aux_carga, 0), COALESCE(aux_bono, 0);
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Ultimo_Bono_Cliente(865);
--select * from Obtener_Ultimo_Bono_Cliente(839);
--select * from Obtener_Ultimo_Bono_Cliente(3299);

--------------Vistas de Monitoreo y Gestión---------------------
--(excepto v_Cuenta_Bancaria_Activa)
--DROP VIEW v_Console_Logs;
CREATE OR REPLACE VIEW v_Console_Logs AS
SELECT 	cl.mensaje_log, 
		cl.ip, 
		cl.fecha_hora, 
		cl.id 
FROM console_logs cl
ORDER BY cl.id DESC;
--select * from v_Console_Logs;

--DROP VIEW v_Sesion_Bot;
CREATE OR REPLACE VIEW v_Sesion_Bot AS
SELECT 	o.operador,
		cn.id_cuenta_numero as id_numero_telefono,
		cn.numero_telefono,
		u.id_operador,
		us.username as usuario_sesion,
		u.username as usuario,
		sb.id_sesion_bot,
		sb.id_bot,
		b.nombre_bot,
		CASE 
			WHEN sb.id_bot = 1 THEN o.usuario_panel_nombre_bot1
			WHEN sb.id_bot = 2 THEN o.usuario_panel_nombre_bot2
			WHEN sb.id_bot = 3 THEN o.usuario_panel_nombre_bot3
			WHEN sb.id_bot = 4 THEN o.usuario_panel_nombre_bot4
			ELSE '-'
		END AS usuario_panel_nombre,
		b.pagina_panel_admin,
		b.casino,
		sb.id_usuario,
		sb.id_cuenta_numero,
		sb.id_estado,
		es.estado as estado_sesion,
		sb.fecha_hora_creacion,
		sb.fecha_hora_cierre,
		CASE
			WHEN cnt.telegram_token IS NULL THEN false
			ELSE true
		END AS cuenta_telegram,
		DENSE_RANK() OVER (PARTITION BY cn.numero_telefono
						   ORDER BY coalesce(sb.id_sesion_bot, 0) DESC) as orden
FROM cuenta_numero cn join usuario u
		on (cn.id_usuario = u.id_usuario
		   	and cn.marca_baja = false)
	join operador o
		on (u.id_operador = o.id_operador)
	join bot b
		on (cn.id_bot = b.id_bot)
	left join sesion_bot sb
		on (sb.id_bot = b.id_bot
		   and sb.id_cuenta_numero = cn.id_cuenta_numero)
	left join estado_sesion es
		on (sb.id_estado = es.id_estado)
	left join usuario us
		on (sb.id_usuario = us.id_usuario)
	left join cuenta_numero_telegram cnt
		on (cnt.id_cuenta_numero = cn.id_cuenta_numero);
--select * from v_Sesion_Bot;

--DROP VIEW v_Cliente_Usuario_Orden;
CREATE OR REPLACE VIEW v_Cliente_Usuario_Orden AS
SELECT 	c.id_cliente, 
		c.cliente_numero, 
		c.cliente_nombre, 
		c.lista_negra,
		cu.id_cliente_usuario,
		cu.cliente_usuario,
		cu.marca_baja,
		cu.id_bot,
		b.pagina_panel_admin as panel,
		o.id_operador,
		o.operador,
		max(fecha_hora) as fecha_hora_ultima_accion
from cliente c join cliente_usuario cu
		on (c.id_cliente = cu.id_cliente)
	join bot b
		on (cu.id_bot = b.id_bot)
	join operador o
		on (cu.id_operador = o.id_operador)
	join sesion_bot sb
		on (sb.id_bot = b.id_bot)
	join sesion_cliente sc
		on (sc.id_sesion_bot = sb.id_sesion_bot
		   and sc.id_cliente = c.id_cliente)
	join sesion_cliente_log scl
		on (sc.id_sesion_cliente = scl.id_sesion_cliente)
group by c.id_cliente, 
		c.cliente_numero, 
		c.cliente_nombre, 
		c.lista_negra,
		cu.id_cliente_usuario,
		cu.cliente_usuario,
		cu.marca_baja,
		cu.id_bot,
		b.pagina_panel_admin,
		o.id_operador,
		o.operador;
--select * from v_Cliente_Usuario_Orden order by fecha_hora_ultima_accion desc;

--DROP VIEW v_Cliente_Usuario;
CREATE OR REPLACE VIEW v_Cliente_Usuario AS
SELECT 	c.id_cliente, 
		c.cliente_numero, 
		c.cliente_nombre, 
		c.lista_negra,
		cu.id_cliente_usuario,
		cu.cliente_usuario,
		cu.marca_baja,
		cu.id_bot,
		b.pagina_panel_admin as panel,
		o.id_operador,
		o.operador
from cliente c join cliente_usuario cu
		on (c.id_cliente = cu.id_cliente)
	join bot b
		on (cu.id_bot = b.id_bot)
	join operador o
		on (cu.id_operador = o.id_operador);
	/*join v_Cliente_Bot_Operador v
		on (v.id_bot = b.id_bot
		   and c.id_cliente = v.id_cliente
		   and v.orden = 1);*/
--select * from v_Cliente_Usuario;

--DROP VIEW v_Cliente_Bot_Operador;
CREATE OR REPLACE VIEW v_Cliente_Bot_Operador AS
select 	sc.id_sesion_cliente,
		sc.id_cliente,
		sc.id_sesion_bot,
		sb.id_bot,
		sb.id_usuario,
		u.id_operador,
		o.operador,
		DENSE_RANK() OVER (PARTITION BY sc.id_cliente
						   ORDER BY sc.id_sesion_cliente DESC) as orden
from sesion_cliente sc join sesion_bot sb
		on (sc.id_sesion_bot = sb.id_sesion_bot)
	join usuario u
		on (sb.id_usuario = u.id_usuario)
	join operador o
		on (u.id_operador = o.id_operador);
--select * from v_Cliente_Bot_Operador;

--DROP VIEW v_Sesion_Cliente_Log;
CREATE OR REPLACE VIEW v_Sesion_Cliente_Log AS
select 	scl.id_sesion_cliente_log,
		sc.id_sesion_cliente,
		c.id_cliente, 
		c.cliente_numero, 
		c.cliente_nombre, 
		c.cliente_usuario,
		c.id_cliente_usuario,
		c.id_bot,
		c.panel,
		sc.id_sesion_bot,
		scl.id_accion,
		sa.nombre_accion,
		scl.observacion,
		scl.fecha_hora,
		c.id_operador,
		c.operador 			as oficina,
		cn.numero_telefono	as numero_telefono_bot
from v_Cliente_Usuario c join sesion_cliente sc
		on (sc.id_cliente = c.id_cliente
		   and c.marca_baja = false)
	join sesion_cliente_log scl
		on (sc.id_sesion_cliente = scl.id_sesion_cliente)
	join sesion_accion sa
		on (scl.id_accion = sa.id_accion)
	join sesion_bot sb
		on (sc.id_sesion_bot = sb.id_sesion_bot
		   and sb.id_bot = c.id_bot)
	join usuario u
		on (sb.id_usuario = u.id_usuario)
	join operador o
		on (u.id_operador = o.id_operador
		   and c.id_operador = o.id_operador)
	join cuenta_numero cn
		on (sb.id_cuenta_numero = cn.id_cuenta_numero);
--select * from v_Sesion_Cliente_Log;

--DROP VIEW v_Notificaciones_Cargas;
CREATE OR REPLACE VIEW v_Notificaciones_Cargas AS
SELECT 	nc.id_notificacion_carga,
		nc.id_notificacion,
		o.id_operador,
		o.operador,
		cba.nombre_aplicacion,
		n.aplicacion,
		n.titulo,
		n.mensaje,
		n.fecha_hora,
		nc.carga_usuario 	as usuario_detectado,
		nc.carga_monto		as monto_detectado,
		nc.marca_procesado,
		nc.fecha_hora_procesado,
		nc.carga_cbu		as carga_cbu_detectado,
		c.id_cliente,
		c.cliente_numero,
		c.cliente_nombre,
		b.id_bot,
		b.pagina_panel_admin,
		cu.cliente_usuario,
		CASE 
			WHEN n.titulo = 'Carga Manual' THEN 'Manual'
			ELSE 'Automático'
		END AS origen_carga
from notificacion_carga nc join notificacion n
		on (nc.id_notificacion = n.id_notificacion
		   and nc.id_notificacion_carga not in (select ncd.id_notificacion_carga
											   	from notificacion_carga_duplicacion ncd))
	join usuario u
		on (u.id_usuario = n.id_usuario)
	join operador o
		on (u.id_operador = o.id_operador)
	left join cuenta_bancaria_aplicacion cba
		on (cba.notificacion_descripcion = n.aplicacion)
	left join sesion_cliente sc
		on (nc.id_sesion_cliente = sc.id_sesion_cliente)
	left join cliente c
		on (sc.id_cliente = c.id_cliente)
	left join sesion_bot sb
		on (sc.id_sesion_bot = sb.id_sesion_bot)
	left join bot b
		on (sb.id_bot = b.id_bot)
	left join cliente_usuario cu
		on (c.id_cliente = cu.id_cliente
			and cu.id_operador = o.id_operador
			and cu.id_bot = b.id_bot
		   	and cu.marca_baja = false);
			
--DROP VIEW v_Sesion_Cliente_Log_Cargas_Manuales;
CREATE OR REPLACE VIEW v_Sesion_Cliente_Log_Cargas_Manuales AS
SELECT 	nc.id_notificacion_carga,
		scl.id_sesion_cliente_log,
		nc.id_notificacion,
		nc.id_sesion_cliente,
		nc.orden,
		o.id_operador,
		o.operador,
		u.username,
		r.nombre_rol,
		n.aplicacion,
		n.titulo,
		n.mensaje,
		n.fecha_hora,
		nc.carga_usuario 	as usuario_detectado,
		nc.carga_monto		as monto_detectado,
		nc.marca_procesado,
		nc.fecha_hora_procesado,
		nc.carga_cbu		as carga_cbu_detectado,
		cba.nombre_aplicacion,
		scl.observacion,
		c.id_cliente,
		c.cliente_numero,
		c.cliente_nombre,
		b.id_bot,
		b.pagina_panel_admin,
		cu.cliente_usuario,
		ncm.observacion as motivo_carga_observacion,
		ncmm.carga_manual_motivo
		
from (select id_notificacion_carga,
			id_notificacion,
			id_sesion_cliente,
			carga_usuario,
			carga_monto,
			marca_procesado,
			fecha_hora_procesado,
			carga_cbu,
			DENSE_RANK() OVER (PARTITION BY id_sesion_cliente ORDER BY id_notificacion_carga) AS orden
		from notificacion_carga  
	 	where id_notificacion in (select id_notificacion 
									from notificacion 
								  where titulo = 'Carga Manual')) nc join notificacion n
		on (nc.id_notificacion = n.id_notificacion)
	join notificacion_carga_motivo ncm
		on (nc.id_notificacion_carga = ncm.id_notificacion_carga)
	join notificacion_carga_manual_motivo ncmm
		on (ncmm.id_notificacion_carga_manual_motivo = ncm.id_notificacion_carga_manual_motivo)
	join usuario u
		on (u.id_usuario = n.id_usuario)
	join rol r
		on (u.id_rol = r.id_rol)
	join operador o
		on (u.id_operador = o.id_operador)		
	join cuenta_bancaria_aplicacion cba
		on (cba.notificacion_descripcion = n.aplicacion)
	join sesion_cliente sc
		on (nc.id_sesion_cliente = sc.id_sesion_cliente)
	join (select id_sesion_cliente_log,
				id_sesion_cliente,
				id_accion,
				observacion,
				fecha_hora,
				DENSE_RANK() OVER (PARTITION BY id_sesion_cliente ORDER BY id_sesion_cliente_log) AS orden
		from 	sesion_cliente_log where id_accion = 6) scl
		on (scl.id_sesion_cliente = sc.id_sesion_cliente
		   	and nc.orden = scl.orden)
	join cliente c
		on (sc.id_cliente = c.id_cliente)
	join sesion_bot sb
		on (sc.id_sesion_bot = sb.id_sesion_bot)
	join bot b
		on (sb.id_bot = b.id_bot)
	join cliente_usuario cu
		on (c.id_cliente = cu.id_cliente
			and cu.id_operador = o.id_operador
			and cu.id_bot = b.id_bot
		   	and cu.marca_baja = false);

--DROP VIEW v_Operadores;
CREATE OR REPLACE VIEW v_Operadores AS
SELECT 	id_operador,
		operador,
		numero_operador,
		link_operador_telegram,
		link_canal_telegram,
		bono_inicial,
		bono_carga_1,
		bono_recupero,
		bono_carga_perpetua,
		minimo_carga,
		minimo_retiro,
		minimo_espera_retiro,
		dias_ultima_carga,
		dias_ultimo_recupero,
		usuario_panel_nombre_bot1,
		usuario_panel_pass_bot1,
		usuario_panel_nombre_bot2,
		usuario_panel_pass_bot2,
		usuario_panel_nombre_bot3,
		usuario_panel_pass_bot3,
		usuario_panel_nombre_bot4,
		usuario_panel_pass_bot4,
		fecha_hora_creacion,
		fecha_hora_ultima_modificacion,
		marca_baja
FROM operador;
--select * from v_Operadores;

--DROP VIEW v_Cuentas_Whatsapp;
CREATE OR REPLACE VIEW v_Cuentas_Whatsapp AS
SELECT 	cn.id_cuenta_numero,
		cn.numero_telefono,
		cn.fecha_hora_creacion,
		cn.marca_baja,
		cn.id_bot,
		u.id_usuario,
		o.id_operador,
		o.operador,
		b.pagina_panel_usuario,
		COALESCE(sb.id_estado, 0) 			AS id_estado_sesion,
		COALESCE(sb.estado_sesion, '')		AS estado_sesion,
		COALESCE(cnr.id_cuenta_numero, 0)	AS id_cuenta_numero_respaldo,
		COALESCE(cnr.numero_telefono, '')	AS numero_telefono_respaldo
		
FROM cuenta_numero cn JOIN usuario u
		ON (cn.id_usuario = u.id_usuario)
	JOIN operador o
		ON (u.id_operador = o.id_operador)
	JOIN bot b
		ON (cn.id_bot = b.id_bot)
	LEFT JOIN v_Sesion_Bot sb
		ON (cn.id_bot = sb.id_bot
		   	AND cn.id_cuenta_numero = sb.id_numero_telefono
		   	AND sb.orden = 1)
	LEFT JOIN cuenta_numero cnr
		ON (cn.id_cuenta_numero_respaldo = cnr.id_cuenta_numero);

--DROP VIEW v_Cuentas_Bancarias;
CREATE OR REPLACE VIEW v_Cuentas_Bancarias AS
SELECT	cn.id_cuenta_bancaria,
		cn.id_operador,
		o.operador,
		cn.nombre,
		cn.alias,
		cn.cbu,
		cn.id_cuenta_bancaria_aplicacion,
		cba.nombre_aplicacion,
		cba.notificacion_descripcion,
		cn.fecha_hora_creacion,
		cn.marca_baja
FROM cuenta_bancaria cn JOIN cuenta_bancaria_aplicacion cba
		ON (cn.id_cuenta_bancaria_aplicacion = cba.id_cuenta_bancaria_aplicacion)
	JOIN operador o
		ON (cn.id_operador = o.id_operador);

--DROP VIEW v_Cuentas_Whatsapp_Respaldo;
CREATE OR REPLACE VIEW v_Cuentas_Whatsapp_Respaldo AS
SELECT 	cn.id_cuenta_numero,
		cn.numero_telefono,
		cn.fecha_hora_creacion,
		cn.marca_baja,
		cn.id_bot,
		u.id_usuario,
		o.id_operador,
		o.operador,
		b.pagina_panel_usuario,
		COALESCE(cnr.numero_telefono, '') as numero_telefono_respaldo,
		COALESCE(cnt.id_cuenta_numero_telegram, 0) as id_cuenta_numero_telegram,
		o.link_canal_telegram as link_canal_telegram
FROM cuenta_numero cn JOIN usuario u
		ON (cn.id_usuario = u.id_usuario)
	JOIN operador o
		ON (u.id_operador = o.id_operador)
	JOIN bot b
		ON (cn.id_bot = b.id_bot)
	LEFT JOIN cuenta_numero cnr
		ON (cn.id_cuenta_numero_respaldo = cnr.id_cuenta_numero)
	LEFT JOIN cuenta_numero_telegram cnt
		ON (cnt.id_cuenta_numero = cn.id_cuenta_numero);
--select * from v_Cuentas_Whatsapp_Respaldo;

-- DROP VIEW v_Notificaciones_Eneplicadas;
CREATE OR REPLACE VIEW v_Notificaciones_Eneplicadas AS
SELECT 	nc.id_notificacion_carga,
		nc.carga_usuario,
		nc.carga_monto,
		n.fecha_hora,
		LAG(n.fecha_hora) OVER (PARTITION BY nc.carga_usuario, nc.carga_monto
						   ORDER BY n.fecha_hora) as fecha_hora_anterior,
		EXTRACT(MINUTE FROM (n.fecha_hora - LAG(n.fecha_hora) 
											OVER (PARTITION BY nc.carga_usuario, nc.carga_monto
						   					ORDER BY n.fecha_hora))) as diferencia,
		DENSE_RANK() OVER (PARTITION BY nc.carga_usuario, nc.carga_monto
						   ORDER BY n.fecha_hora) as orden,
		nc.marca_procesado,
		nc.fecha_hora_procesado,
		nc.carga_cbu,
		o.id_operador,
		n.aplicacion
		
from notificacion_carga nc join notificacion n
		on (nc.id_notificacion = n.id_notificacion)
	join usuario u
		on (u.id_usuario = n.id_usuario)
	join operador o
		on (u.id_operador = o.id_operador);
-- select * from v_Notificaciones_Eneplicadas;

-- DROP VIEW v_Cuentas_Bancarias_Descargas;
CREATE OR REPLACE VIEW v_Cuentas_Bancarias_Descargas AS
select 	cbd.id_cuenta_bancaria_descarga,
		cbd.id_cuenta_bancaria,
		cb.nombre,
		cb.alias,
		cb.cbu,
		cba.nombre_aplicacion,
		cbd.id_usuario,
		u.username,
		cbd.fecha_hora_descarga,
		cbd.cargas_monto,
		cbd.cargas_cantidad		
from cuenta_bancaria_descarga cbd join cuenta_bancaria cb
			on (cbd.id_cuenta_bancaria = cb.id_cuenta_bancaria)
		join cuenta_bancaria_aplicacion cba
			on (cb.id_cuenta_bancaria_aplicacion = cba.id_cuenta_bancaria_aplicacion)
		join usuario u
			on (u.id_usuario = cbd.id_usuario);

-- DROP VIEW v_Usuarios;
CREATE OR REPLACE VIEW v_Usuarios AS
select 	u.id_usuario,
		u.username,
		u.fecha_hora_creacion,
		u.marca_baja,
		u.id_rol,
		r.nombre_rol,
		u.id_operador,
		o.operador
from usuario u join rol r
		on (u.id_rol = r.id_rol)
	join operador o
		ON (u.id_operador = o.id_operador);
--SELECT * FROM v_Usuarios

-- DROP VIEW v_Usuarios_Sesiones;
CREATE OR REPLACE VIEW v_Usuarios_Sesiones AS
SELECT 	us.id_usuario_sesion,
		us.id_usuario,
		us.ip,
		us.fecha_hora_creacion,
		CASE 
			WHEN us.cierre_abrupto = true THEN 'Cierre Abrupto'
			ELSE COALESCE(TO_CHAR(us.fecha_hora_cierre, 'YYYY/MM/DD HH24:MI:SS'), 'Abierta')
		END AS fecha_hora_cierre,
		u.username,
		r.nombre_rol,
		o.operador
FROM	usuario_sesion us JOIN usuario u
			ON (us.id_usuario = u.id_usuario)
		JOIN rol r
			ON (u.id_rol = r.id_rol)
		JOIN operador o
			ON (u.id_operador = o.id_operador);

DROP VIEW v_Clientes_Recupero;
CREATE OR REPLACE VIEW v_Clientes_Recupero AS
SELECT	v1.id_operador,
		v1.id_cliente,
		v1.cliente_numero,
		v1.id_cliente_usuario,
		v1.cliente_usuario,
		v1.id_bot,
		cn.numero_telefono as numero_telefono_bot,
		v1.fecha_hora_reciente as fecha_hora_ultima_carga,
		COALESCE(v2.fecha_hora_reciente, '1900-01-01') as fecha_hora_ultimo_recupero,
		CURRENT_DATE::date - v1.fecha_hora_reciente::date as diferencia_ultima_carga,
		CURRENT_DATE::date - COALESCE(v2.fecha_hora_reciente, '1900-01-01')::date as diferencia_ultimo_recupero,
		v1.id_sesion_cliente_reciente,
		o.dias_ultima_carga,
		o.dias_ultimo_recupero,
		o.bono_carga_perpetua,
		o.bono_recupero
FROM
	(SELECT 	id_operador,
			id_cliente,
			cliente_numero,
			id_cliente_usuario,
			cliente_usuario,
			id_bot,
			MAX(fecha_hora) 	as fecha_hora_reciente,
			MAX(id_sesion_cliente)	as id_sesion_cliente_reciente
	FROM v_Sesion_Cliente_Log
	WHERE id_accion in (3, 6) -- Acciones de Carga de Fichas Manual y Automático
	GROUP BY id_operador,
			id_cliente,
			cliente_numero,
			id_cliente_usuario,
			cliente_usuario,
			id_bot) v1
JOIN operador o
	ON (v1.id_operador = o.id_operador)
JOIN sesion_cliente sc
	ON (v1.id_sesion_cliente_reciente = sc.id_sesion_cliente)
JOIN sesion_bot sb
	ON (sc.id_sesion_bot = sb.id_sesion_bot)
JOIN cuenta_numero cn
	ON (sb.id_cuenta_numero = cn.id_cuenta_numero
	   	and cn.marca_baja = false)		
LEFT JOIN
	(SELECT id_operador,
			id_cliente,
			cliente_numero,
			id_cliente_usuario,
			cliente_usuario,
			id_bot,
			MAX(fecha_hora) 	as fecha_hora_reciente,
			MAX(id_sesion_cliente)	as id_sesion_cliente_reciente
	FROM v_Sesion_Cliente_Log
	WHERE id_accion in (7) -- Acción de Mensaje de Recupero
	GROUP BY id_operador,
			id_cliente,
			cliente_numero,
			id_cliente_usuario,
			cliente_usuario,
			id_bot) v2
ON (v1.id_operador = v2.id_operador
	AND v1.id_cliente = v2.id_cliente
	AND v1.cliente_numero = v2.cliente_numero
	AND v1.id_cliente_usuario = v2.id_cliente_usuario
	AND v1.cliente_usuario = v2.cliente_usuario
	AND v1.id_bot = v2.id_bot);

--DROP VIEW v_Clientes_Recupero_Envio;
CREATE OR REPLACE VIEW v_Clientes_Recupero_Envio AS		
SELECT 	 
		r.id_operador,
		r.id_cliente,
		r.cliente_numero,
		r.id_cliente_usuario,
		r.cliente_usuario,
		r.id_bot,
		r.numero_telefono_bot,
		r.fecha_hora_ultima_carga,
		r.fecha_hora_ultimo_recupero,
		r.diferencia_ultima_carga,
		r.diferencia_ultimo_recupero,
		r.id_sesion_cliente_reciente,
		r.dias_ultima_carga,
		r.bono_carga_perpetua,
		r.bono_recupero,
		b.id_numero_telefono 	as bot_id_numero_telefono,
		b.numero_telefono		as bot_numero_telefono,
		b.cuenta_telegram,
		CASE 
			WHEN r.numero_telefono_bot = b.numero_telefono THEN 0
			ELSE 1
		END AS mismo,
		DENSE_RANK() OVER (PARTITION BY r.id_operador, 
						   				r.id_bot, 
						   				r.id_cliente, 
						   				r.id_cliente_usuario 
						   				ORDER BY CASE 
												WHEN r.numero_telefono_bot = b.numero_telefono
						   							THEN 0
													ELSE 1
												END) as orden,
		DENSE_RANK() OVER (PARTITION BY r.id_operador, 
						   				r.id_bot
						   				ORDER BY r.fecha_hora_ultima_carga DESC) as orden_oficina
FROM v_Clientes_Recupero r JOIN v_Sesion_Bot b
	ON 	r.id_operador = b.id_operador
		AND r.id_bot = b.id_bot
		AND r.diferencia_ultima_carga > r.dias_ultima_carga
		AND r.diferencia_ultimo_recupero > r.dias_ultimo_recupero
		AND b.orden = 1
		AND b.id_estado = 1;

--DROP VIEW v_Cuentas_Whatsapp;
CREATE OR REPLACE VIEW v_Cuentas_Telegram AS
SELECT 	cn.id_cuenta_numero,
		cn.numero_telefono as denominacion_bot,
		cn.fecha_hora_creacion,
		cn.marca_baja,
		cn.id_bot,
		u.id_usuario,
		o.id_operador,
		o.operador,
		b.pagina_panel_usuario,
		cnt.telegram_token,
		COALESCE(sb.id_estado, 0) 			AS id_estado_sesion,
		COALESCE(sb.estado_sesion, '')		AS estado_sesion,
		COALESCE(cnr.id_cuenta_numero, 0)	AS id_cuenta_numero_respaldo,
		COALESCE(cnr.numero_telefono, '')	AS denominacion_bot_respaldo
		
FROM cuenta_numero cn JOIN usuario u
		ON (cn.id_usuario = u.id_usuario)
	JOIN operador o
		ON (u.id_operador = o.id_operador)
	JOIN bot b
		ON (cn.id_bot = b.id_bot)
	JOIN cuenta_numero_telegram cnt
		ON (cn.id_cuenta_numero = cnt.id_cuenta_numero)
	LEFT JOIN v_Sesion_Bot sb
		ON (cn.id_bot = sb.id_bot
		   	AND cn.id_cuenta_numero = sb.id_numero_telefono
		   	AND sb.orden = 1)
	LEFT JOIN cuenta_numero cnr
		ON (cn.id_cuenta_numero_respaldo = cnr.id_cuenta_numero);
		
--DROP VIEW v_Cliente_Usuario_Chat_Historial;
CREATE OR REPLACE VIEW v_Cliente_Usuario_Chat_Historial AS
SELECT	cuc.id_cliente_usuario_chat,
		cu.id_cliente_usuario,
		o.id_operador,
		o.operador,
		cu.id_bot,
		b.casino,
		COALESCE(cn.numero_telefono, '-') AS numero_telefono,
		c.cliente_numero,
		c.cliente_nombre,
		c.lista_negra,
		cu.cliente_usuario,
		cuc.desde_usuario,
		cuc.fecha_hora_creacion,
		cuc.mensaje,
		COALESCE(u.username, '(cliente)')	AS usuario,
		cuc.procesado
FROM	cliente_usuario_chat cuc JOIN cliente_usuario cu
			ON (cuc.id_cliente_usuario = cu.id_cliente_usuario)
		JOIN cliente c
			ON (cu.id_cliente = c.id_cliente)
		JOIN operador o
			ON (cu.id_operador = o.id_operador)
		JOIN bot b
			ON (cu.id_bot = b.id_bot)
		LEFT JOIN cuenta_numero cn
			ON (cuc.id_cuenta_numero = cn.id_cuenta_numero)
		LEFT JOIN usuario u
			ON (cuc.id_usuario = u.id_usuario);
--select * from v_Cliente_Usuario_Chat_Historial;

--DROP VIEW v_Cliente_Usuario_Mensaje_Pendiente;
CREATE OR REPLACE VIEW v_Cliente_Usuario_Mensaje_Pendiente AS
SELECT 	h.id_operador, 
		h.id_bot, 
		h.id_cliente_usuario_chat, 
		h.cliente_numero, 
		h.cliente_usuario, 
		h.mensaje,
		sb.id_cuenta_numero
FROM 	v_Cliente_Usuario_Chat_Historial h JOIN sesion_bot sb
				ON (sb.id_estado = 1
			   		AND h.id_bot = sb.id_bot)
			JOIN usuario u
				ON (u.id_usuario = sb.id_usuario
				   	AND h.id_operador = u.id_operador)
WHERE 	h.desde_usuario = false
	AND h.procesado = false
ORDER BY h.fecha_hora_creacion LIMIT 1;
--select * from v_Cliente_Usuario_Mensaje_Pendiente

--DROP VIEW v_Cargas_Automaticas;
CREATE OR REPLACE VIEW v_Cargas_Automaticas AS
SELECT	nc.id_notificacion_carga,
		nc.id_notificacion,
		nc.carga_usuario,
		nc.carga_monto,
		cuc.id_cliente_usuario,
		cu.id_cliente,
		cu.id_bot,
		cu.cliente_usuario,
		c.cliente_numero,
		sb.id_sesion_bot,
		sb.id_cuenta_numero,
		cn.numero_telefono,
		u.id_operador,
		sc.id_sesion_cliente,
		o.minimo_carga,
		o.bono_carga_perpetua,
		CASE 
			WHEN sb.id_bot = 1 THEN o.usuario_panel_nombre_bot1
			WHEN sb.id_bot = 2 THEN o.usuario_panel_nombre_bot2
			WHEN sb.id_bot = 3 THEN o.usuario_panel_nombre_bot3
			WHEN sb.id_bot = 4 THEN o.usuario_panel_nombre_bot4
		END AS usuario_panel_nombre,
		CASE 
			WHEN sb.id_bot = 1 THEN o.usuario_panel_pass_bot1
			WHEN sb.id_bot = 2 THEN o.usuario_panel_pass_bot2
			WHEN sb.id_bot = 3 THEN o.usuario_panel_pass_bot3
			WHEN sb.id_bot = 4 THEN o.usuario_panel_pass_bot4
		END AS usuario_panel_pass,
		b.pagina_panel_admin,
		nc2.carga_cbu 	as carga_cbu_anterior,
		DENSE_RANK() OVER (PARTITION BY nc2.carga_usuario ORDER BY nc2.fecha_hora_procesado DESC) as orden

FROM 	notificacion_carga nc JOIN cliente_usuario_cuentas cuc
			ON (nc.carga_usuario = cuc.usuario_titular_cuenta
			   AND nc.marca_procesado = false
			   AND nc.carga_cbu IS NULL
			   AND cuc.id_estado_usuario_cuentas IN (1,3))
		JOIN cliente_usuario cu
			ON (cuc.id_cliente_usuario = cu.id_cliente_usuario
			   AND cu.marca_baja = false)
		JOIN cliente c
			ON (cu.id_cliente = c.id_cliente)
		JOIN (SELECT 	sc2.id_cliente,
			  			MAX(sc2.id_sesion_cliente) as id_sesion_cliente
			 	FROM sesion_cliente sc2 
			  	GROUP BY sc2.id_cliente) sc
			ON (sc.id_cliente = c.id_cliente)
		JOIN operador o
			ON (o.id_operador = cu.id_operador)
		JOIN usuario u
			ON (u.id_operador = o.id_operador)
		JOIN cuenta_numero cn
			ON (cn.id_usuario = u.id_usuario
			   	AND cu.id_bot = cn.id_bot)
		JOIN sesion_bot sb
			ON (sb.id_cuenta_numero = cn.id_cuenta_numero
					AND sb.id_estado = 1)
		JOIN bot b
			ON (sb.id_bot = b.id_bot)
		JOIN notificacion_carga nc2
			ON (nc2.carga_usuario = cuc.usuario_titular_cuenta
			   AND nc2.marca_procesado = true
			   AND nc2.carga_cbu IS NOT NULL
			   AND nc2.id_notificacion_carga <> nc.id_notificacion_carga);
--select * from v_Cargas_Automaticas where orden = 1;

--DROP VIEW v_Cliente_Usuario_Cuentas;
CREATE OR REPLACE VIEW v_Cliente_Usuario_Cuentas AS
SELECT	cuc.id_cliente_usuario_cuenta,
		cuc.id_cliente_usuario,
		cuc.usuario_titular_cuenta,
		cuc.fecha_hora_creacion,
		cuc.fecha_hora_ultima_modificacion,
		CASE 
			WHEN cuc.id_estado_usuario_cuentas IN (3,4) THEN u.username
			ELSE 'Sistema'
		END AS usuario_ultima_modificacion,
		cuc.id_estado_usuario_cuentas,
		euc.estado,
		cu.id_cliente,
		cu.id_bot,
		cu.cliente_usuario,
		cu.id_operador,
		cu.marca_baja
FROM	cliente_usuario_cuentas cuc JOIN estado_usuario_cuentas euc
			ON (cuc.id_estado_usuario_cuentas = euc.id_estado_usuario_cuentas)
		JOIN cliente_usuario cu
			ON (cu.id_cliente_usuario = cuc.id_cliente_usuario)
		JOIN usuario u
			ON (u.id_usuario = cuc.usuario_ultima_modificacion);
--select * from v_Cliente_Usuario_Cuentas;

--DROP VIEW v_Cuenta_Bancaria_Mercado_Pago;
CREATE OR REPLACE VIEW v_Cuenta_Bancaria_Mercado_Pago AS
SELECT 	cb.id_cuenta_bancaria,
		cb.id_operador,
		cb.nombre,
		cb.alias,
		cb.cbu,
		cba.nombre_aplicacion,
		cba.notificacion_descripcion,
		cbmp.access_token,
		cbmp.public_key,
		cbmp.client_id,
		cbmp.client_secret,
		us.id_usuario
FROM 	cuenta_bancaria cb JOIN cuenta_bancaria_mercado_pago cbmp
				ON (cb.id_cuenta_bancaria = cbmp.id_cuenta_bancaria
				   	AND cbmp.marca_baja = false)
			JOIN cuenta_bancaria_aplicacion cba
				ON (cb.id_cuenta_bancaria_aplicacion = cba.id_cuenta_bancaria_aplicacion)
			JOIN (SELECT 	u.id_operador, 
				  			MIN(u.id_usuario) AS id_usuario 
				  	FROM usuario u
				  	WHERE u.id_rol = 2 
				  		AND u.marca_baja = false
				  	GROUP BY u.id_operador) us
				ON (us.id_operador = cb.id_operador);
--select * from v_Cuenta_Bancaria_Mercado_Pago

--DROP VIEW v_rpt_Acciones_Log_Diarias;
CREATE OR REPLACE VIEW v_rpt_Acciones_Log_Diarias AS
SELECT 	EXTRACT(year FROM fecha_hora::date) as año, 
		EXTRACT(MONTH FROM fecha_hora::date) as mes, 
		EXTRACT(DAY FROM fecha_hora::date) as dia,
		fecha_hora,
		u.id_operador,
		sa.nombre_accion,
		count(scl.id_sesion_cliente_log) as Q
from 	sesion_cliente_log scl join sesion_accion sa
			on (scl.id_accion = sa.id_accion)
		join sesion_cliente sc
			on (sc.id_sesion_cliente = scl.id_sesion_cliente)
		join sesion_bot sb
			on (sb.id_sesion_bot = sc.id_sesion_bot)
		join usuario u
			on (sb.id_usuario = u.id_usuario)
group by EXTRACT(year FROM fecha_hora::date),
		EXTRACT(MONTH FROM fecha_hora::date), 
		EXTRACT(DAY FROM fecha_hora::date),
		fecha_hora,
		u.id_operador,
		sa.nombre_accion
order by 1 desc, 2 desc, 3 desc, 4;

/*Conversiones en recuperos*/
/*SELECT 	vr.cliente_numero,
		vr.cliente_usuario,
		vr.id_accion,
		vr.nombre_accion,
		vr.observacion,
		vr.fecha_hora,
		vr.oficina,
		vc.id_accion,
		vc.nombre_accion,
		vc.observacion,
		vc.fecha_hora*/
--DROP VIEW v_rpt_Conversiones_Recuperos;
CREATE OR REPLACE VIEW v_rpt_Conversiones_Recuperos AS
SELECT	COUNT(*) AS MensajesRecupero, 
		SUM(Cargas) As Cargas, 
		SUM(ClientesCargas) As ClientesCargas,
		SUM(ClientesCargas)::FLOAT / COUNT(*) * 100 as PorcentajeConversiones
FROM (
	SELECT 	vr.cliente_numero,
			vr.cliente_usuario,
			vr.id_accion,
			vr.nombre_accion,
			vr.observacion,
			vr.fecha_hora,
			vr.oficina,
			COALESCE(vc.id_accion, 0) AS id_accion,
			COALESCE(vc.nombre_accion, '') AS nombre_accion,
			COUNT(vc.observacion) AS Cargas,
			CASE WHEN COUNT(vc.observacion) = 0 THEN 0 ELSE 1 END AS ClientesCargas
	FROM	v_Sesion_Cliente_Log vr JOIN operador o
				ON (o.id_operador = vr.id_operador
				   AND vr.fecha_hora >= CURRENT_DATE - (o.dias_ultima_carga::TEXT || ' days')::INTERVAL)
			LEFT JOIN v_Sesion_Cliente_Log vc
				ON (vr.cliente_numero = vc.cliente_numero
					AND vr.cliente_usuario = vc.cliente_usuario
					AND vr.oficina = vc.oficina
					AND vr.fecha_hora <= vc.fecha_hora
					AND vc.id_accion IN (3,6,10))
	WHERE vr.id_accion = 7
	GROUP BY vr.cliente_numero,
			vr.cliente_usuario,
			vr.id_accion,
			vr.nombre_accion,
			vr.observacion,
			vr.fecha_hora,
			vr.oficina,
			vc.id_accion,
			vc.nombre_accion) r;
			
/*****************************************************************/
-- Control de Concurrencias en Cargas:
/*****************************************************************/
INSERT INTO concurrencia (id_servidor, activos, en_espera, tope)
VALUES (1, 0, 0, 2);
INSERT INTO concurrencia (id_servidor, activos, en_espera, tope)
VALUES (2, 0, 0, 2);

--DROP FUNCTION Semaforo_Concurrencia_Ingreso(in_id_servidor INTEGER);
CREATE OR REPLACE FUNCTION Semaforo_Concurrencia_Ingreso(in_id_servidor INTEGER, in_concurrentes INTEGER)
RETURNS TABLE (out_semaforo INTEGER) AS $$
DECLARE
    aux_concurrentes INTEGER;
BEGIN
	
	SELECT 	tope - activos
	INTO aux_concurrentes
	FROM concurrencia
	WHERE id_servidor = in_id_servidor;
	
	IF aux_concurrentes > 0 THEN
	
		UPDATE concurrencia
		SET activos = activos + 1
		WHERE id_servidor = in_id_servidor;
		
		IF in_concurrentes = 0 THEN
			UPDATE concurrencia
			SET en_espera = en_espera - 1
			WHERE id_servidor = in_id_servidor;
		END IF;
		
	ELSE
	
		IF in_concurrentes < 0 THEN
			UPDATE concurrencia
			SET en_espera = en_espera + 1
			WHERE id_servidor = in_id_servidor;
		END IF;
		
	END IF;
	
	RETURN QUERY SELECT aux_concurrentes;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Semaforo_Concurrencia_Salida(in_id_servidor INTEGER);
CREATE OR REPLACE FUNCTION Semaforo_Concurrencia_Salida(in_id_servidor INTEGER)
RETURNS VOID AS $$
DECLARE
    aux_activos INTEGER;
BEGIN

	SELECT	activos
	INTO aux_activos
	FROM concurrencia
	WHERE id_servidor = in_id_servidor;
	
	IF aux_activos > 0 THEN
		UPDATE concurrencia
		SET activos = activos - 1
		WHERE id_servidor = in_id_servidor;
	END IF;
	
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Semaforo_Concurrencia_Ingreso(1, -1);
--SELECT * FROM Semaforo_Concurrencia_Ingreso(1, 0);
--SELECT * FROM Semaforo_Concurrencia_Salida(1);
--SELECT * FROM concurrencia

--DROP FUNCTION Semaforo_Concurrencia_Fin_Espera(in_id_servidor INTEGER);
CREATE OR REPLACE FUNCTION Semaforo_Concurrencia_Fin_Espera(in_id_servidor INTEGER)
RETURNS VOID AS $$
DECLARE
    aux_en_espera INTEGER;
BEGIN
	
	SELECT	en_espera
	INTO aux_en_espera
	FROM concurrencia
	WHERE id_servidor = in_id_servidor;
	
	IF aux_en_espera > 0 THEN
		UPDATE concurrencia
		SET en_espera = en_espera - 1
		WHERE id_servidor = in_id_servidor;
	END IF;
	
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM concurrencia
--SELECT * FROM concurrencia_registro where en_espera < 0
--SELECT * FROM concurrencia_registro where id_servidor = 1 order by 1 desc
--UPDATE concurrencia_registro SET en_espera = 0 where en_espera < 0

--UPDATE concurrencia SET tope = 1 where id_servidor = 1;

--DROP FUNCTION Semaforo_Concurrencia_Registro();
CREATE OR REPLACE FUNCTION Semaforo_Concurrencia_Registro()
RETURNS VOID AS $$
BEGIN
	
	INSERT INTO concurrencia_registro (fecha_hora, id_servidor, activos, en_espera, tope)
	SELECT	NOW(), id_servidor, activos, en_espera, tope
	FROM concurrencia;
	
END;
$$ LANGUAGE plpgsql;
--SELECT Semaforo_Concurrencia_Registro();
--SELECT * FROM concurrencia_registro WHERE id_servidor = 2 ORDER BY 1 DESC


--DROP FUNCTION Semaforo_Concurrencia_Ingreso_Tran(in_id_servidor INTEGER);
CREATE OR REPLACE FUNCTION Semaforo_Concurrencia_Ingreso_Tran(in_id_servidor INTEGER, in_concurrentes INTEGER)
RETURNS TABLE (out_semaforo INTEGER) AS $$
DECLARE
    aux_concurrentes INTEGER;
BEGIN
	
    -- Iniciar la transacción
    BEGIN
    
		-- Leer el registro específico con bloqueo de lectura compartida
		PERFORM * FROM concurrencia WHERE id_servidor = in_id_servidor FOR SHARE;
		
		SELECT 	tope - activos
		INTO aux_concurrentes
		FROM concurrencia
		WHERE id_servidor = in_id_servidor;

		IF aux_concurrentes > 0 THEN

			UPDATE concurrencia
			SET activos = activos + 1
			WHERE id_servidor = in_id_servidor;

			IF in_concurrentes = 0 THEN
				UPDATE concurrencia
				SET en_espera = en_espera - 1
				WHERE id_servidor = in_id_servidor;
			END IF;

		ELSE

			IF in_concurrentes < 0 THEN
				UPDATE concurrencia
				SET en_espera = en_espera + 1
				WHERE id_servidor = in_id_servidor;
			END IF;

		END IF;
			
		INSERT INTO concurrencia_registro (fecha_hora, id_servidor, activos, en_espera, tope)
		SELECT	NOW(), id_servidor, activos, en_espera, tope
		FROM concurrencia
		WHERE id_servidor = in_id_servidor;
	
		RETURN QUERY SELECT aux_concurrentes;
		
    EXCEPTION
        -- Manejar cualquier error durante la transacción
        WHEN OTHERS THEN
			RETURN QUERY SELECT aux_concurrentes;
            -- Deshacer la transacción
            ROLLBACK;
            -- Lanzar el error nuevamente para que sea manejado por el llamador
            RAISE;
	-- Confirmar la transacción
	COMMIT;
	END;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Semaforo_Concurrencia_Salida_Tran(in_id_servidor INTEGER);
CREATE OR REPLACE FUNCTION Semaforo_Concurrencia_Salida_Tran(in_id_servidor INTEGER)
RETURNS VOID AS $$
DECLARE
    aux_activos INTEGER;
BEGIN
    -- Iniciar la transacción
    BEGIN
    
		-- Leer el registro específico con bloqueo de lectura compartida
		PERFORM * FROM concurrencia WHERE id_servidor = in_id_servidor FOR SHARE;
		
		SELECT activos INTO aux_activos FROM concurrencia WHERE id_servidor = in_id_servidor;

		IF aux_activos > 0 THEN
			UPDATE concurrencia
			SET activos = activos - 1
			WHERE id_servidor = in_id_servidor;
			
			INSERT INTO concurrencia_registro (fecha_hora, id_servidor, activos, en_espera, tope)
			SELECT	NOW(), id_servidor, activos, en_espera, tope
			FROM concurrencia
			WHERE id_servidor = in_id_servidor;
			
		END IF;
		
		
	EXCEPTION
		-- Manejar cualquier error durante la transacción
		WHEN OTHERS THEN
			-- Deshacer la transacción
			ROLLBACK;
			-- Lanzar el error nuevamente para que sea manejado por el llamador
			RAISE;
	-- Confirmar la transacción
	COMMIT;
	END;	
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Semaforo_Concurrencia_Fin_Espera_Tran(in_id_servidor INTEGER);
CREATE OR REPLACE FUNCTION Semaforo_Concurrencia_Fin_Espera_Tran(in_id_servidor INTEGER)
RETURNS VOID AS $$
DECLARE
    aux_en_espera INTEGER;
BEGIN
    -- Iniciar la transacción
    BEGIN
    
		-- Leer el registro específico con bloqueo de lectura compartida
		PERFORM * FROM concurrencia WHERE id_servidor = in_id_servidor FOR SHARE;
		
		SELECT en_espera INTO aux_en_espera FROM concurrencia WHERE id_servidor = in_id_servidor;

		IF aux_en_espera > 0 THEN
			UPDATE concurrencia
			SET en_espera = en_espera - 1
			WHERE id_servidor = in_id_servidor;
			
			INSERT INTO concurrencia_registro (fecha_hora, id_servidor, activos, en_espera, tope)
			SELECT	NOW(), id_servidor, activos, en_espera, tope
			FROM concurrencia
			WHERE id_servidor = in_id_servidor;
			
		END IF;
		
	EXCEPTION
		-- Manejar cualquier error durante la transacción
		WHEN OTHERS THEN
			-- Deshacer la transacción
			ROLLBACK;
			-- Lanzar el error nuevamente para que sea manejado por el llamador
			RAISE;
	-- Confirmar la transacción
	COMMIT;
	END;	
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Semaforo_Concurrencia_Ingreso_Tran(1, -1);
--SELECT * FROM Semaforo_Concurrencia_Ingreso_Tran(1, 0);
--SELECT * FROM Semaforo_Concurrencia_Salida_Tran(1);
--SELECT * FROM Semaforo_Concurrencia_Fin_Espera_Tran(1);
--SELECT * FROM concurrencia
--SELECT * FROM concurrencia_registro where id_servidor = 2 order by 1 desc
--update concurrencia set tope = 3, activos = 0, en_espera = 0 where id_servidor = 2
--update concurrencia set tope = 3 where id_servidor = 2