DROP TABLE IF EXISTS usuario;

CREATE TABLE IF NOT EXISTS usuario
(
    id_usuario serial NOT NULL,
    usuario character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    id_rol integer NOT NULL,
    id_oficina integer NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_creacion timestamp NOT NULL,
    id_usuario_creacion integer NOT NULL,
    fecha_hora_ultima_modificacion timestamp,
    id_usuario_ultima_modificacion integer NOT NULL,
    PRIMARY KEY (id_usuario)
);
CREATE INDEX usuario_id_rol ON usuario (id_rol);
CREATE INDEX usuario_id_oficina ON usuario (id_oficina);

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
    mensaje_log character varying(300),
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

DROP TABLE IF EXISTS oficina;
CREATE TABLE IF NOT EXISTS oficina
(
    id_oficina serial NOT NULL,
    oficina character varying(100) NOT NULL,
    contacto_whatsapp character varying(200) NOT NULL DEFAULT '',
    contacto_telegram character varying(200) NOT NULL DEFAULT '',
	bono_carga_1 integer NOT NULL DEFAULT 0,
	bono_carga_perpetua integer NOT NULL DEFAULT 0,
	minimo_carga integer NOT NULL DEFAULT 0,
	minimo_retiro integer NOT NULL DEFAULT 0,
	minimo_espera_retiro integer NOT NULL DEFAULT 24,
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_creacion timestamp NOT NULL,
	id_usuario_creacion integer NOT NULL DEFAULT 0,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_oficina)
);

DROP TABLE IF EXISTS cuenta_bancaria;
CREATE TABLE IF NOT EXISTS cuenta_bancaria
(
    id_cuenta_bancaria serial NOT NULL,
	id_oficina integer not null,
    nombre character varying(200) NOT NULL,
    alias character varying(200) NOT NULL,
    cbu character varying(200) NOT NULL,
	id_billetera integer NOT NULL DEFAULT 1,
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_creacion timestamp NOT NULL,
	id_usuario_creacion integer NOT NULL DEFAULT 0,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_cuenta_bancaria)
);
CREATE INDEX cuenta_bancaria_id_oficina ON cuenta_bancaria (id_oficina);
CREATE INDEX cuenta_bancaria_id_billetera ON cuenta_bancaria (id_billetera);

DROP TABLE IF EXISTS billetera;
CREATE TABLE IF NOT EXISTS billetera
(
    id_billetera serial NOT NULL,
    billetera character varying(100) NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_creacion timestamp NOT NULL,
	id_usuario_creacion integer NOT NULL DEFAULT 0,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_billetera)
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

DROP TABLE IF EXISTS plataforma;
CREATE TABLE IF NOT EXISTS plataforma
(
    id_plataforma serial NOT NULL,
    plataforma character varying(200) NOT NULL,
    url_admin character varying(200) NOT NULL,
    url_juegos character varying(200) NOT NULL,
	imagen character varying(200) NOT NULL DEFAULT '-',
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_plataforma)
);

DROP TABLE IF EXISTS agente;
CREATE TABLE IF NOT EXISTS agente
(
    id_agente serial NOT NULL,
    agente_usuario character varying(200) NOT NULL,
    agente_password character varying(200) NOT NULL,
    id_plataforma integer NOT NULL,
    id_oficina integer NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
	tokens_bono_creacion INTEGER NOT NULL DEFAULT 0,
	tokens_bono_carga_1 INTEGER NOT NULL DEFAULT 0,
    fecha_hora_creacion timestamp NOT NULL,
	id_usuario_creacion integer NOT NULL DEFAULT 0,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_agente)
);
CREATE INDEX agente_id_oficina ON agente (id_oficina);
CREATE INDEX agente_id_plataforma ON agente (id_plataforma);

DROP TABLE IF EXISTS cliente;
CREATE TABLE IF NOT EXISTS cliente
(
    id_cliente serial NOT NULL,
    cliente_usuario character varying(200) NOT NULL,
    cliente_password character varying(200) NOT NULL,
	id_cliente_ext BIGINT NOT NULL DEFAULT 0,
	id_cliente_db INTEGER NOT NULL DEFAULT 0,
    id_agente integer NOT NULL,
    en_sesion boolean NOT NULL DEFAULT false,
    marca_baja boolean NOT NULL DEFAULT false,
	bloqueado boolean NOT NULL DEFAULT false,
	id_registro_token integer NOT NULL DEFAULT 0;
	correo_electronico character varying(100) NOT NULL DEFAULT '';
	telefono character varying(100) NOT NULL DEFAULT '';
    fecha_hora_creacion timestamp NOT NULL,
	id_usuario_creacion integer NOT NULL DEFAULT 0,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_cliente)
);
CREATE INDEX cliente_id_agente ON cliente (id_agente);

select * from cliente order by 1

DROP TABLE IF EXISTS cliente_sesion;
CREATE TABLE IF NOT EXISTS cliente_sesion
(
    id_cliente_sesion serial NOT NULL,
    id_cliente integer NOT NULL,
    id_token character varying(100) NOT NULL DEFAULT '',
    ip character varying(100) NOT NULL DEFAULT '',
    moneda character varying(30),
    monto numeric,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_cierre timestamp,
    cierre_abrupto boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_cliente_sesion)
);
CREATE INDEX cliente_sesion_id_cliente ON cliente_sesion (id_cliente);

DROP TABLE IF EXISTS registro_sesiones_sockets;
CREATE TABLE IF NOT EXISTS registro_sesiones_sockets
(
    id_registro_sesiones_sockets serial NOT NULL,
    fecha_hora timestamp NOT NULL,
    conexiones integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_registro_sesiones_sockets)
);

DROP TABLE IF EXISTS cliente_chat;
CREATE TABLE IF NOT EXISTS cliente_chat
(
    id_cliente_chat serial NOT NULL,
    id_cliente integer NOT NULL,
    mensaje character varying(200) NOT NULL DEFAULT '',
    fecha_hora_creacion timestamp NOT NULL,
    enviado_cliente boolean NOT NULL DEFAULT true,
    visto_cliente boolean NOT NULL DEFAULT false,
    visto_operador boolean NOT NULL DEFAULT false,
    id_usuario integer NOT NULL DEFAULT 1,
    PRIMARY KEY (id_cliente_chat)
);
CREATE INDEX cliente_chat_id_cliente ON cliente_chat (id_cliente);

DROP TABLE IF EXISTS cliente_chat_adjunto;
CREATE TABLE IF NOT EXISTS cliente_chat_adjunto
(
    id_cliente_chat_adjunto serial NOT NULL,
    id_cliente integer NOT NULL,
    nombre_original character varying(200) NOT NULL DEFAULT '',
    nombre_guardado character varying(300) NOT NULL DEFAULT '',
    fecha_hora_creacion timestamp NOT NULL,
    enviado_cliente boolean NOT NULL DEFAULT true,
    visto_cliente boolean NOT NULL DEFAULT false,
    visto_operador boolean NOT NULL DEFAULT false,
    id_usuario integer NOT NULL DEFAULT 1,
    PRIMARY KEY (id_cliente_chat_adjunto)
);
CREATE INDEX cliente_chat_adjunto_id_cliente ON cliente_chat_adjunto (id_cliente);

DROP TABLE IF EXISTS registro_token;
CREATE TABLE IF NOT EXISTS registro_token
(
    id_registro_token serial NOT NULL,
    id_token character varying(60) NOT NULL DEFAULT '',
    de_agente boolean NOT NULL DEFAULT true,
    activo boolean NOT NULL DEFAULT true,
    id_usuario integer NOT NULL,
    ingresos integer NOT NULL,
    registros integer NOT NULL,
	bono_creacion INTEGER NOT NULL DEFAULT 0,
	bono_carga_1 INTEGER NOT NULL DEFAULT 0,
	observaciones character varying(200) NOT NULL DEFAULT '',
    fecha_hora_creacion timestamp NOT NULL,
    id_usuario_ultima_modificacion integer NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    PRIMARY KEY (id_registro_token)
);
CREATE INDEX registro_token_id_usuario ON registro_token (id_usuario);

DROP TABLE IF EXISTS operacion;
CREATE TABLE IF NOT EXISTS operacion
(
    id_operacion serial NOT NULL,
    codigo_operacion integer NOT NULL,
    id_accion integer NOT NULL,
    id_cliente integer NOT NULL,
    id_estado integer NOT NULL,
    notificado boolean NOT NULL DEFAULT true,
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_creacion timestamp NOT NULL,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_operacion)
);
CREATE INDEX operacion_id_accion ON operacion (id_accion);
CREATE INDEX operacion_id_cliente ON operacion (id_cliente);
CREATE INDEX operacion_id_estado ON operacion (id_estado);

DROP TABLE IF EXISTS operacion_retiro;
CREATE TABLE IF NOT EXISTS operacion_retiro
(
    id_operacion_retiro serial NOT NULL,
    id_operacion integer NOT NULL,
    cbu character varying(200) NOT NULL,
    titular character varying(200) NOT NULL,
    importe numeric NOT NULL,
	sol_importe numeric NOT NULL DEFAULT 0,
	observaciones character varying(200) default '',
    PRIMARY KEY (id_operacion_retiro)
);
CREATE INDEX operacion_retiro_id_operacion ON operacion_retiro (id_operacion);

DROP TABLE IF EXISTS operacion_carga;
CREATE TABLE IF NOT EXISTS operacion_carga
(
    id_operacion_carga serial NOT NULL,
    id_operacion integer NOT NULL,
    titular character varying(200) NOT NULL,
    importe numeric NOT NULL,
    bono numeric NOT NULL DEFAULT 0,
    id_cuenta_bancaria integer NOT NULL,
	sol_importe numeric NOT NULL DEFAULT 0,
	sol_bono numeric NOT NULL DEFAULT 0,
	sol_id_cuenta_bancaria integer NOT NULL DEFAULT 0,
	observaciones character varying(200) default '',
    PRIMARY KEY (id_operacion_carga)
);
CREATE INDEX operacion_carga_id_operacion ON operacion_carga (id_operacion);
CREATE INDEX operacion_carga_id_cuenta_bancaria ON operacion_carga (id_cuenta_bancaria);

DROP TABLE IF EXISTS accion;
CREATE TABLE IF NOT EXISTS accion
(
    id_accion serial NOT NULL,
    accion character varying(200) NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_accion)
);

DROP TABLE IF EXISTS estado;
CREATE TABLE IF NOT EXISTS estado
(
    id_estado serial NOT NULL,
    estado character varying(200) NOT NULL,
    marca_baja boolean NOT NULL DEFAULT false,
    PRIMARY KEY (id_estado)
);

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

/*****************************************************************************/
insert into plataforma (plataforma, url_admin, url_juegos, marca_baja)
values ('Casino 365 Online', 'https://bo.casinoenvivo.club', 'https://www.casino365online.club', false);
insert into plataforma (plataforma, url_admin, url_juegos, marca_baja)
values ('Casino 365 Vip', 'https://bo.casinoenvivo.club', 'https://www.casino365vip.club', false);

insert into rol (nombre_rol, fecha_hora_creacion) values ('Administrador', NOW());
insert into rol (nombre_rol, fecha_hora_creacion) values ('Encargado', NOW());
insert into rol (nombre_rol, fecha_hora_creacion) values ('Operador', NOW());
--select * from rol;

insert into billetera(billetera, marca_baja, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
values ('Mercado Pago', false, now(), 1, now(), 1);

--DROP FUNCTION Insertar_Usuario(in_id_usuario INTEGER, usr VARCHAR(50), pass VARCHAR(200), rol INTEGER, ofi INTEGER);
CREATE OR REPLACE FUNCTION Insertar_Usuario(in_id_usuario INTEGER, usr VARCHAR(50), pass VARCHAR(200), rol INTEGER, ofi INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO usuario (usuario, password, id_rol, id_oficina, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (usr, pass, rol, ofi, now(), in_id_usuario, now(), in_id_usuario);
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Insertar_Agente(in_id_usuario INTEGER, in_usuario VARCHAR(50), in_password VARCHAR(200), in_id_oficina INTEGER, in_id_plataforma INTEGER, in_bono_carga_1 INTEGER, in_bono_creacion INTEGER)
CREATE OR REPLACE FUNCTION Insertar_Agente(in_id_usuario INTEGER, in_usuario VARCHAR(50), in_password VARCHAR(200), in_id_oficina INTEGER, in_id_plataforma INTEGER, in_bono_carga_1 INTEGER, in_bono_creacion INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO agente (agente_usuario, agente_password, tokens_bono_carga_1, tokens_bono_creacion, id_plataforma, id_oficina, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (in_usuario, in_password, in_bono_carga_1, in_bono_creacion, in_id_plataforma, in_id_oficina, now(), in_id_usuario, now(), in_id_usuario);
END;
$$ LANGUAGE plpgsql;

select Insertar_Usuario(1, 'admin', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 1, 1);
select Insertar_Usuario(1, 'dario', '$2b$10$rDzcPsghffuJwcHnYCnfkOjTy1DH6zwDL1of2RZAE4vnJOOfxd1Ya', 2, 1);
select Insertar_Usuario(1, 'dario_ope', '$2b$10$rDzcPsghffuJwcHnYCnfkOjTy1DH6zwDL1of2RZAE4vnJOOfxd1Ya', 3, 1);
select Insertar_Usuario(1, 'guille', '$2b$10$ekiX2TBOqH/a0h/CyCevJ./woR3sd0bY4hE2wkpjgDYxok.1C7FCa', 1, 1);
--select * from usuario;

CREATE OR REPLACE FUNCTION Modificar_Usuario(in_id_usuario_modi integer, in_id_usuario integer, pass VARCHAR(200), in_estado BOOLEAN, in_id_rol INTEGER, in_id_oficina INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE usuario 
	SET password = pass,
		id_rol = in_id_rol, 
		id_oficina = in_id_oficina, 
		id_usuario_ultima_modificacion = in_id_usuario_modi,
		fecha_hora_ultima_modificacion = now(),
		marca_baja = in_estado
	WHERE id_usuario = in_id_usuario;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Insertar_Token_Agente;
CREATE OR REPLACE FUNCTION Insertar_Token_Agente(in_id_usuario INTEGER, in_id_agente INTEGER, in_observaciones VARCHAR(30), in_bono_carga_1 INTEGER)
RETURNS TABLE (id_registro_token INTEGER) AS $$
DECLARE aux_id_registro_token INTEGER;
		aux_token VARCHAR(60);
BEGIN
	SELECT substr(translate(encode(gen_random_bytes(40), 'base64'), '/+', 'ab'), 1, 40)
	INTO aux_token;

	INSERT INTO registro_token (id_token, de_agente, activo, id_usuario, ingresos, registros, observaciones, bono_carga_1, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (CONCAT('a-', in_id_agente::varchar, '-', aux_token), true, true, in_id_agente, 0, 0, in_observaciones, in_bono_carga_1, now(), now(), in_id_usuario)
	RETURNING registro_token.id_registro_token INTO aux_id_registro_token;

	IF aux_id_registro_token IS NULL THEN
		aux_id_registro_token := 0;
	END IF;

	RETURN QUERY SELECT aux_id_registro_token;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Obtener_Usuario_Token(in_id_usuario INTEGER, in_id_token VARCHAR(30));
CREATE OR REPLACE FUNCTION Obtener_Usuario_Token(in_id_usuario INTEGER, in_id_token VARCHAR(30))
RETURNS TABLE (id_usuario INTEGER, id_rol INTEGER, id_token VARCHAR(30), id_oficina INTEGER) AS $$
begin
	RETURN QUERY SELECT u.id_usuario, u.id_rol, us.id_token, u.id_oficina
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

CREATE EXTENSION IF NOT EXISTS pgcrypto;

--DROP FUNCTION Confirmar_Sesion_Cliente_Id(in_id_cliente INTEGER, in_id_token VARCHAR(30), in_ip VARCHAR(100), in_monto NUMERIC, in_moneda VARCHAR(30))
CREATE OR REPLACE FUNCTION Confirmar_Sesion_Cliente_Id(in_id_cliente INTEGER, in_id_token VARCHAR(30), in_ip VARCHAR(100), in_monto NUMERIC, in_moneda VARCHAR(30))
RETURNS TABLE (id_cliente INTEGER) AS $$
DECLARE
    aux_id_cliente INTEGER;
    aux_id_agente INTEGER;
    aux_bloqueado BOOLEAN;
BEGIN
	IF NOT EXISTS (SELECT 1
					FROM cliente_sesion cls join cliente cl 
						ON (cls.id_cliente = cl.id_cliente
							AND cls.ip = in_ip
							AND cl.bloqueado = true))
	THEN 
	
		SELECT cl.id_cliente, cl.bloqueado, COALESCE(ag.id_agente, -1)
		INTO aux_id_cliente, aux_bloqueado, aux_id_agente
		FROM cliente cl LEFT JOIN agente ag
			ON (ag.id_agente = cl.id_agente
			   AND ag.marca_baja = false)
		WHERE cl.id_cliente = in_id_cliente;

		IF (aux_bloqueado) THEN
			aux_id_cliente := -1;
		END IF;	

		IF (aux_id_agente < 0) THEN
			aux_id_cliente := -3;
		END IF;	
	
		IF (aux_id_cliente > 0) THEN
			UPDATE cliente_sesion
			SET cierre_abrupto = true,
				fecha_hora_cierre = now()
			WHERE cliente_sesion.id_cliente = aux_id_cliente
				AND cliente_sesion.fecha_hora_cierre IS NULL;

			INSERT INTO cliente_sesion (id_cliente, id_token, ip, fecha_hora_creacion, monto, moneda)
			VALUES (aux_id_cliente, in_id_token, in_ip, now(), in_monto, in_moneda);

			UPDATE cliente
			SET en_sesion = true
			WHERE cliente.id_cliente = aux_id_cliente;
		END IF;
	ELSE
		aux_id_cliente := -2;
	END IF;
	
	RETURN QUERY SELECT aux_id_cliente;
END;
$$ LANGUAGE plpgsql;

select * from cliente where cliente_usuario = 'julio995'
select * from agente where id_agente in (15,21)
select * from oficina where id_oficina in (4,6)
select * from cliente where id_agente = 21
update cliente set bloqueado = true where id_agente = 15

select * from cliente_sesion 
where id_cliente in (select id_cliente from cliente where id_agente = 15)
order by 1 desc

select * from cliente_sesion where ip = '201.235.221.173' order by 1 desc
delete from cliente_sesion where id_cliente_sesion in (27604, 27488, 27487, 27470)

--DROP FUNCTION Confirmar_Sesion_Cliente_Registro(in_agente VARCHAR(200), in_usuario VARCHAR(200), in_password VARCHAR(200), in_id_token VARCHAR(30), in_ip VARCHAR(100), in_monto NUMERIC, in_moneda VARCHAR(30), in_cliente_ext BIGINT, in_cliente_db INTEGER);
CREATE OR REPLACE FUNCTION Confirmar_Sesion_Cliente_Registro(in_agente VARCHAR(200), in_usuario VARCHAR(200), in_password VARCHAR(200), in_id_token VARCHAR(30), in_ip VARCHAR(100), in_monto NUMERIC, in_moneda VARCHAR(30), in_cliente_ext BIGINT, in_cliente_db INTEGER)
RETURNS TABLE (id_cliente INTEGER) AS $$
DECLARE
    aux_id_cliente INTEGER;
    aux_id_agente INTEGER;
    aux_bloqueado BOOLEAN;
	aux_token VARCHAR(60);
	aux_bono_carga_1 INTEGER;
	aux_bono_creacion INTEGER;
BEGIN
	IF NOT EXISTS (SELECT 1
					FROM cliente_sesion cls join cliente cl 
						ON (cls.id_cliente = cl.id_cliente
							AND cls.ip = in_ip
							AND cl.bloqueado = true))
	THEN 
		SELECT id_agente, tokens_bono_creacion, tokens_bono_carga_1
		INTO aux_id_agente, aux_bono_creacion, aux_bono_carga_1
		FROM agente
		WHERE agente_usuario = in_agente
		AND marca_baja = false;
		
		IF aux_id_agente > 0 THEN
			
			SELECT	cl.id_cliente
			INTO aux_id_cliente
			FROM cliente cl
			WHERE 	lower(cl.cliente_usuario) = lower(in_usuario)
			AND 	cl.id_agente = aux_id_agente
			AND 	cl.marca_baja = false;
			
			IF aux_id_cliente > 0 THEN
			
				UPDATE cliente
				SET en_sesion = true, 
					cliente_password = in_password
				WHERE cliente.id_cliente = aux_id_cliente;
				
			ELSE			
				INSERT INTO cliente (cliente_usuario, cliente_password, id_agente, en_sesion, marca_baja, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion, id_cliente_ext, id_cliente_db)
				VALUES (lower(trim(in_usuario)), in_password, aux_id_agente, true, false, now(), 1,  now(), 1, in_cliente_ext, in_cliente_db)
				RETURNING cliente.id_cliente INTO aux_id_cliente;

				INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
				VALUES (1, 7, aux_id_cliente, 2, true, false, now(), now(), 1);

				SELECT substr(translate(encode(gen_random_bytes(40), 'base64'), '/+', 'ab'), 1, 40)
				INTO aux_token;

				INSERT INTO registro_token (id_token, de_agente, activo, id_usuario, ingresos, registros, bono_creacion, bono_carga_1, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
				VALUES (CONCAT('c-', aux_id_cliente::varchar, '-', aux_token), false, true, aux_id_cliente, 0, 0, aux_bono_creacion, aux_bono_carga_1, now(), now(), 1);
			END IF;
			
			IF aux_id_cliente > 0 THEN
				INSERT INTO cliente_sesion (id_cliente, id_token, ip, fecha_hora_creacion, monto, moneda)
				VALUES (aux_id_cliente, in_id_token, in_ip, now(), in_monto, in_moneda);
			END IF;
		ELSE
			aux_id_cliente := -3;
		END IF;
	ELSE
		aux_id_cliente := -2;
	END IF;
	
	RETURN QUERY SELECT aux_id_cliente;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Confirmar_Sesion_Cliente(in_agente VARCHAR(200), in_usuario VARCHAR(200), in_password VARCHAR(200), in_id_token VARCHAR(30), in_ip VARCHAR(100), in_monto NUMERIC, in_moneda VARCHAR(30));
CREATE OR REPLACE FUNCTION Confirmar_Sesion_Cliente(in_agente VARCHAR(200), in_usuario VARCHAR(200), in_password VARCHAR(200), in_id_token VARCHAR(30), in_ip VARCHAR(100), in_monto NUMERIC, in_moneda VARCHAR(30))
RETURNS TABLE (id_cliente INTEGER) AS $$
DECLARE
    aux_id_cliente INTEGER;
    aux_id_agente INTEGER;
    aux_bloqueado BOOLEAN;
	aux_token VARCHAR(60);
	aux_bono_carga_1 INTEGER;
	aux_bono_creacion INTEGER;
BEGIN
	IF NOT EXISTS (SELECT 1
					FROM cliente_sesion cls join cliente cl 
						ON (cls.id_cliente = cl.id_cliente
							AND cls.ip = in_ip
							AND cl.bloqueado = true))
	THEN 
	
		IF EXISTS (SELECT 1
					FROM cliente cl join agente ag 
						ON (cl.id_agente = ag.id_agente
							AND cl.cliente_usuario = in_usuario
							AND ag.agente_usuario = in_agente))
		THEN
		
			SELECT cl.id_cliente, cl.bloqueado, ag.id_agente
			INTO aux_id_cliente, aux_bloqueado, aux_id_agente
			FROM cliente cl join agente ag 
				ON (cl.id_agente = ag.id_agente
					AND cl.cliente_usuario = in_usuario
					AND ag.agente_usuario = in_agente);
					
			IF (aux_bloqueado) THEN
				aux_id_cliente := -1;
			ELSE			
				UPDATE cliente
				SET cliente_password = in_password,
					en_sesion = true
				WHERE cliente.id_cliente = aux_id_cliente;
			END IF;
			
		ELSE 
		
			SELECT id_agente, tokens_bono_creacion, tokens_bono_carga_1
			INTO aux_id_agente, aux_bono_creacion, aux_bono_carga_1
			FROM agente
			WHERE agente_usuario = in_agente;

			INSERT INTO cliente (cliente_usuario, cliente_password, id_agente, en_sesion, marca_baja, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
			VALUES (lower(trim(in_usuario)), in_password, aux_id_agente, true, false, now(), 1,  now(), 1)
			RETURNING cliente.id_cliente INTO aux_id_cliente;
			
			INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
			VALUES (1, 7, aux_id_cliente, 2, true, false, now(), now(), 1);

			SELECT substr(translate(encode(gen_random_bytes(40), 'base64'), '/+', 'ab'), 1, 40)
			INTO aux_token;
			
			INSERT INTO registro_token (id_token, de_agente, activo, id_usuario, ingresos, registros, bono_creacion, bono_carga_1, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
			VALUES (CONCAT('c-', aux_id_cliente::varchar, '-', aux_token), false, true, aux_id_cliente, 0, 0, aux_bono_creacion, aux_bono_carga_1, now(), now(), 1);

		END IF;

		IF (aux_id_cliente > 0) THEN
			UPDATE cliente_sesion
			SET cierre_abrupto = true,
				fecha_hora_cierre = now()
			WHERE cliente_sesion.id_cliente = aux_id_cliente
				AND cliente_sesion.fecha_hora_cierre IS NULL;

			INSERT INTO cliente_sesion (id_cliente, id_token, ip, fecha_hora_creacion, monto, moneda)
			VALUES (aux_id_cliente, in_id_token, in_ip, now(), in_monto, in_moneda);
		END IF;
	ELSE
		aux_id_cliente := -2;
	END IF;
	
	RETURN QUERY SELECT aux_id_cliente;
END;
$$ LANGUAGE plpgsql;
--select * from cliente
--select * from cliente_sesion

--DROP FUNCTION Registrar_Cliente(in_id_agente INTEGER, in_usuario VARCHAR(200), in_password VARCHAR(200), in_correo_electronico VARCHAR(100), in_telefono VARCHAR(100), in_id_registro_token INTEGER, in_id_cliente_ext BIGINT, id_cliente_bd INTEGER)
CREATE OR REPLACE FUNCTION Registrar_Cliente(in_id_agente INTEGER, in_usuario VARCHAR(200), in_password VARCHAR(200), in_correo_electronico VARCHAR(100), in_telefono VARCHAR(100), in_id_registro_token INTEGER, in_id_cliente_ext BIGINT, in_id_cliente_db INTEGER)
RETURNS TABLE (id_cliente INTEGER) AS $$
DECLARE
    aux_id_cliente INTEGER;
	aux_token VARCHAR(60);
	aux_bono_carga_1 INTEGER;
	aux_bono_creacion INTEGER;
BEGIN
	INSERT INTO cliente (cliente_usuario, cliente_password, id_agente, en_sesion, marca_baja, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion, id_registro_token, correo_electronico, telefono, id_cliente_ext, id_cliente_db)
	VALUES (lower(trim(in_usuario)), in_password, in_id_agente, false, false, now(), 1,  now(), 1, in_id_registro_token, in_correo_electronico, in_telefono, in_id_cliente_ext, in_id_cliente_db)
	RETURNING cliente.id_cliente INTO aux_id_cliente;

	INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (1, 8, aux_id_cliente, 2, true, false, now(), now(), 1);

	SELECT substr(translate(encode(gen_random_bytes(40), 'base64'), '/+', 'ab'), 1, 40)
	INTO aux_token;

	SELECT tokens_bono_creacion, tokens_bono_carga_1
	INTO aux_bono_creacion, aux_bono_carga_1
	FROM agente
	WHERE id_agente = in_id_agente;
			
	INSERT INTO registro_token (id_token, de_agente, activo, id_usuario, ingresos, registros, bono_creacion, bono_carga_1, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (CONCAT('c-', aux_id_cliente::varchar, '-', aux_token), false, true, aux_id_cliente, 0, 0, aux_bono_creacion, aux_bono_carga_1, now(), now(), 1);
	
	RETURN QUERY SELECT aux_id_cliente;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Obtener_Cliente_Token(in_id_usuario INTEGER, in_id_token VARCHAR(30));
CREATE OR REPLACE FUNCTION Obtener_Cliente_Token(in_id_cliente INTEGER, in_id_token VARCHAR(30))
RETURNS TABLE (id_cliente INTEGER, 
				id_agente INTEGER, 
				cliente_usuario VARCHAR(100), 
			   	id_cliente_ext BIGINT,
			   	id_cliente_db INTEGER,
				monto NUMERIC, 
				moneda VARCHAR(30),
				id_oficina INTEGER,
				contacto_whatsapp VARCHAR(200),
				contacto_telegram VARCHAR(200),
				bono_carga_1 INTEGER,
				bono_carga_perpetua INTEGER,
				minimo_carga INTEGER,
				minimo_retiro INTEGER,
				minimo_espera_retiro INTEGER,
				agente_usuario VARCHAR(200),
			   	agente_password VARCHAR(200),
				id_plataforma INTEGER,
				plataforma VARCHAR(200),
				url_juegos VARCHAR(200),
			  	token_cliente VARCHAR(60)) AS $$
BEGIN
	RETURN QUERY SELECT cl.id_cliente, 
						cl.id_agente, 
						cl.cliente_usuario, 
						cl.id_cliente_ext,
						cl.id_cliente_db,
						cls.monto, 
						cls.moneda,
						o.id_oficina,
						o.contacto_whatsapp,
						o.contacto_telegram,
						COALESCE(rtr.bono_carga_1, o.bono_carga_1) AS bono_carga_1,
						o.bono_carga_perpetua,
						o.minimo_carga,
						o.minimo_retiro,
						o.minimo_espera_retiro,
						ag.agente_usuario,
						ag.agente_password,
						pl.id_plataforma,
						pl.plataforma,
						pl.url_juegos,
						COALESCE(rt.id_token, 'qwerty') AS token_cliente
	FROM cliente cl JOIN cliente_sesion cls
			ON (cl.id_cliente = cls.id_cliente
				AND cl.id_cliente = in_id_cliente
				AND cls.id_token = in_id_token
				AND cls.fecha_hora_cierre IS NULL
			   	AND cl.marca_baja = false)
		JOIN agente ag
			ON (cl.id_agente = ag.id_agente)
		JOIN oficina o
			ON (ag.id_oficina = o.id_oficina
			   	AND o.marca_baja = false)
		JOIN plataforma pl
			ON (ag.id_plataforma = pl.id_plataforma
			   AND pl.marca_baja = false)
		LEFT JOIN registro_token rt
			ON (rt.id_usuario = cl.id_cliente
			   AND rt.activo = true
			   AND rt.de_agente = false)
		LEFT JOIN registro_token rtr
			ON (rtr.id_registro_token = cl.id_registro_token
			   	AND rtr.activo = true);
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Cliente_Token(2, 'ejemplo');

--DROP FUNCTION Obtener_Cliente_Alertas(in_id_cliente INTEGER);
CREATE OR REPLACE FUNCTION Obtener_Cliente_Alertas(in_id_cliente INTEGER)
RETURNS TABLE (	pendientes_mensajes INTEGER, 
				pendientes_operaciones INTEGER) AS $$
DECLARE
	aux_pendientes_mensajes INTEGER;
	aux_pendientes_operaciones INTEGER;
BEGIN
	SELECT	COUNT(ch.id_cliente_chat)
	INTO aux_pendientes_mensajes
	FROM cliente_chat ch
	WHERE ch.id_cliente = in_id_cliente
	AND ch.visto_cliente = false;
	
	IF aux_pendientes_mensajes IS NULL THEN
		aux_pendientes_mensajes := 0;
	END IF;
	
	SELECT	COUNT(op.id_operacion)
	INTO aux_pendientes_operaciones
	FROM operacion op
	WHERE op.id_cliente = in_id_cliente
	AND op.notificado = false
	AND op.marca_baja = false
	AND op.id_accion in (1, 2, 5, 6, 9);
	
	IF aux_pendientes_operaciones IS NULL THEN
		aux_pendientes_operaciones := 0;
	END IF;
	
	RETURN QUERY SELECT aux_pendientes_mensajes, aux_pendientes_operaciones;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Cliente_Alertas(4);

--DROP FUNCTION Cerrar_Sesion_Cliente(in_id_cliente INTEGER, in_id_token VARCHAR(30));
CREATE OR REPLACE FUNCTION Cerrar_Sesion_Cliente(in_id_cliente INTEGER, in_id_token VARCHAR(30)) RETURNS VOID AS $$
BEGIN
	UPDATE 	cliente_sesion
	SET 	fecha_hora_cierre = now()
	WHERE	id_cliente = in_id_cliente
			AND id_token = in_id_token;
	
	UPDATE 	cliente
	SET		en_sesion = false
	WHERE 	id_cliente = in_id_cliente;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Obtener_Token_Registro(in_id_token VARCHAR(60));
CREATE OR REPLACE FUNCTION Obtener_Token_Registro(in_id_token VARCHAR(60))
RETURNS TABLE (id_registro_token INTEGER) AS $$
DECLARE
    aux_id_registro_token INTEGER;
BEGIN	
	SELECT rt.id_registro_token
	INTO aux_id_registro_token
	FROM registro_token rt
	WHERE rt.id_token = in_id_token
	and rt.activo = true;
	
	IF aux_id_registro_token IS NOT NULL THEN
		UPDATE registro_token
		SET	ingresos = ingresos + 1
		WHERE registro_token.id_registro_token = aux_id_registro_token;
	ELSE
		aux_id_registro_token := 0;
	END IF;

	RETURN QUERY SELECT aux_id_registro_token;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Token_Registro('c-4-9473764e8de991edc3899a179f8af9c1ce3d6ba');
--select * from Obtener_Token_Registro('a-1-9473764e8de991edc3899a179f8af9c1ce3d6ba');

--DROP FUNCTION Modificar_Agente(in_id_agente integer, in_id_usuario integer, pass VARCHAR(200), in_estado BOOLEAN, in_id_oficina INTEGER, in_id_plataforma INTEGER, in_bono_carga_1 INTEGER, in_bono_creacion INTEGER)
CREATE OR REPLACE FUNCTION Modificar_Agente(in_id_agente integer, in_id_usuario integer, pass VARCHAR(200), in_estado BOOLEAN, in_id_oficina INTEGER, in_id_plataforma INTEGER, in_bono_carga_1 INTEGER, in_bono_creacion INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE agente 
	SET agente_password = pass,
		id_oficina = in_id_oficina, 
		id_plataforma = in_id_plataforma,
		tokens_bono_carga_1 = in_bono_carga_1,
		tokens_bono_creacion = in_bono_creacion,
		id_usuario_ultima_modificacion = in_id_usuario,
		fecha_hora_ultima_modificacion = now(),
		marca_baja = in_estado
	WHERE id_agente = in_id_agente;
	
	UPDATE registro_token AS rt
	SET 	bono_creacion = in_bono_creacion,
			bono_carga_1 = in_bono_carga_1,
			id_usuario_ultima_modificacion = in_id_usuario,
			fecha_hora_ultima_modificacion = now()
	FROM 	cliente cl
		WHERE (rt.id_usuario = cl.id_cliente
			AND rt.de_agente = false
			AND cl.id_agente = in_id_agente);
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Modificar_Token_Agente(in_id_registro_token integer, in_id_usuario integer, in_observaciones VARCHAR(200), in_bono_carga_1 INTEGER, in_activo BOOLEAN)
CREATE OR REPLACE FUNCTION Modificar_Token_Agente(in_id_registro_token integer, in_id_usuario integer, in_observaciones VARCHAR(200), in_bono_carga_1 INTEGER, in_activo BOOLEAN) RETURNS VOID AS $$
BEGIN	
	UPDATE registro_token
	SET 	bono_carga_1 = in_bono_carga_1,
			observaciones = in_observaciones,
			activo = in_activo,
			id_usuario_ultima_modificacion = in_id_usuario,
			fecha_hora_ultima_modificacion = now()
	WHERE id_registro_token = in_id_registro_token;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Modificar_Cliente_Registro(in_id_cliente integer, in_id_usuario integer, in_correo_electronico VARCHAR(100), in_telefono VARCHAR(100))
CREATE OR REPLACE FUNCTION Modificar_Cliente_Registro(in_id_cliente integer, in_id_usuario integer, in_telefono VARCHAR(100), in_correo_electronico VARCHAR(100)) RETURNS VOID AS $$
BEGIN
	UPDATE cliente 
	SET correo_electronico = in_correo_electronico,
		telefono = in_telefono, 
		id_usuario_ultima_modificacion = in_id_usuario,
		fecha_hora_ultima_modificacion = now()
	WHERE id_cliente = in_id_cliente;
END;
$$ LANGUAGE plpgsql;

select * from agente

--DROP FUNCTION Obtener_Usuario(usr VARCHAR(50), in_login BOOLEAN);
CREATE OR REPLACE FUNCTION Obtener_Usuario(usr VARCHAR(50), in_login BOOLEAN)
RETURNS TABLE (id_usuario INTEGER, usuario VARCHAR(50), password VARCHAR(200), id_rol INTEGER, id_oficina INTEGER) AS $$
BEGIN
	IF (in_login) THEN
		RETURN query select u.id_usuario, u.usuario, u.password, u.id_rol, u.id_oficina
		from usuario u join oficina o
			on (u.id_oficina = o.id_oficina)
		where u.usuario = usr
			and u.marca_baja = false
			and o.marca_baja = false;
	ELSE
		RETURN query select u.id_usuario, u.usuario, u.password, u.id_rol, u.id_oficina
		from usuario u join oficina o
			on (u.id_oficina = o.id_oficina)
		where u.usuario = usr;
	END IF;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Usuario('dario', true);
--select * from usuario order by 1 desc

--DROP FUNCTION Insertar_Oficina(in_id_usuario INTEGER, in_oficina VARCHAR(200), in_contacto_whatsapp VARCHAR(200), in_contacto_telegram VARCHAR(200), in_bono_carga_1 INTEGER, in_bono_carga_perpetua INTEGER, in_minimo_carga INTEGER, in_minimo_retiro INTEGER, in_minimo_espera_retiro INTEGER) 
CREATE OR REPLACE FUNCTION Insertar_Oficina(in_id_usuario INTEGER, in_oficina VARCHAR(200), in_contacto_whatsapp VARCHAR(200), in_contacto_telegram VARCHAR(200), in_estado BOOLEAN, in_bono_carga_1 INTEGER, in_bono_carga_perpetua INTEGER, in_minimo_carga INTEGER, in_minimo_retiro INTEGER, in_minimo_espera_retiro INTEGER)
RETURNS TABLE (id_oficina INTEGER) AS $$
DECLARE
    aux_id_oficina INTEGER;
BEGIN

	IF NOT EXISTS(	select 1
					from oficina o
					where o.oficina = in_oficina) THEN					
		INSERT INTO oficina (oficina, contacto_whatsapp, contacto_telegram, marca_baja, bono_carga_1, bono_carga_perpetua, minimo_carga, minimo_retiro, minimo_espera_retiro, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
		VALUES (in_oficina, in_contacto_whatsapp, in_contacto_telegram, in_estado, in_bono_carga_1, in_bono_carga_perpetua, in_minimo_carga, in_minimo_retiro, in_minimo_espera_retiro, now(), in_id_usuario, now(), in_id_usuario)
		RETURNING oficina.id_oficina INTO aux_id_oficina;		
	ELSE
		aux_id_oficina := 0;
	END IF;
	
	RETURN query SELECT aux_id_oficina;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM Insertar_Oficina(1, 'Oficina Test', '5491133682345', '5491133682345', 20, 0, 100, 100, 0);
--SELECT * FROM oficina

CREATE OR REPLACE FUNCTION Modificar_Oficina(in_id_oficina INTEGER, in_id_usuario INTEGER, in_oficina VARCHAR(200), in_contacto_whatsapp VARCHAR(200), in_contacto_telegram VARCHAR(200), in_estado BOOLEAN, in_bono_carga_1 INTEGER, in_bono_carga_perpetua INTEGER, in_minimo_carga INTEGER, in_minimo_retiro INTEGER, in_minimo_espera_retiro INTEGER) RETURNS VOID AS $$
BEGIN

	UPDATE oficina set oficina = in_oficina, 
						contacto_whatsapp = in_contacto_whatsapp, 
						contacto_telegram = in_contacto_telegram,
						bono_carga_1 = in_bono_carga_1, 
						bono_carga_perpetua = in_bono_carga_perpetua,
						minimo_carga = in_minimo_carga, 
						minimo_retiro = in_minimo_retiro,
						minimo_espera_retiro = in_minimo_espera_retiro,
						fecha_hora_ultima_modificacion = now(),
						id_usuario_ultima_modificacion = in_id_usuario,
						marca_baja = in_estado
	WHERE id_oficina = in_id_oficina;
	
END;
$$ LANGUAGE plpgsql;
--select Modificar_Oficina(1, 1, 'Oficina Test', '5491133682345', '5491133682345', false, 20, 0, 100, 100, 0)
--SELECT * FROM oficina

--DROP FUNCTION Crear_Cuenta_Bancaria(in_id_oficina INTEGER, in_id_usuario INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_estado BOOLEAN)
CREATE OR REPLACE FUNCTION Crear_Cuenta_Bancaria(in_id_oficina INTEGER, in_id_usuario INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_estado BOOLEAN, in_id_billetera INTEGER, in_access_token VARCHAR(200), in_public_key VARCHAR(200), in_client_id VARCHAR(200), in_client_secret VARCHAR(200)) 
RETURNS TABLE (id_cuenta_bancaria INTEGER) AS $$
DECLARE
    aux_id_cuenta_bancaria INTEGER;
BEGIN
	IF NOT EXISTS(	select 1
					from cuenta_bancaria cb
					where cb.cbu = in_cbu) THEN
					-- where cb.alias = in_alias OR cb.cbu = in_cbu) THEN

		INSERT INTO cuenta_bancaria (id_oficina, 
									 nombre, 
									 alias, 
									 cbu,
									 id_billetera,
									 fecha_hora_creacion,
									 id_usuario_creacion,
									 fecha_hora_ultima_modificacion,
									 id_usuario_ultima_modificacion,
									 marca_baja)
		VALUES (in_id_oficina, in_nombre, in_alias, in_cbu, in_id_billetera, now(), in_id_usuario, now(), in_id_usuario, false)
		RETURNING cuenta_bancaria.id_cuenta_bancaria INTO aux_id_cuenta_bancaria;
		
		INSERT INTO cuenta_bancaria_mercado_pago (id_cuenta_bancaria, access_token, public_key, client_id, client_secret, marca_baja) 
		VALUES (aux_id_cuenta_bancaria, in_access_token, in_public_key, in_client_id, in_client_secret, false);

	ELSE
		aux_id_cuenta_bancaria := 0;
		
	END IF;
	
	RETURN query SELECT aux_id_cuenta_bancaria;
END;
$$ LANGUAGE plpgsql;
--select * from Crear_Cuenta_Bancaria(1, 1, 'Noelia Caleza', 'noelia.227.caleza.mp', '0000003100091595755417' , 1, false);
--select * from cuenta_bancaria;

--DROP FUNCTION Modificar_Cuenta_Bancaria(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_estado BOOLEAN)
CREATE OR REPLACE FUNCTION Modificar_Cuenta_Bancaria(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_estado BOOLEAN, in_id_billetera INTEGER, in_access_token VARCHAR(200), in_public_key VARCHAR(200), in_client_id VARCHAR(200), in_client_secret VARCHAR(200)) 
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
								marca_baja = in_estado,
								id_billetera = in_id_billetera,
								fecha_hora_ultima_modificacion = now(),
								id_usuario_ultima_modificacion = in_id_usuario
		WHERE cuenta_bancaria.id_cuenta_bancaria = in_id_cuenta_bancaria;
		
		aux_id_cuenta_bancaria := in_id_cuenta_bancaria;
		
		IF (in_id_billetera = 1) THEN
			IF EXISTS(	SELECT 1
						FROM cuenta_bancaria_mercado_pago cbmp
						WHERE cbmp.id_cuenta_bancaria = in_id_cuenta_bancaria) THEN
				
				UPDATE cuenta_bancaria_mercado_pago
					SET access_token = in_access_token,
						public_key = in_public_key,
						client_id = in_client_id,
						client_secret = in_client_secret
					WHERE cuenta_bancaria_mercado_pago.id_cuenta_bancaria = in_id_cuenta_bancaria;
			ELSE
			
				INSERT INTO cuenta_bancaria_mercado_pago (id_cuenta_bancaria, access_token, public_key, client_id, client_secret, marca_baja) 
				VALUES (in_id_cuenta_bancaria, in_access_token, in_public_key, in_client_id, in_client_secret, false);
			
			END IF;
		END IF;	
	ELSE
		aux_id_cuenta_bancaria := 0;
	END IF;
	
	RETURN query SELECT aux_id_cuenta_bancaria;
END;
$$ LANGUAGE plpgsql;
--select * from Modificar_Cuenta_Bancaria(1, 1, 'Noelia Caleza', 'noelia.227.caleza.mp', '0000003100091595755417' , 1, false);

--DROP VIEW v_Cuenta_Bancaria_Activa;
CREATE OR REPLACE VIEW v_Cuenta_Bancaria_Activa AS
SELECT 	cb.id_oficina,
		o.oficina,
		cb.id_cuenta_bancaria,
		cb.nombre,
		cb.alias,
		cb.cbu,
		cb.marca_baja,
		coalesce(cbc.cantidad_cargas, 0)	as cantidad_cargas,
		coalesce(cbc.monto_cargas, 0)		as monto_cargas,
		DENSE_RANK() OVER (PARTITION BY cb.id_oficina, o.oficina
						   ORDER BY coalesce(cbc.monto_cargas, 0), coalesce(cbc.cantidad_cargas, 0)) as orden
FROM 	cuenta_bancaria cb join oficina o
			on (cb.id_oficina = o.id_oficina
			   	AND cb.marca_baja = false)
		LEFT JOIN v_Cuenta_Bancaria_Subtotales cbc
			on (cb.id_cuenta_bancaria = cbc.id_cuenta_bancaria)
ORDER BY cb.id_oficina, coalesce(cbc.monto_cargas, 0), coalesce(cbc.cantidad_cargas, 0);
--SELECT * FROM v_Cuenta_Bancaria_Activa

--DROP VIEW v_Cuenta_Bancaria_Subtotales;
CREATE OR REPLACE VIEW v_Cuenta_Bancaria_Subtotales AS
select 	oc.id_cuenta_bancaria, 
		count(oc.importe) as cantidad_cargas, 
		sum(oc.importe) as monto_cargas
from 	operacion_carga oc join operacion op
		on (op.id_operacion = oc.id_operacion
				and op.marca_baja = false
				and op.id_accion IN (1,5)  --accion de carga
				and op.id_estado = 2) --estado aceptado
		join (select cb.id_cuenta_bancaria, 
							coalesce(max(cbd.fecha_hora_descarga), '1900-01-01 00:00:00') as fecha_descarga
					from cuenta_bancaria cb left join cuenta_bancaria_descarga cbd
						on (cb.id_cuenta_bancaria = cbd.id_cuenta_bancaria
						   	AND cbd.marca_baja = false)
					-- where cbd.marca_baja = false
					group by cb.id_cuenta_bancaria) cbd
			on (oc.id_cuenta_bancaria = cbd.id_cuenta_bancaria
				and op.fecha_hora_ultima_modificacion >= cbd.fecha_descarga)
group by oc.id_cuenta_bancaria
--select * from v_Cuenta_Bancaria_Subtotales

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

insert into estado(estado) values ('Pendiente');
insert into estado(estado) values ('Aceptado');
insert into estado(estado) values ('Rechazado');
--select * from estado order by 1;

insert into accion(accion) values ('Carga');
insert into accion(accion) values ('Retiro');
insert into accion(accion) values ('Cambio de Contraseña');
insert into accion(accion) values ('Desbloqueo de Usuario');
insert into accion(accion) values ('Carga Manual');
insert into accion(accion) values ('Retiro Manual');
insert into accion(accion) values ('Primer Ingreso');
insert into accion(accion) values ('Creación de Usuario');
insert into accion(accion) values ('Carga Bono Referido');
--select * from accion;

--DROP FUNCTION Obtener_Oficina();
CREATE OR REPLACE FUNCTION Obtener_Oficina()
RETURNS TABLE (id_oficina INTEGER, oficina VARCHAR(100)) AS $$
begin
	RETURN query 
	SELECT 	o.id_oficina, 
			o.oficina
	FROM oficina o;
END;
$$ LANGUAGE plpgsql;
--select * from Obtener_Oficina();

--DROP FUNCTION Registrar_Cliente_Accion(in_id_cliente INTEGER, in_id_accion INTEGER, in_titular VARCHAR(200), in_importe NUMERIC, in_id_cuenta_bancaria INTEGER, in_cbu VARCHAR(200), in_bono INTEGER) 
CREATE OR REPLACE FUNCTION Registrar_Cliente_Accion(in_id_cliente INTEGER, in_id_accion INTEGER, in_titular VARCHAR(200), in_importe NUMERIC, in_id_cuenta_bancaria INTEGER, in_cbu VARCHAR(200), in_bono INTEGER) 
RETURNS TABLE (id_operacion INTEGER, codigo_operacion INTEGER) AS $$
DECLARE
    aux_id_operacion INTEGER;
    aux_codigo_operacion INTEGER;
    aux_id_estado INTEGER;
BEGIN
	IF (in_id_accion IN (3,4)) THEN
		aux_id_estado := 2;
	ELSE
		aux_id_estado := 1;
	END IF;

	SELECT	COALESCE(COUNT(c.id_operacion), 0) + 1
	INTO 	aux_codigo_operacion
	FROM operacion c
	WHERE c.id_cliente = in_id_cliente;
	
	INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (aux_codigo_operacion, in_id_accion, in_id_cliente, aux_id_estado, true, false, now(), now(), 1)
	RETURNING operacion.id_operacion INTO aux_id_operacion;
	
	IF (in_id_accion = 1) THEN
		INSERT INTO operacion_carga (id_operacion, titular, importe, id_cuenta_bancaria, bono, sol_importe, sol_id_cuenta_bancaria, sol_bono)
		VALUES (aux_id_operacion, in_titular, in_importe, in_id_cuenta_bancaria, in_bono, in_importe, in_id_cuenta_bancaria, in_bono);
	END IF;
	
	IF (in_id_accion = 2) THEN
		INSERT INTO operacion_retiro (id_operacion, cbu, titular, importe, sol_importe)
		VALUES (aux_id_operacion, in_cbu, in_titular, in_importe, in_importe);
	END IF;
	
	RETURN QUERY SELECT aux_id_operacion, aux_codigo_operacion;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Registrar_Carga_Manual(in_id_cliente INTEGER, in_id_usuario INTEGER, in_importe NUMERIC, in_bono INTEGER, in_titular VARCHAR(200), in_id_cuenta_bancaria INTEGER, in_observaciones VARCHAR(200))  
CREATE OR REPLACE FUNCTION Registrar_Carga_Manual(in_id_cliente INTEGER, in_id_usuario INTEGER, in_importe NUMERIC, in_bono INTEGER, in_titular VARCHAR(200), in_id_cuenta_bancaria INTEGER, in_observaciones VARCHAR(200)) 
RETURNS TABLE (id_operacion INTEGER, codigo_operacion INTEGER) AS $$
DECLARE
    aux_id_operacion INTEGER;
    aux_codigo_operacion INTEGER;
BEGIN
	SELECT	COALESCE(COUNT(ope.id_operacion), 0) + 1
	INTO 	aux_codigo_operacion
	FROM operacion ope
	WHERE ope.id_cliente = in_id_cliente;
	
	INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (aux_codigo_operacion, 5, in_id_cliente, 2, false, false, now(), now(), in_id_usuario)
	RETURNING operacion.id_operacion INTO aux_id_operacion;

	INSERT INTO operacion_carga (id_operacion, titular, importe, id_cuenta_bancaria, bono, sol_importe, sol_id_cuenta_bancaria, sol_bono, observaciones)
	VALUES (aux_id_operacion, in_titular, in_importe, in_id_cuenta_bancaria, in_bono, in_importe, in_id_cuenta_bancaria, in_bono, in_observaciones);
	
	RETURN QUERY SELECT aux_id_operacion, aux_codigo_operacion;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Registrar_Retiro_Manual(in_id_cliente INTEGER, in_id_usuario INTEGER, in_importe NUMERIC, in_cbu VARCHAR(30), in_titular VARCHAR(200), in_observaciones VARCHAR(200))  
CREATE OR REPLACE FUNCTION Registrar_Retiro_Manual(in_id_cliente INTEGER, in_id_usuario INTEGER, in_importe NUMERIC, in_cbu VARCHAR(30), in_titular VARCHAR(200), in_observaciones VARCHAR(200)) 
RETURNS TABLE (id_operacion INTEGER, codigo_operacion INTEGER) AS $$
DECLARE
    aux_id_operacion INTEGER;
    aux_codigo_operacion INTEGER;
BEGIN
	SELECT	COALESCE(COUNT(ope.id_operacion), 0) + 1
	INTO 	aux_codigo_operacion
	FROM operacion ope
	WHERE ope.id_cliente = in_id_cliente;
	
	INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (aux_codigo_operacion, 6, in_id_cliente, 2, false, false, now(), now(), in_id_usuario)
	RETURNING operacion.id_operacion INTO aux_id_operacion;

	INSERT INTO operacion_retiro (id_operacion, cbu, titular, importe, sol_importe, observaciones)
	VALUES (aux_id_operacion, in_cbu, in_titular, in_importe, in_importe, in_observaciones);
	
	RETURN QUERY SELECT aux_id_operacion, aux_codigo_operacion;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Modificar_Cliente_Carga(in_id_operacion INTEGER, in_id_estado INTEGER, in_importe NUMERIC, in_bono NUMERIC, in_id_cuenta_bancaria INTEGER, in_id_usuario INTEGER) 
CREATE OR REPLACE FUNCTION Modificar_Cliente_Carga(in_id_operacion INTEGER, in_id_estado INTEGER, in_importe NUMERIC, in_bono NUMERIC, in_id_cuenta_bancaria INTEGER, in_id_usuario INTEGER) 
RETURNS VOID AS $$
BEGIN	
	UPDATE operacion
	SET	fecha_hora_ultima_modificacion = NOW(),
		id_usuario_ultima_modificacion = in_id_usuario,
		id_estado = in_id_estado,
		notificado = false
	WHERE id_operacion = in_id_operacion;
	
	IF (in_id_estado = 2) THEN
		UPDATE operacion_carga
		SET	importe = in_importe,
			bono = in_bono,
			id_cuenta_bancaria = in_id_cuenta_bancaria
		WHERE id_operacion = in_id_operacion;
	END IF;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Modificar_Cliente_Retiro(in_id_operacion INTEGER, in_id_estado INTEGER, in_importe NUMERIC, in_bono NUMERIC, in_id_cuenta_bancaria INTEGER, in_id_usuario INTEGER) 
CREATE OR REPLACE FUNCTION Modificar_Cliente_Retiro(in_id_operacion INTEGER, in_id_estado INTEGER, in_importe NUMERIC, in_id_usuario INTEGER) 
RETURNS VOID AS $$
BEGIN	
	UPDATE operacion
	SET	fecha_hora_ultima_modificacion = NOW(),
		id_usuario_ultima_modificacion = in_id_usuario,
		id_estado = in_id_estado,
		notificado = false
	WHERE id_operacion = in_id_operacion;
	
	IF (in_id_estado = 2) THEN
		UPDATE operacion_retiro
		SET	importe = in_importe
		WHERE id_operacion = in_id_operacion;
	END IF;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Bloqueo_Cliente(in_id_usuario INTEGER, in_id_cliente INTEGER, in_bloqueado BOOLEAN) 
CREATE OR REPLACE FUNCTION Bloqueo_Cliente(in_id_usuario INTEGER, in_id_cliente INTEGER, in_bloqueado BOOLEAN) 
RETURNS VOID AS $$
BEGIN
	UPDATE cliente
	SET	fecha_hora_ultima_modificacion = NOW(),
		id_usuario_ultima_modificacion = in_id_usuario,
		bloqueado = in_bloqueado
	WHERE id_cliente = in_id_cliente;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION Obtener_Cliente_Chat(in_id_cliente INTEGER, in_es_cliente BOOLEAN)
CREATE OR REPLACE FUNCTION Obtener_Cliente_Chat(in_id_cliente INTEGER, in_es_cliente BOOLEAN)
RETURNS TABLE (id_cliente_chat INTEGER,
			   id_cliente INTEGER,
			   mensaje VARCHAR(200), 
			   nombre_original VARCHAR(200), 
			   nombre_guardado VARCHAR(300), 
			   fecha_hora_creacion TIMESTAMP, 
			   enviado_cliente BOOLEAN, 
			   visto_cliente BOOLEAN, 
			   visto_operador BOOLEAN,
			   id_usuario INTEGER,
			   usuario VARCHAR(100)) AS $$
BEGIN
	IF (in_es_cliente) THEN
		UPDATE cliente_chat
		SET visto_cliente = true
		WHERE cliente_chat.id_cliente = in_id_cliente
		AND cliente_chat.visto_cliente = false;
		
		UPDATE cliente_chat_adjunto
		SET visto_cliente = true
		WHERE cliente_chat_adjunto.id_cliente = in_id_cliente
		AND cliente_chat_adjunto.visto_cliente = false;
	ELSE
		UPDATE cliente_chat
		SET visto_operador = true
		WHERE cliente_chat.id_cliente = in_id_cliente
		AND cliente_chat.visto_operador = false;
		
		UPDATE cliente_chat_adjunto
		SET visto_operador = true
		WHERE cliente_chat_adjunto.id_cliente = in_id_cliente
		AND cliente_chat_adjunto.visto_operador = false;
	END IF;
	
	RETURN QUERY SELECT clc.id_cliente_chat,
					clc.id_cliente, 
					clc.mensaje,
					'' as nombre_original,
					'' as nombre_guardado,
					clc.fecha_hora_creacion, 
					clc.enviado_cliente, 
					clc.visto_cliente, 
					clc.visto_operador,
					clc.id_usuario,
					u.usuario
	FROM cliente_chat clc JOIN usuario u
			ON (clc.id_usuario = u.id_usuario)
	WHERE clc.id_cliente = in_id_cliente
	UNION
	SELECT clc.id_cliente_chat_adjunto as id_cliente_chat,
					clc.id_cliente, 
					'' as mensaje,
					clc.nombre_original, 
					clc.nombre_guardado, 
					clc.fecha_hora_creacion, 
					clc.enviado_cliente, 
					clc.visto_cliente, 
					clc.visto_operador,
					clc.id_usuario,
					u.usuario
	FROM cliente_chat_adjunto clc JOIN usuario u
			ON (clc.id_usuario = u.id_usuario)
	WHERE clc.id_cliente = in_id_cliente
	ORDER BY fecha_hora_creacion;
END;
$$ LANGUAGE plpgsql;
/*select id_cliente_chat,id_cliente, mensaje, nombre_original,
		TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY') as fecha_mensaje,
		TO_CHAR(fecha_hora_creacion, 'HH24:MI') as horario_mensaje, 
		enviado_cliente, visto_cliente, 
		visto_operador, id_usuario, usuario, 
		TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY') = LAG(TO_CHAR(fecha_hora_creacion, 'DD/MM/YYYY')) 
			OVER (ORDER BY fecha_hora_creacion) AS misma_fecha 
from Obtener_Cliente_Chat(1, true);*/

--DROP FUNCTION Insertar_Cliente_Chat(in_id_cliente INTEGER, in_es_cliente BOOLEAN, in_mensaje VARCHAR(200), in_id_usuario INTEGER)
CREATE OR REPLACE FUNCTION Insertar_Cliente_Chat(in_id_cliente INTEGER, in_es_cliente BOOLEAN, in_mensaje VARCHAR(200), in_id_usuario INTEGER)
RETURNS TABLE (id_cliente_chat INTEGER,
			   id_cliente INTEGER,
			   /*cliente_usuario VARCHAR(200), 
			   en_sesion BOOLEAN,*/
			   mensaje VARCHAR(200), 
			   nombre_original VARCHAR(200), 
			   nombre_guardado VARCHAR(300), 
			   fecha_hora_creacion TIMESTAMP, 
			   enviado_cliente BOOLEAN, 
			   visto_cliente BOOLEAN, 
			   visto_operador BOOLEAN,
			   id_usuario INTEGER,
			   usuario VARCHAR(100)) AS $$
DECLARE
    aux_visto_operador BOOLEAN;
BEGIN
	IF (in_es_cliente) THEN
		UPDATE cliente_chat
		SET visto_cliente = true
		WHERE cliente_chat.id_cliente = in_id_cliente
		AND cliente_chat.visto_cliente = false;
				
		UPDATE cliente_chat_adjunto
		SET visto_cliente = true
		WHERE cliente_chat_adjunto.id_cliente = in_id_cliente
		AND cliente_chat_adjunto.visto_cliente = false;
		
		aux_visto_operador := false;
	ELSE
		UPDATE cliente_chat
		SET visto_operador = true
		WHERE cliente_chat.id_cliente = in_id_cliente
		AND cliente_chat.visto_operador = false;
		
		UPDATE cliente_chat_adjunto
		SET visto_operador = true
		WHERE cliente_chat_adjunto.id_cliente = in_id_cliente
		AND cliente_chat_adjunto.visto_operador = false;
		
		aux_visto_operador := true;
	END IF;
	
	INSERT INTO cliente_chat (id_cliente, mensaje, fecha_hora_creacion, enviado_cliente, visto_cliente, visto_operador, id_usuario)
	VALUES (in_id_cliente, in_mensaje, NOW(), in_es_cliente, in_es_cliente, aux_visto_operador, in_id_usuario);
	
	/*RETURN QUERY SELECT clc.id_cliente_chat,
						clc.id_cliente, 
						cl.cliente_usuario,
						cl.en_sesion,
						clc.mensaje, 
						clc.fecha_hora_creacion, 
						clc.enviado_cliente, 
						clc.visto_cliente, 
						clc.visto_operador,
						clc.id_usuario,
						u.usuario
	FROM cliente_chat clc JOIN cliente cl
			ON (clc.id_cliente = cl.id_cliente)
		JOIN usuario u
			ON (clc.id_usuario = u.id_usuario)
	WHERE clc.id_cliente = in_id_cliente
	ORDER BY clc.id_cliente_chat;*/
	
	RETURN QUERY SELECT clc.id_cliente_chat,
					clc.id_cliente, 
					clc.mensaje,
					'' as nombre_original,
					'' as nombre_guardado,
					clc.fecha_hora_creacion, 
					clc.enviado_cliente, 
					clc.visto_cliente, 
					clc.visto_operador,
					clc.id_usuario,
					u.usuario
	FROM cliente_chat clc JOIN usuario u
			ON (clc.id_usuario = u.id_usuario)
	WHERE clc.id_cliente = in_id_cliente
	UNION
	SELECT clc.id_cliente_chat_adjunto as id_cliente_chat,
					clc.id_cliente, 
					'' as mensaje,
					clc.nombre_original, 
					clc.nombre_guardado, 
					clc.fecha_hora_creacion, 
					clc.enviado_cliente, 
					clc.visto_cliente, 
					clc.visto_operador,
					clc.id_usuario,
					u.usuario
	FROM cliente_chat_adjunto clc JOIN usuario u
			ON (clc.id_usuario = u.id_usuario)
	WHERE clc.id_cliente = in_id_cliente
	ORDER BY fecha_hora_creacion;
END;
$$ LANGUAGE plpgsql;
--select * from Insertar_Cliente_Chat(1, true, 'prueba mensaje 4 desde cliente', 1);
--select * from Insertar_Cliente_Chat(1, false, 'prueba mensaje 4 desde operador', 3);

--DROP FUNCTION Insertar_Cliente_Chat_Adjunto(in_id_cliente INTEGER, in_es_cliente BOOLEAN, in_nombre_original VARCHAR(200), in_nombre_guardado VARCHAR(200), in_id_usuario INTEGER)
CREATE OR REPLACE FUNCTION Insertar_Cliente_Chat_Adjunto(in_id_cliente INTEGER, in_es_cliente BOOLEAN, in_nombre_original VARCHAR(200), in_nombre_guardado VARCHAR(200), in_id_usuario INTEGER)
RETURNS VOID AS $$
DECLARE
    aux_visto_operador BOOLEAN;
BEGIN	
	IF (in_es_cliente) THEN
		aux_visto_operador := false;
	ELSE
		aux_visto_operador := true;
	END IF;

	INSERT INTO cliente_chat_adjunto (id_cliente, nombre_original, nombre_guardado, fecha_hora_creacion, enviado_cliente, visto_cliente, visto_operador, id_usuario)
	VALUES (in_id_cliente, in_nombre_original, in_nombre_guardado, NOW(), in_es_cliente, in_es_cliente, aux_visto_operador, in_id_usuario);
END;
$$ LANGUAGE plpgsql;
--select Insertar_Cliente_Chat_Adjunto(1, true, 'prueba adjunto 4 desde cliente', 'prueba adjunto 4 desde cliente guardado', 1);
--select Insertar_Cliente_Chat_Adjunto(1, false, 'prueba adjunto 4 desde operador', 'prueba adjunto 4 desde operador guardado', 3);

--DROP FUNCTION Alerta_Cliente_Usuario(in_id_cliente INTEGER, in_id_usuario INTEGER)
CREATE OR REPLACE FUNCTION Alerta_Cliente_Usuario(in_id_cliente INTEGER, in_id_usuario INTEGER)
RETURNS TABLE (id_cliente INTEGER) AS $$
DECLARE
    aux_id_cliente INTEGER;
BEGIN
	aux_id_cliente := 0;

	SELECT cl.id_cliente
	INTO aux_id_cliente		
	FROM cliente cl JOIN agente ag
			ON (cl.id_agente = ag.id_agente
				AND cl.id_cliente = in_id_cliente)
		JOIN oficina o
			ON (ag.id_oficina = o.id_oficina)
		JOIN usuario u
			ON (u.id_usuario = in_id_usuario 
				AND (u.id_rol = 1 
					 OR
					 o.id_oficina = u.id_oficina))
	LIMIT 1;
	RETURN QUERY SELECT aux_id_cliente;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Alerta_Cliente_Usuario(1,5)

--DROP FUNCTION Cargar_Bono_Referido(in_id_cliente INTEGER, in_id_usuario INTEGER, in_monto INTEGER, in_id_cuenta_bancaria INTEGER, in_id_operacion INTEGER)
CREATE OR REPLACE FUNCTION Cargar_Bono_Referido(in_id_cliente INTEGER, in_id_usuario INTEGER, in_monto INTEGER, in_id_cuenta_bancaria INTEGER, in_id_operacion INTEGER)
RETURNS TABLE (id_operacion INTEGER, codigo_operacion INTEGER) AS $$
DECLARE
    aux_id_operacion INTEGER;
    aux_codigo_operacion INTEGER;
    aux_codigo_operacion_referido INTEGER;
    aux_cliente_usuario_referido VARCHAR(100);
BEGIN
	SELECT COUNT(op.id_operacion) + 1
	INTO 	aux_codigo_operacion
	FROM 	operacion op
	WHERE 	op.id_cliente = in_id_cliente;
	
	SELECT	cl.cliente_usuario, op.codigo_operacion
	INTO aux_cliente_usuario_referido, aux_codigo_operacion_referido
	FROM operacion op JOIN cliente cl
		ON (op.id_cliente = cl.id_cliente
		   AND op.id_operacion = in_id_operacion);
		   
	INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (aux_codigo_operacion, 9, in_id_cliente, 2, false, false, now(), now(), in_id_usuario)
	RETURNING operacion.id_operacion INTO aux_id_operacion;
	
	INSERT INTO operacion_carga (id_operacion, titular, importe, bono, id_cuenta_bancaria, sol_importe, sol_bono, sol_id_cuenta_bancaria, observaciones)
	VALUES (aux_id_operacion, '', 0, in_monto, in_id_cuenta_bancaria, 0, in_monto, in_id_cuenta_bancaria, CONCAT('Cliente : ', aux_cliente_usuario_referido, ' - Op : ', aux_codigo_operacion_referido));

	RETURN QUERY SELECT aux_id_operacion, aux_codigo_operacion;
END;
$$ LANGUAGE plpgsql;
--select * from Cargar_Bono_Referido(4, 1, 1000, 1 ,2);

DROP TABLE IF EXISTS notificacion;
CREATE TABLE IF NOT EXISTS notificacion
(
    id_notificacion serial NOT NULL,
    id_usuario integer NOT NULL,
    id_cuenta_bancaria integer NOT NULL,
    titulo varchar(100) NOT NULL,
    mensaje varchar(200) NOT NULL,
    fecha_hora timestamp NOT NULL,
	id_notificacion_origen varchar(200) NOT NULL DEFAULT '-',
	id_origen integer NOT NULL DEFAULT 1,
	anulada boolean NOT NULL DEFAULT false,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 1,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
    PRIMARY KEY (id_notificacion)
);
CREATE INDEX notificacion_id_usuario ON notificacion (id_usuario);
CREATE INDEX notificacion_id_cuenta_bancaria ON notificacion (id_cuenta_bancaria);
CREATE INDEX notificacion_fecha_hora ON notificacion (fecha_hora DESC);

DROP TABLE IF EXISTS notificacion_carga;
CREATE TABLE IF NOT EXISTS notificacion_carga
(
    id_notificacion_carga serial NOT NULL,
    id_notificacion integer NOT NULL,
    id_operacion_carga integer,
    carga_usuario varchar(100),
    carga_monto numeric,
    marca_procesado boolean NOT NULL DEFAULT false,
    fecha_hora_procesado timestamp NOT NULL,
    PRIMARY KEY (id_notificacion_carga)
);
CREATE INDEX notificacion_carga_id_notificacion ON notificacion_carga (id_notificacion DESC);
CREATE INDEX notificacion_carga_id_operacion_carga ON notificacion_carga (id_operacion_carga DESC);
CREATE INDEX notificacion_carga_fecha_hora_procesado ON notificacion_carga (fecha_hora_procesado DESC);

--DROP FUNCTION Registrar_Notificacion(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER, in_titulo VARCHAR(100), in_mensaje VARCHAR(200), in_id_notificacion_origen VARCHAR(200), in_id_origen INTEGER)
CREATE OR REPLACE FUNCTION Registrar_Notificacion(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER, in_titulo VARCHAR(100), in_mensaje VARCHAR(200), in_id_notificacion_origen VARCHAR(200), in_id_origen INTEGER)
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
				   		AND id_cuenta_bancaria = in_id_cuenta_bancaria
						AND titulo = in_titulo
						AND mensaje = in_mensaje
						AND id_origen = in_id_origen) THEN
			-- Si ya existe, establecer aux_id_notificacion a -1
			aux_id_notificacion := -1;

		ELSE
			-- Si no existe, insertar nueva notificación y obtener el ID insertado
			INSERT INTO notificacion (id_usuario, id_cuenta_bancaria, titulo, mensaje, fecha_hora, id_notificacion_origen, id_origen, anulada, id_usuario_ultima_modificacion, fecha_hora_ultima_modificacion)
			VALUES (in_id_usuario, in_id_cuenta_bancaria, in_titulo, in_mensaje, now(), in_id_notificacion_origen, in_id_origen, false, in_id_usuario, now())
			RETURNING notificacion.id_notificacion into aux_id_notificacion;

		END IF;
    END;
	
	RETURN QUERY SELECT aux_id_notificacion;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM notificacion order by 1 desc;

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

CREATE OR REPLACE FUNCTION Registrar_Anulacion_Carga(in_id_notificacion INTEGER, in_id_usuario INTEGER)
RETURNS VOID AS $$
BEGIN
	UPDATE notificacion
	SET		anulada = true,
			id_usuario_ultima_modificacion = in_id_usuario,
			fecha_hora_ultima_modificacion = now()
	WHERE id_notificacion = in_id_notificacion;

	UPDATE notificacion_carga
	SET		marca_procesado = true,
			fecha_hora_procesado = now()
	WHERE id_notificacion = in_id_notificacion;
	
END;
$$ LANGUAGE plpgsql;
--select Registrar_Anulacion_Carga(1968, 1)
--select Registrar_Anulacion_Carga(1969, 1)
--select * from v_Notificaciones_Cargas where anulada = true order by 1 desc

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
-- SELECT CalcularPorcentajePalabrasEncontradas('dario lopez', 'dario miguel lopez') AS porcentaje;

-- DROP FUNCTION Verificar_Notificacion_Carga(in_id_notificacion_carga INTEGER)
CREATE OR REPLACE FUNCTION Verificar_Notificacion_Carga(in_id_notificacion_carga INTEGER)
RETURNS TABLE (	id_operacion_carga INTEGER,
			   	id_operacion INTEGER,
			   	cantidad_cargas INTEGER,
				monto numeric, 
				bono numeric, 
				id_cliente INTEGER, 
				usuario VARCHAR(200), 
				id_cliente_ext BIGINT, 
				id_cliente_db INTEGER,
				agente_usuario VARCHAR(200),
				agente_password VARCHAR(200),
			  	id_plataforma INTEGER,
				referente_id_cliente INTEGER, 
				referente_usuario VARCHAR(200), 
				referente_id_cliente_ext BIGINT, 
				referente_id_cliente_db INTEGER) AS $$
DECLARE aux_id_operacion_carga INTEGER;
DECLARE aux_id_cliente INTEGER;
DECLARE aux_porcentaje_origen1 DECIMAL(10, 2);
DECLARE aux_cantidad_cargas INTEGER;
BEGIN
	aux_porcentaje_origen1 := 0.25;
	
	SELECT	opc.id_operacion_carga, op.id_cliente
	INTO 	aux_id_operacion_carga, aux_id_cliente
	FROM 	operacion_carga opc JOIN notificacion_carga nc
			ON (nc.marca_procesado = false
				AND CalcularPorcentajePalabrasEncontradas(lower(opc.titular), lower(nc.carga_usuario)) >= aux_porcentaje_origen1
				AND opc.importe = nc.carga_monto
			   	AND nc.id_operacion_carga IS NULL
			   	AND nc.id_notificacion_carga = in_id_notificacion_carga)
		JOIN notificacion n
			ON (n.id_notificacion = nc.id_notificacion
				-- AND n.id_cuenta_bancaria = 1
			   AND n.id_origen = 1)
		JOIN operacion op
			ON (op.id_operacion = opc.id_operacion
			   AND op.id_estado = 1
			   AND op.marca_baja = false
			   AND op.id_accion = 1)
		JOIN cliente cl
			ON (op.id_cliente = cl.id_cliente)
		JOIN agente ag
			ON (cl.id_agente = ag.id_agente)
		JOIN usuario u
			ON (n.id_usuario = u.id_usuario
			   AND u.id_oficina = ag.id_oficina);

	IF (aux_id_operacion_carga IS NULL) THEN
		aux_id_operacion_carga := -1;
		aux_id_cliente := -1;
	END IF;
	
	IF (aux_id_operacion_carga > 0) THEN
		SELECT	COALESCE(COUNT(*), 0)
		INTO 	aux_cantidad_cargas
		FROM 	operacion_carga opc JOIN operacion op
				ON (op.id_estado = 2
					AND op.id_cliente = aux_id_cliente
					AND op.id_operacion = opc.id_operacion);
		
		RETURN QUERY SELECT	aux_id_operacion_carga,
				op.id_operacion,
				aux_cantidad_cargas,
				opc.importe + opc.bono,
				opc.bono,
				cl.id_cliente,
				cl.cliente_usuario, 
				cl.id_cliente_ext, 
				cl.id_cliente_db,
				ag.agente_usuario,
				ag.agente_password,
				ag.id_plataforma,
				COALESCE(clt.id_cliente, 0),
				COALESCE(clt.cliente_usuario, ''), 
				COALESCE(clt.id_cliente_ext, 0)::BIGINT, 
				COALESCE(clt.id_cliente_db, 0)
		FROM 	operacion_carga opc JOIN operacion op
					ON (opc.id_operacion_carga = aux_id_operacion_carga
						AND op.id_operacion = opc.id_operacion)
				JOIN cliente cl
					ON (op.id_cliente = cl.id_cliente)
				JOIN agente ag
					ON (cl.id_agente = ag.id_agente)
				LEFT JOIN registro_token rt
					ON (rt.id_registro_token = cl.id_registro_token)
				LEFT JOIN cliente clt
					ON (rt.id_usuario = clt.id_cliente);
	ELSE 
		RETURN QUERY SELECT	aux_id_operacion_carga, 0, 0, 0::numeric, 0::numeric, 0, ''::VARCHAR(200), 0::BIGINT, 0, ''::VARCHAR(200), ''::VARCHAR(200), 0, 0, ''::VARCHAR(200), 0::BIGINT, 0;
	END IF;
END;
$$ LANGUAGE plpgsql;
-- select * from Verificar_Notificacion_Carga(260);
-- select * from Verificar_Notificacion_Carga(261);
-- select * from Verificar_Notificacion_Carga(564);
-- select * from Verificar_Notificacion_Carga(2086);
-- select * from Verificar_Notificacion_Carga(2084);

-- DROP FUNCTION Verificar_Operacion_Carga(in_id_operacion INTEGER)
CREATE OR REPLACE FUNCTION Verificar_Operacion_Carga(in_id_operacion INTEGER)
RETURNS TABLE (	id_operacion_carga INTEGER,
			   	id_operacion INTEGER,
			   	id_notificacion_carga INTEGER,
			   	id_usuario INTEGER, 
			   	id_cuenta_bancaria INTEGER,
			   	cantidad_cargas INTEGER,
				monto numeric, 
				bono numeric, 
				id_cliente INTEGER, 
				usuario VARCHAR(200), 
				id_cliente_ext BIGINT, 
				id_cliente_db INTEGER,
				agente_usuario VARCHAR(200),
				agente_password VARCHAR(200),
			  	id_plataforma INTEGER,
				referente_id_cliente INTEGER, 
				referente_usuario VARCHAR(200), 
				referente_id_cliente_ext BIGINT, 
				referente_id_cliente_db INTEGER) AS $$
DECLARE aux_id_operacion_carga INTEGER;
DECLARE aux_id_cliente INTEGER;
DECLARE aux_porcentaje_origen1 DECIMAL(10, 2);
DECLARE aux_cantidad_cargas INTEGER;
DECLARE aux_id_notificacion_carga INTEGER;
DECLARE aux_id_usuario INTEGER;
DECLARE aux_id_cuenta_bancaria INTEGER;
BEGIN
	aux_porcentaje_origen1 := 0.25;
	
	SELECT	opc.id_operacion_carga, op.id_cliente, nc.id_notificacion_carga, n.id_usuario, n.id_cuenta_bancaria
	INTO 	aux_id_operacion_carga, aux_id_cliente, aux_id_notificacion_carga, aux_id_usuario, aux_id_cuenta_bancaria
	FROM 	operacion_carga opc JOIN notificacion_carga nc
			ON (nc.marca_procesado = false
				AND CalcularPorcentajePalabrasEncontradas(lower(opc.titular), lower(nc.carga_usuario)) >= aux_porcentaje_origen1
				AND opc.importe = nc.carga_monto
			   	AND nc.id_operacion_carga IS NULL)
		JOIN notificacion n
			ON (n.id_notificacion = nc.id_notificacion
				-- AND n.id_cuenta_bancaria = 1
			   	AND n.id_origen = 1)
		JOIN operacion op
			ON (op.id_operacion = opc.id_operacion
				AND op.id_operacion = in_id_operacion)
		JOIN cliente cl
			ON (op.id_cliente = cl.id_cliente)
		JOIN agente ag
			ON (cl.id_agente = ag.id_agente)
		JOIN usuario u
			ON (n.id_usuario = u.id_usuario
			   AND u.id_oficina = ag.id_oficina);

	IF (aux_id_operacion_carga IS NULL) THEN
		aux_id_operacion_carga := -1;
		aux_id_cliente := -1;
	END IF;
	
	IF (aux_id_operacion_carga > 0) THEN
		SELECT	COALESCE(COUNT(*), 0)
		INTO 	aux_cantidad_cargas
		FROM 	operacion_carga opc JOIN operacion op
				ON (op.id_estado = 2
					AND op.id_cliente = aux_id_cliente
					AND op.id_operacion = opc.id_operacion);
		
		RETURN QUERY SELECT	aux_id_operacion_carga,
				op.id_operacion,
				aux_id_notificacion_carga, 
				aux_id_usuario, 
				aux_id_cuenta_bancaria,
				aux_cantidad_cargas,
				opc.importe + opc.bono,
				opc.bono,
				cl.id_cliente,
				cl.cliente_usuario, 
				cl.id_cliente_ext, 
				cl.id_cliente_db,
				ag.agente_usuario,
				ag.agente_password,
				ag.id_plataforma,
				COALESCE(clt.id_cliente, 0),
				COALESCE(clt.cliente_usuario, ''), 
				COALESCE(clt.id_cliente_ext, 0)::BIGINT, 
				COALESCE(clt.id_cliente_db, 0)
		FROM 	operacion_carga opc JOIN operacion op
					ON (op.id_operacion = in_id_operacion
						AND op.id_operacion = opc.id_operacion)
				JOIN cliente cl
					ON (op.id_cliente = cl.id_cliente)
				JOIN agente ag
					ON (cl.id_agente = ag.id_agente)
				LEFT JOIN registro_token rt
					ON (rt.id_registro_token = cl.id_registro_token)
				LEFT JOIN cliente clt
					ON (rt.id_usuario = clt.id_cliente);
	ELSE 
		RETURN QUERY SELECT	aux_id_operacion_carga, 0, 0, 0, 0, 0, 0::numeric, 0::numeric, 0, ''::VARCHAR(200), 0::BIGINT, 0, ''::VARCHAR(200), ''::VARCHAR(200), 0, 0, ''::VARCHAR(200), 0::BIGINT, 0;
	END IF;
END;
$$ LANGUAGE plpgsql;
--select * from Verificar_Operacion_Carga(11749)
--select * from Verificar_Operacion_Carga(11802)

/* DROP FUNCTION Confirmar_Notificacion_Carga(in_id_notificacion_carga INTEGER, 
														in_id_operacion_carga INTEGER, 
														in_id_operacion INTEGER, 
														in_id_usuario INTEGER, 
														in_id_cuenta_bancaria INTEGER)*/
CREATE OR REPLACE FUNCTION Confirmar_Notificacion_Carga(in_id_notificacion_carga INTEGER, 
														in_id_operacion_carga INTEGER, 
														in_id_operacion INTEGER, 
														in_id_usuario INTEGER, 
														in_id_cuenta_bancaria INTEGER)
RETURNS VOID AS $$
BEGIN
	UPDATE 	notificacion_carga
	SET 	id_operacion_carga = in_id_operacion_carga,
			marca_procesado = true,
			fecha_hora_procesado = now()
	WHERE 	notificacion_carga.id_notificacion_carga = in_id_notificacion_carga;
	
	UPDATE 	operacion
	SET		id_estado = 2,
			notificado = false,
			fecha_hora_ultima_modificacion = now(),
			id_usuario_ultima_modificacion = in_id_usuario
	WHERE 	operacion.id_operacion = in_id_operacion;
	
	UPDATE 	operacion_carga
	SET		id_cuenta_bancaria = in_id_cuenta_bancaria
	WHERE 	operacion_carga.id_operacion_carga = in_id_operacion_carga;
END;
$$ LANGUAGE plpgsql;

--------------Vistas de Monitoreo y Gestión---------------------
--(excepto v_Cuenta_Bancaria_Activa)
--DROP VIEW v_Console_Logs;
CREATE OR REPLACE VIEW v_Console_Logs AS
SELECT 	cl.mensaje_log, 
		cl.fecha_hora, 
		cl.id 
FROM console_logs cl
ORDER BY cl.id DESC;
--select * from v_Console_Logs;

--DROP VIEW v_Oficinas;
CREATE OR REPLACE VIEW v_Oficinas AS
SELECT 	id_oficina,
		oficina,
		contacto_whatsapp,
		contacto_telegram,
		bono_carga_1,
		bono_carga_perpetua,
		minimo_carga,
		minimo_retiro,
		minimo_espera_retiro,
		fecha_hora_creacion,
		id_usuario_creacion,
		fecha_hora_ultima_modificacion,
		id_usuario_ultima_modificacion,
		marca_baja
FROM oficina;
--select * from v_Oficinas;

--DROP VIEW v_Plataformas;
CREATE OR REPLACE VIEW v_Plataformas AS
SELECT 	id_plataforma,
		plataforma,
		url_admin,
		url_juegos,
		imagen,
		marca_baja
FROM plataforma;
--select * from v_Plataformas;

--DROP VIEW v_Cuentas_Bancarias;
CREATE OR REPLACE VIEW v_Cuentas_Bancarias AS
SELECT	cn.id_cuenta_bancaria,
		cn.id_oficina,
		o.oficina,
		cn.id_billetera,
		b.billetera,
		cn.nombre,
		cn.alias,
		cn.cbu,
		COALESCE(cbmp.access_token, '') 	as access_token,
		COALESCE(cbmp.public_key, '') 		as public_key,
		COALESCE(cbmp.client_id, '') 		as client_id,
		COALESCE(cbmp.client_secret, '') 	as client_secret,
		cn.fecha_hora_creacion,
		cn.marca_baja
FROM cuenta_bancaria cn JOIN oficina o
			ON (cn.id_oficina = o.id_oficina)
		JOIN billetera b
			ON (cn.id_billetera = b.id_billetera)
		LEFT JOIN cuenta_bancaria_mercado_pago cbmp
			ON (cn.id_cuenta_bancaria = cbmp.id_cuenta_bancaria);
--select * from v_Cuentas_Bancarias

-- DROP VIEW v_Cuentas_Bancarias_Descargas;
CREATE OR REPLACE VIEW v_Cuentas_Bancarias_Descargas AS
select 	cbd.id_cuenta_bancaria_descarga,
		cbd.id_cuenta_bancaria,
		cb.nombre,
		cb.alias,
		cb.cbu,
		cbd.id_usuario,
		u.usuario,
		cbd.fecha_hora_descarga,
		cbd.cargas_monto,
		cbd.cargas_cantidad		
from cuenta_bancaria_descarga cbd join cuenta_bancaria cb
			on (cbd.id_cuenta_bancaria = cb.id_cuenta_bancaria)
		join usuario u
			on (u.id_usuario = cbd.id_usuario);
--select * from v_Cuentas_Bancarias_Descargas

-- DROP VIEW v_Agentes;
CREATE OR REPLACE VIEW v_Agentes AS
SELECT 	ag.id_agente,
		ag.agente_usuario,
		ag.agente_password,
		ag.id_plataforma,
		pl.plataforma,
		ag.id_oficina,
		ag.tokens_bono_carga_1,
		ag.tokens_bono_creacion,
		o.oficina,
		ag.marca_baja,
		ag.fecha_hora_creacion,
		ag.id_usuario_creacion,
		ag.fecha_hora_ultima_modificacion,
		ag.id_usuario_ultima_modificacion		
FROM agente ag JOIN plataforma pl
		ON (ag.id_plataforma = pl.id_plataforma)
	JOIN oficina o
		ON (ag.id_oficina = o.id_oficina);
--SELECT * FROM v_Agentes

-- DROP VIEW v_Usuarios;
CREATE OR REPLACE VIEW v_Usuarios AS
select 	u.id_usuario,
		u.usuario,
		u.fecha_hora_creacion,
		u.marca_baja,
		u.id_rol,
		r.nombre_rol,
		u.id_oficina,
		o.oficina
from usuario u join rol r
		on (u.id_rol = r.id_rol)
	join oficina o
		ON (u.id_oficina = o.id_oficina);
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
		u.usuario,
		r.nombre_rol,
		o.oficina
FROM	usuario_sesion us JOIN usuario u
			ON (us.id_usuario = u.id_usuario)
		JOIN rol r
			ON (u.id_rol = r.id_rol)
		JOIN oficina o
			ON (u.id_oficina = o.id_oficina);
--select * from v_Usuarios_Sesiones

-- DROP VIEW v_Clientes_Sesiones;
CREATE OR REPLACE VIEW v_Clientes_Sesiones AS
SELECT 	cl.id_cliente,
		cl.cliente_usuario,
		cs.id_cliente_sesion,
		cs.ip,
		cs.moneda,
		cs.monto,
		cs.fecha_hora_creacion,
		CASE 
			WHEN cs.cierre_abrupto = true THEN 'Cierre Abrupto'
			ELSE COALESCE(TO_CHAR(cs.fecha_hora_cierre, 'YYYY/MM/DD HH24:MI:SS'), 'Abierta')
		END AS fecha_hora_cierre
FROM	cliente_sesion cs JOIN cliente cl
			ON (cs.id_cliente = cl.id_cliente);
--select * from v_Clientes_Sesiones 

-- DROP VIEW v_Clientes_Cargas;
CREATE OR REPLACE VIEW v_Clientes_Cargas AS
SELECT 	c.id_cliente,
		c.cliente_usuario,
		c.id_agente,
		MAX(COALESCE(cr.cliente_usuario, ''))	AS cliente_usuario_referente,
		MAX(COALESCE(cr.id_cliente, 0))			AS id_cliente_usuario_referente,
		COALESCE(COUNT(o.id_operacion), 0) 		AS cantidad_cargas,
		COALESCE(SUM(oc.importe), 0)			AS total_importe_cargas,
		COALESCE(SUM(oc.bono), 0)				AS total_importe_bonos,
		COALESCE(MAX(o.fecha_hora_creacion), '1900-01-01')	AS ultima_carga
FROM cliente c LEFT JOIN operacion o
			ON (c.id_cliente = o.id_cliente
			   AND o.marca_baja = false
			   AND o.id_accion IN (1, 5)
			   AND o.id_estado = 2)
		LEFT JOIN operacion_carga oc
			ON (o.id_operacion = oc.id_operacion)
		LEFT JOIN registro_token rt
			ON (c.id_registro_token = rt.id_registro_token
			   AND rt.de_agente = false
			   AND rt.activo = true)
		LEFT JOIN cliente cr
			ON (rt.id_usuario = cr.id_cliente
			   AND cr.marca_baja = false
			   AND cr.bloqueado = false)
WHERE c.marca_baja = false
GROUP BY c.id_cliente, c.cliente_usuario, c.id_agente;
--SELECT * FROM v_Clientes_Cargas;

-- DROP VIEW v_Clientes_Retiros;
CREATE OR REPLACE VIEW v_Clientes_Retiros AS
SELECT 	c.id_cliente,
		c.cliente_usuario,
		c.id_agente,
		COALESCE(COUNT(o.id_operacion), 0) 		AS cantidad_cargas,
		COALESCE(SUM(oc.importe), 0)			AS total_importe_retiros,
		COALESCE(MAX(o.fecha_hora_creacion), '1900-01-01')	AS ultimo_retiro,
		ROUND(EXTRACT(EPOCH FROM (NOW() - COALESCE(MAX(o.fecha_hora_creacion), '2024-04-01 00:00:00'))) / 3600, 0) AS horas_ultimo_retiro
FROM cliente c LEFT JOIN operacion o
			ON (c.id_cliente = o.id_cliente
			   AND o.marca_baja = false
			   AND o.id_accion IN (2, 6)
			   AND o.id_estado IN (1, 2))
		LEFT JOIN operacion_retiro oc
			ON (o.id_operacion = oc.id_operacion)
WHERE c.marca_baja = false
GROUP BY c.id_cliente, c.cliente_usuario, c.id_agente;
--SELECT * FROM v_Clientes_Retiros;

--DROP VIEW v_Clientes_Operaciones
CREATE OR REPLACE VIEW v_Clientes_Operaciones AS
SELECT 	cl.id_cliente,
		cl.cliente_usuario,
		cl.id_cliente_ext,
		cl.id_cliente_db,
		cl.id_agente,
		ag.agente_usuario,
		ag.agente_password,
		ag.id_plataforma,
		pla.plataforma,
		ag.id_oficina,
		o.marca_baja,
		ofi.oficina,
		o.id_operacion,
		o.codigo_operacion,
		e.id_estado,
		e.estado,
		ac.id_accion,
		ac.accion,
		u.usuario,
		ROUND(COALESCE(clconf.Aceptadas::numeric, 0) / COALESCE(clconf.Totales::numeric, 1) * 100) AS cliente_confianza,
		COALESCE(o.fecha_hora_creacion, '1900-01-01')		AS fecha_hora_operacion,
		COALESCE(o.fecha_hora_ultima_modificacion, '1900-01-01')	AS fecha_hora_proceso,
		COALESCE(opr.importe, 0)							AS retiro_importe,
		COALESCE(opr.cbu, '')								AS retiro_cbu,
		COALESCE(opr.titular, '')							AS retiro_titular,
		COALESCE(opr.observaciones, '')						AS retiro_observaciones,
		COALESCE(opc.importe, 0)							AS carga_importe,
		COALESCE(opc.titular, '')							AS carga_titular,
		COALESCE(opc.id_cuenta_bancaria, 0)					AS carga_id_cuenta_bancaria,
		COALESCE(opc.bono, 0)								AS carga_bono,
		COALESCE(opc.observaciones, '')						AS carga_observaciones,
		COALESCE(opcb.nombre || '-' || opcb.alias || '-' || opcb.cbu, '')	AS carga_cuenta_bancaria,
		COALESCE(opcb.nombre, '')	AS carga_cuenta_bancaria_nombre,
		COALESCE(opcb.alias, '')	AS carga_cuenta_bancaria_alias,
		COALESCE(opcb.cbu, '')	AS carga_cuenta_bancaria_cbu,
		COALESCE(nc.id_notificacion, 0)	AS id_notificacion
FROM cliente cl JOIN operacion o
			ON (cl.id_cliente = o.id_cliente
			   	AND o.marca_baja = false)
		JOIN usuario u
			ON (o.id_usuario_ultima_modificacion = u.id_usuario)
		JOIN estado e
			ON (o.id_estado = e.id_estado)
		JOIN accion ac
			ON (o.id_accion = ac.id_accion)
		JOIN agente ag
			ON (cl.id_agente = ag.id_agente)
		JOIN oficina ofi
			ON (ag.id_oficina = ofi.id_oficina)
		JOIN plataforma pla
			ON (ag.id_plataforma = pla.id_plataforma)
		LEFT JOIN (SELECT id_cliente,
					COUNT(*) AS Totales,
					SUM(CASE WHEN id_estado = 2 THEN 1 ELSE 0 END) AS Aceptadas
				FROM operacion o
				WHERE id_accion = 1
					AND id_estado in (2,3)
					AND marca_baja = false
				GROUP BY id_cliente) clconf
			ON (cl.id_cliente = clconf.id_cliente)
		LEFT JOIN operacion_retiro opr
			ON (o.id_operacion = opr.id_operacion)
		LEFT JOIN operacion_carga opc
			ON (o.id_operacion = opc.id_operacion)
		LEFT JOIN cuenta_bancaria opcb
			ON (opc.id_cuenta_bancaria = opcb.id_cuenta_bancaria)
		LEFT JOIN notificacion_carga nc
			ON (nc.id_operacion_carga = opc.id_operacion_carga)
WHERE cl.marca_baja = false;
--select * from v_Clientes_Operaciones where id_cliente = 18 order by id_operacion desc
--221msec

--DROP VIEW v_Clientes
CREATE OR REPLACE VIEW v_Clientes AS
SELECT 	cl.id_cliente,
		cl.cliente_usuario,
		cl.cliente_password,
		cl.bloqueado,
		cl.id_agente,
		cl.id_cliente_ext,
		cl.id_cliente_db,
		ag.agente_usuario,
		ag.agente_password,
		ag.id_plataforma,
		pla.plataforma,
		ag.id_oficina,
		ofi.oficina,
		COALESCE(ope.ult_operacion, '2000-01-01') 	as ult_operacion,
		COALESCE(ope.visto_cliente, 1)				as visto_cliente,
		COALESCE(ope.visto_operador, 1)			as visto_operador
FROM cliente cl JOIN agente ag
			ON (cl.id_agente = ag.id_agente)
		JOIN oficina ofi
			ON (ag.id_oficina = ofi.id_oficina)
		JOIN plataforma pla
			ON (ag.id_plataforma = pla.id_plataforma)
		LEFT JOIN (SELECT	id_cliente,
							MIN(visto_cliente::int) AS visto_cliente,
							MIN(visto_operador::int) AS visto_operador,
							MAX(ult_operacion) AS ult_operacion
					FROM
						(SELECT 	id_cliente,
								MIN(visto_cliente::int) AS visto_cliente,
								MIN(visto_operador::int) AS visto_operador,
								MAX(fecha_hora_creacion) AS ult_operacion
						FROM cliente_chat 
						GROUP BY id_cliente
						UNION
						SELECT 	id_cliente,
								MIN(visto_cliente::int) AS visto_cliente,
								MIN(visto_operador::int) AS visto_operador,
								MAX(fecha_hora_creacion) AS ult_operacion
						FROM cliente_chat_adjunto 
						GROUP BY id_cliente						 
						UNION
						SELECT 	id_cliente,
								1 AS visto_cliente,
								1 AS visto_operador,
								MAX(fecha_hora_ultima_modificacion) AS ult_operacion
						FROM operacion
						GROUP BY id_cliente) operacion
					GROUP BY id_cliente) ope
			ON (cl.id_cliente = ope.id_cliente)
WHERE cl.marca_baja = false
GROUP BY cl.id_cliente,
		cl.cliente_usuario,
		cl.cliente_password,
		cl.bloqueado,
		cl.id_agente,
		ag.agente_usuario,
		ag.agente_password,
		ag.id_plataforma,
		pla.plataforma,
		ag.id_oficina,
		ofi.oficina,
		ope.ult_operacion,
		ope.visto_cliente,
		ope.visto_operador;
--select * from v_Clientes order by ult_operacion desc

--DROP VIEW v_Cliente_Registro
CREATE OR REPLACE VIEW v_Cliente_Registro AS
SELECT 	cl.id_cliente,
		cl.cliente_usuario,
		cl.cliente_password,
		cl.fecha_hora_creacion,
		cl.correo_electronico,
		cl.telefono,
		rto.id_token,
		rto.ingresos,
		rto.registros,
		rto.cargaron,
		rto.total_cargas,
		rto.total_importe,
		rto.total_bono,
		COALESCE(rtr.id_registro_token, 0)	AS id_registro_token,
		COALESCE(rtr.de_agente, false)		AS de_agente,
		COALESCE(clr.cliente_usuario, '')	AS cliente_referente
FROM	cliente cl JOIN registro_token rt
			ON (rt.de_agente = false
			   AND rt.id_usuario = cl.id_cliente)
		JOIN v_Tokens_Operacion rto
			ON (rt.id_registro_token = rto.id_registro_token)
		LEFT JOIN registro_token rtr
			ON (cl.id_registro_token  = rtr.id_registro_token)
		LEFT JOIN cliente clr
			ON (rtr.de_agente = false AND rtr.id_usuario = clr.id_cliente);
--SELECT * FROM v_Cliente_Registro

--DROP VIEW v_Cliente_Alertas
CREATE OR REPLACE VIEW v_Cliente_Alertas AS
SELECT 	cl.id_cliente,
		cl.cliente_usuario,
		cl.cliente_password,
		cl.fecha_hora_creacion,
		cl.correo_electronico,
		cl.telefono,
		rto.id_token,
		rto.ingresos,
		rto.registros,
		rto.cargaron,
		rto.total_cargas,
		rto.total_importe,
		rto.total_bono,
		COALESCE(rtr.id_registro_token, 0)	AS id_registro_token,
		COALESCE(rtr.de_agente, false)		AS de_agente,
		COALESCE(clr.cliente_usuario, '')	AS cliente_referente
FROM	cliente cl JOIN registro_token rt
			ON (rt.de_agente = false
			   AND rt.id_usuario = cl.id_cliente)
		JOIN v_Tokens_Operacion rto
			ON (rt.id_registro_token = rto.id_registro_token)
		LEFT JOIN registro_token rtr
			ON (cl.id_registro_token  = rtr.id_registro_token)
		LEFT JOIN cliente clr
			ON (rtr.de_agente = false AND rtr.id_usuario = clr.id_cliente);
--SELECT * FROM v_Cliente_Registro

--DROP VIEW v_Tokens
CREATE OR REPLACE VIEW v_Tokens AS
SELECT 	rt.id_registro_token,
		rt.id_token,
		rt.activo,
		rt.de_agente,
		rt.bono_creacion,
		rt.bono_carga_1,
		rt.observaciones,
		COALESCE(cl.id_cliente, 0) 	AS id_cliente,
		COALESCE(cl.cliente_usuario, '') as cliente_usuario,
		ag.id_agente,
		ag.agente_usuario,
		ag.id_oficina,
		o.oficina,
		ag.id_plataforma,
		pl.plataforma,
		pl.url_juegos

FROM registro_token rt LEFT JOIN cliente cl
		ON (rt.id_usuario = cl.id_cliente 
			AND NOT rt.de_agente)
	JOIN agente ag
		ON ((cl.id_agente = ag.id_agente AND NOT rt.de_agente) 
			OR 
			(rt.id_usuario = ag.id_agente AND rt.de_agente))
	JOIN plataforma pl
		ON (ag.id_plataforma = pl.id_plataforma)
	JOIN oficina o
		ON (ag.id_oficina = o.id_oficina);
--select * from v_Tokens where id_token = 'a-1-9473764e8de991edc3899a179f8af9c1ce3d6ba';
--select * from v_Tokens where id_token = 'c-4-9473764e8de991edc3899a179f8af9c1ce3d6ba';

--DROP VIEW v_Tokens_Operacion
CREATE OR REPLACE VIEW v_Tokens_Operacion AS
SELECT 	tk.id_registro_token,
		tk.id_token,
		tk.ingresos,
		COUNT(DISTINCT tko.id_cliente)								AS registros,
		SUM(CASE WHEN tko.operaciones_carga > 0 THEN 1 ELSE 0 END)	AS cargaron,
		COALESCE(SUM(tko.cantidad_operaciones_carga),0)				AS total_cargas,
		COALESCE(SUM(tko.total_importe),0)							AS total_importe,
		COALESCE(SUM(tko.total_bono),0)								AS total_bono
FROM	registro_token tk LEFT JOIN (SELECT clr.id_registro_token,
									clr.id_cliente,
									COALESCE(MIN(opc.id_operacion_carga),0)			AS operaciones_carga,
									COALESCE(COUNT(opc.id_operacion_carga), 0)		AS cantidad_operaciones_carga,
									COALESCE(SUM(opc.importe),0)					AS total_importe,
									COALESCE(SUM(opc.bono),0)						AS total_bono
							FROM cliente clr LEFT JOIN operacion op
									ON (clr.id_cliente = op.id_cliente
									   AND op.id_estado = 2)
								LEFT JOIN operacion_carga opc
									ON (op.id_operacion = opc.id_operacion)
							WHERE clr.id_registro_token > 0
							GROUP BY clr.id_registro_token, clr.id_cliente) tko
					ON (tk.id_registro_token = tko.id_registro_token)
GROUP BY tk.id_registro_token,
		tk.id_token,
		tk.ingresos;
--select * from v_Tokens_Operacion

--DROP VIEW v_Tokens_Completo
CREATE OR REPLACE VIEW v_Tokens_Completo AS
SELECT 	tk.id_registro_token,
		tk.id_token,
		tk.activo,
		tk.id_oficina,
		tk.oficina,
		tk.id_plataforma,
		tk.plataforma,
		tk.url_juegos,
		tk.id_agente,
		tk.agente_usuario,
		tk.de_agente,
		tk.bono_creacion,
		tk.bono_carga_1,
		tko.ingresos,
		tko.registros,
		tko.cargaron,
		tko.total_cargas,
		tko.total_importe,
		tko.total_bono
FROM v_Tokens tk JOIN v_Tokens_Operacion tko
	ON (tk.id_registro_token = tko.id_registro_token)
WHERE tk.de_agente = true
UNION
SELECT 	0		AS id_registro_token,
		''		AS id_token,
		true	AS activo,
		tk.id_oficina,
		tk.oficina,
		tk.id_plataforma,
		tk.plataforma,
		tk.url_juegos,
		tk.id_agente,
		tk.agente_usuario,
		tk.de_agente,
		MAX(tk.bono_creacion) 	AS bono_creacion,
		MAX(tk.bono_carga_1)	AS bono_carga_1,
		SUM(tko.ingresos)		AS ingresos,
		SUM(tko.registros)		AS registros,
		SUM(tko.cargaron) 		AS cargaron,
		SUM(tko.total_cargas)	as total_cargas,
		SUM(tko.total_importe)	AS total_importe,
		SUM(tko.total_bono)		AS total_bono
FROM v_Tokens tk JOIN v_Tokens_Operacion tko
	ON (tk.id_registro_token = tko.id_registro_token)
WHERE tk.de_agente = false AND tk.activo = true
GROUP BY tk.id_oficina,
		tk.oficina,
		tk.id_plataforma,
		tk.plataforma,
		tk.url_juegos,
		tk.id_agente,
		tk.agente_usuario,
		tk.de_agente;
--select * from v_Tokens_Completo;

--DROP VIEW v_Tokens_Completo_Clientes
CREATE OR REPLACE VIEW v_Tokens_Completo_Clientes AS
SELECT 	tk.id_registro_token,
		tk.id_token,
		tk.id_agente,
		tk.agente_usuario,
		tk.cliente_usuario,
		tk.bono_carga_1,
		tk.activo,
		tko.ingresos,
		tko.registros,
		tko.cargaron,
		tko.total_cargas,
		tko.total_importe,
		tko.total_bono
FROM v_Tokens tk JOIN v_Tokens_Operacion tko
	ON (tk.id_registro_token = tko.id_registro_token)
WHERE tk.de_agente = false;
--select * from v_Tokens_Completo_Clientes

--DROP VIEW v_IP_Lista_Blanca
CREATE OR REPLACE VIEW v_IP_Lista_Blanca AS
SELECT	DISTINCT ip_ok.ip
FROM	(
	SELECT	cs.ip
	FROM	cliente_sesion cs JOIN cliente cl
				ON (cs.id_cliente = cl.id_cliente
				   AND cl.marca_baja = false
				   AND cl.bloqueado = false)
	UNION
	SELECT	us.ip
	FROM	usuario_sesion us JOIN usuario u
				ON (us.id_usuario = u.id_usuario
				   AND u.marca_baja = false)) ip_ok
WHERE ip_ok.ip NOT IN (SELECT	cs.ip
						FROM	cliente_sesion cs JOIN cliente cl
									ON (cs.id_cliente = cl.id_cliente
									   AND cl.marca_baja = false
									   AND cl.bloqueado = true));
--select * from v_IP_Lista_Blanca;			   

--DROP VIEW v_Cuenta_Bancaria_Mercado_Pago;
CREATE OR REPLACE VIEW v_Cuenta_Bancaria_Mercado_Pago AS
SELECT 	cb.id_cuenta_bancaria,
		cb.id_oficina,
		cb.nombre,
		cb.alias,
		cb.cbu,
		/*cba.nombre_aplicacion,
		cba.notificacion_descripcion,*/
		cbmp.access_token,
		cbmp.public_key,
		cbmp.client_id,
		cbmp.client_secret,
		us.id_usuario
FROM 	cuenta_bancaria cb JOIN cuenta_bancaria_mercado_pago cbmp
				ON (cb.id_cuenta_bancaria = cbmp.id_cuenta_bancaria
				   	AND cbmp.marca_baja = false)
			JOIN (SELECT 	u.id_oficina, 
				  			MIN(u.id_usuario) AS id_usuario 
				  	FROM usuario u
				  	WHERE u.id_rol = 2 
				  		AND u.marca_baja = false
				  	GROUP BY u.id_oficina) us
				ON (us.id_oficina = cb.id_oficina);
--select * from v_Cuenta_Bancaria_Mercado_Pago order by 1

--DROP VIEW v_Notificaciones_Cargas;
CREATE OR REPLACE VIEW v_Notificaciones_Cargas AS
SELECT	n.id_notificacion,
		n.id_usuario,
		u.id_oficina,
		o.oficina,
		n.id_cuenta_bancaria,
		cb.nombre,
		cb.alias,
		cb.cbu,
		n.titulo,
		n.mensaje,
		n.fecha_hora,
		n.id_notificacion_origen,
		n.id_origen,
		n.anulada,
		nc.id_notificacion_carga,
		nc.id_operacion_carga,
		nc.carga_usuario,
		nc.carga_monto,
		nc.marca_procesado,
		nc.fecha_hora_procesado,
		COALESCE(opc.importe, 0)	AS importe,
		COALESCE(opc.bono, 0)		AS bono,
		COALESCE(op.id_cliente,0 )	AS id_cliente,
		COALESCE(op.fecha_hora_creacion, '1900-01-01 00:00:00')	AS fecha_hora_creacion,
		COALESCE(cl.cliente_usuario, '' )	AS cliente_usuario,
		COALESCE(ag.agente_usuario, '' )	AS agente_usuario,
		COALESCE(pl.plataforma, '' )		AS plataforma,
		COALESCE(pl.url_admin, '' )			AS url_admin
FROM	notificacion n JOIN notificacion_carga nc
				ON (n.id_notificacion = nc.id_notificacion)
			JOIN usuario u
				ON (u.id_usuario = n.id_usuario)
			JOIN oficina o
				ON (u.id_oficina = o.id_oficina)
			JOIN cuenta_bancaria cb
				ON (n.id_cuenta_bancaria = cb.id_cuenta_bancaria)
			LEFT JOIN operacion_carga opc
				ON (nc.id_operacion_carga = opc.id_operacion_carga
				   AND cb.id_cuenta_bancaria = opc.id_cuenta_bancaria) -- revisar!!
			LEFT JOIN operacion op
				ON (op.id_operacion = opc.id_operacion
				   AND op.id_accion = 1
				   AND op.id_estado = 2
				   AND op.marca_baja = false)
			LEFT JOIN cliente cl
				ON (op.id_cliente = cl.id_cliente)
			LEFT JOIN agente ag
				ON (cl.id_agente = ag.id_agente)
			LEFT JOIN plataforma pl
				ON (pl.id_plataforma = ag.id_plataforma); 
--select * from v_Notificaciones_Cargas order by fecha_hora_procesado desc;

select 	oficina,
		agente_usuario, 
		plataforma,
		CASE WHEN id_notificacion > 0 THEN 'Automatico' ELSE 'Manual' END AS Tipo,
		sum(carga_importe)	as cargas,
		sum(carga_bono)		as bonos,
		sum(CASE WHEN id_accion in (1, 5, 9) THEN 1 ELSE 0 END) as cant_cargas,
		sum(retiro_importe)	as retiros,
		sum(CASE WHEN id_accion in (2, 6) THEN 1 ELSE 0 END) as cant_retiros
from v_Clientes_Operaciones
where id_estado = 2
and id_accion in (1, 2, 5, 6, 9)
and fecha_hora_proceso >= '2024-05-23 00:00:00'
and fecha_hora_proceso < '2024-05-24 00:00:00'
group by oficina,
		agente_usuario, 
		plataforma, Tipo
order by oficina,
		agente_usuario, 
		plataforma, Tipo;
-- 20/5 2532
-- 18/5 1670
-- 17/5 1709
-- 16/5 1645
-- 15/5 1424
-- 14/5 471

SELECT * FROM registro_sesiones_sockets order by 1 desc limit 2000

update cliente set id_cliente_ext = 4598399, id_cliente_db = 8
where id_cliente = 137

select * from agente where id_agente = 3
select * from v_Clientes_Operaciones where cliente_usuario = 'olgax522'
select * from cliente where id_cliente = 3060
select * from v_Cuentas_Bancarias where id_oficina = 1
select * from v_Cuenta_Bancaria_Mercado_Pago where id_oficina = 8
SELECT * FROM oficina
select * from v_Notificaciones_Cargas where id_cuenta_bancaria = 29
select * from v_Console_Logs

select * from v_Console_Logs;
SELECT * 
FROM registro_sesiones_sockets 
where fecha_hora >= '2024-05-20 14:00:00'
order by 1

select *
from v_Clientes_Operaciones 
where marca_baja = false

select * from v_Cuentas_Bancarias
WHERE id_oficina > 2
order by 1

select * from v_Console_Logs

select * from v_Tokens

insert into registro_token (id_token, de_agente, activo, id_usuario, ingresos, registros, fecha_hora_creacion, id_usuario_ultima_modificacion, fecha_hora_ultima_modificacion)
select 	concat('c-', id_cliente::varchar, '-', substr(translate(encode(gen_random_bytes(40), 'base64'), '/+', 'ab'), 1, 40)),
		false,
		true,
		id_cliente,
		0,
		0,
		now(),
		1,
		now()
from cliente
where id_cliente not in (select id_usuario 
						 from registro_token 
						 where activo = true and de_agente = false);
						 
SELECT substr(translate(encode(gen_random_bytes(40), 'base64'), '/+', 'ab'), 1, 40)
INTO aux_token;

select * from v_Cuenta_Bancaria_Mercado_Pago 
where id_oficina > 2
order by 1

select * from v_Console_Logs

select * from cliente where cliente_usuario = 'paulcarabajal688p'
select * from cliente_chat where id_cliente = 2340

/*****************************/
/*Anulacion de notificaciones*/

select * from cuenta_bancaria where id_cuenta_bancaria = 1
select * from usuario where id_usuario = 4

select * from Registrar_Notificacion(4, 1, 'Pago de Prueba', 'Pago de Prueba', 'Pago de Prueba 4', 1)

select * from Registrar_Notificacion_Carga(9642, 'miguel.jorge958@gmail.com jorgemiguel', 25000)

select 	TO_CHAR(fecha_hora, 'YYYY-MM-DD HH24:MI') AS fecha_hora,
    	COUNT(*) AS total_eventos
from notificacion
where fecha_hora >= '2024-05-20 14:00:00'
group by TO_CHAR(fecha_hora, 'YYYY-MM-DD HH24:MI')
order by 1;

SELECT n.*
FROM notificacion n JOIN notificacion_carga nc
	ON (n.id_notificacion = nc.id_notificacion
		AND n.fecha_hora < NOW() - INTERVAL '5 hour'
		AND n.anulada = false
	   	AND nc.id_operacion_carga IS NULL
	   	AND nc.marca_procesado = false)
ORDER BY n.fecha_hora

SELECT  *
FROM	v_Notificaciones_Cargas
	WHERE fecha_hora < NOW() - INTERVAL '1 hour'
	AND anulada = false
	AND id_operacion_carga IS NULL
	AND marca_procesado = false
ORDER BY fecha_hora
LIMIT 1

select * from v_Notificaciones_Cargas
where anulada = false
	AND id_operacion_carga IS NULL
	AND marca_procesado = false
ORDER BY fecha_hora

select * from cliente where lower(trim(cliente_usuario)) = 'gigi00222c';
select * from cliente 
order by cliente_usuario
where lower(trim(cliente_usuario)) = 'angie9822p';

select  cl.cliente_usuario, cc.* 
from cliente_chat cc join cliente cl
	on (cc.id_cliente = cl.id_cliente)
order by 2 desc
--order by cc.id_cliente_chat desc
update cliente set cliente_usuario = lower(trim(cliente_usuario));

select * from v_Clientes_Operaciones 
where id_oficina = 4
and id_accion = 1
order by fecha_hora_operacion desc

select * from operacion where id_operacion = 19188
select * from operacion_carga where id_operacion = 19188
select * from usuario where id_usuario = 18
select * from oficina
