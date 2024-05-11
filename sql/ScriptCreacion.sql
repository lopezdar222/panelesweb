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
    marca_baja boolean NOT NULL DEFAULT false,
    fecha_hora_creacion timestamp NOT NULL,
	id_usuario_creacion integer NOT NULL DEFAULT 0,
    fecha_hora_ultima_modificacion timestamp NOT NULL,
	id_usuario_ultima_modificacion integer NOT NULL DEFAULT 0,
    PRIMARY KEY (id_cuenta_bancaria)
);
CREATE INDEX cuenta_bancaria_id_oficina ON cuenta_bancaria (id_oficina);

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

/*****************************************************************************/
insert into plataforma (plataforma, url_admin, url_juegos, marca_baja)
values ('Casino 365 Club', 'https://bo.casinoenvivo.club', 'https://www.casino365online.club', false);

insert into rol (nombre_rol, fecha_hora_creacion) values ('Administrador', NOW());
insert into rol (nombre_rol, fecha_hora_creacion) values ('Encargado', NOW());
insert into rol (nombre_rol, fecha_hora_creacion) values ('Operador', NOW());
--select * from rol;

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
			VALUES (in_usuario, in_password, aux_id_agente, true, false, now(), 1,  now(), 1)
			RETURNING cliente.id_cliente INTO aux_id_cliente;
			
			INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
			VALUES (1, 7, aux_id_cliente, 2, false, false, now(), now(), 1);
			
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

--DROP FUNCTION Registrar_Cliente(in_id_agente INTEGER, in_usuario VARCHAR(200), in_password VARCHAR(200), in_correo_electronico VARCHAR(100), in_telefono VARCHAR(100), in_id_registro_token INTEGER)
CREATE OR REPLACE FUNCTION Registrar_Cliente(in_id_agente INTEGER, in_usuario VARCHAR(200), in_password VARCHAR(200), in_correo_electronico VARCHAR(100), in_telefono VARCHAR(100), in_id_registro_token INTEGER)
RETURNS TABLE (id_cliente INTEGER) AS $$
DECLARE
    aux_id_cliente INTEGER;
	aux_token VARCHAR(60);
	aux_bono_carga_1 INTEGER;
	aux_bono_creacion INTEGER;
BEGIN
	INSERT INTO cliente (cliente_usuario, cliente_password, id_agente, en_sesion, marca_baja, fecha_hora_creacion, id_usuario_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion, id_registro_token, correo_electronico, telefono)
	VALUES (in_usuario, in_password, in_id_agente, false, false, now(), 1,  now(), 1, in_id_registro_token, in_correo_electronico, in_telefono)
	RETURNING cliente.id_cliente INTO aux_id_cliente;

	INSERT INTO operacion (codigo_operacion, id_accion, id_cliente, id_estado, notificado, marca_baja, fecha_hora_creacion, fecha_hora_ultima_modificacion, id_usuario_ultima_modificacion)
	VALUES (1, 8, aux_id_cliente, 2, false, false, now(), now(), 1);

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

CREATE OR REPLACE FUNCTION Crear_Cuenta_Bancaria(in_id_oficina INTEGER, in_id_usuario INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_estado BOOLEAN) 
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
									 fecha_hora_creacion,
									 id_usuario_creacion,
									 fecha_hora_ultima_modificacion,
									 id_usuario_ultima_modificacion,
									 marca_baja)
		VALUES (in_id_oficina, in_nombre, in_alias, in_cbu, now(), in_id_usuario, now(), in_id_usuario, false)
		RETURNING cuenta_bancaria.id_cuenta_bancaria INTO aux_id_cuenta_bancaria;
		
	ELSE
		aux_id_cuenta_bancaria := 0;
		
	END IF;
	
	RETURN query SELECT aux_id_cuenta_bancaria;
END;
$$ LANGUAGE plpgsql;
--select * from Crear_Cuenta_Bancaria(1, 1, 'Noelia Caleza', 'noelia.227.caleza.mp', '0000003100091595755417' , 1, false);
--select * from cuenta_bancaria;

CREATE OR REPLACE FUNCTION Modificar_Cuenta_Bancaria(in_id_usuario INTEGER, in_id_cuenta_bancaria INTEGER, in_nombre VARCHAR(200), in_alias VARCHAR(200), in_cbu VARCHAR(200), in_estado BOOLEAN) 
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
								fecha_hora_ultima_modificacion = now(),
								id_usuario_ultima_modificacion = in_id_usuario
		WHERE cuenta_bancaria.id_cuenta_bancaria = in_id_cuenta_bancaria;
		
		aux_id_cuenta_bancaria := in_id_cuenta_bancaria;
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
		LEFT JOIN (select 	oc.id_cuenta_bancaria, 
							count(oc.importe) as cantidad_cargas, 
							sum(oc.importe) as monto_cargas
					from 	operacion_carga oc join operacion op
							on (op.id_operacion = oc.id_operacion
									and op.marca_baja = false
									and op.id_accion IN (1,5)  --accion de carga
									and op.id_estado = 2) --estado aceptado
				   			join (select 	id_cuenta_bancaria, 
											max(fecha_hora_descarga) as fecha_descarga
										from cuenta_bancaria_descarga
										where marca_baja = false
										group by id_cuenta_bancaria) cbd
								on (oc.id_cuenta_bancaria = cbd.id_cuenta_bancaria
									and op.fecha_hora_ultima_modificacion >= cbd.fecha_descarga)
					group by oc.id_cuenta_bancaria) cbc
			on (cb.id_cuenta_bancaria = cbc.id_cuenta_bancaria)
ORDER BY cb.id_oficina, coalesce(cbc.monto_cargas, 0), coalesce(cbc.cantidad_cargas, 0);
--SELECT * FROM v_Cuenta_Bancaria_Activa

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
	VALUES (aux_codigo_operacion, in_id_accion, in_id_cliente, aux_id_estado, false, false, now(), now(), 1)
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
		cn.nombre,
		cn.alias,
		cn.cbu,
		cn.fecha_hora_creacion,
		cn.marca_baja
FROM cuenta_bancaria cn JOIN oficina o
		ON (cn.id_oficina = o.id_oficina);
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
			   AND o.id_estado = 2)
		LEFT JOIN operacion_retiro oc
			ON (o.id_operacion = oc.id_operacion)
WHERE c.marca_baja = false
GROUP BY c.id_cliente, c.cliente_usuario, c.id_agente;
--SELECT * FROM v_Clientes_Retiros;

--DROP VIEW v_Clientes_Operaciones
CREATE OR REPLACE VIEW v_Clientes_Operaciones AS
SELECT 	cl.id_cliente,
		cl.cliente_usuario,
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
		COALESCE(opcb.nombre || '-' || opcb.alias || '-' || opcb.cbu, '')	AS carga_cuenta_bancaria
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
WHERE cl.marca_baja = false;
--select * from v_Clientes_Operaciones where id_cliente = 18 order by id_operacion desc

--DROP VIEW v_Clientes
CREATE OR REPLACE VIEW v_Clientes AS
SELECT 	cl.id_cliente,
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

select  id_registro_token,id_token,cliente_usuario,bono_carga_1,ingresos,registros,cargaron,total_cargas,total_importe,total_bono from v_Tokens_Completo_Clientes where id_agente = 1 order by cargaron desc, registros desc, ingresos desc

select * from v_Tokens

select * from operacion_carga

select * from registro_token order by 1 desc
select * from operacion order by 1 desc

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
delete from cliente where id_cliente in (34,35,36,37,38)
delete from operacion where id_cliente in (34,35,36,37,38)
delete from registro_token where id_usuario in (34,35,36,37,38) and de_agente = false
select * from cliente order by 1 desc
select * from operacion order by 1 desc
select * from registro_token order by 1 desc

SELECT substr(translate(encode(gen_random_bytes(40), 'base64'), '/+', 'ab'), 1, 40)
INTO aux_token;

--select * from cliente_sesion

select * from v_Console_Logs

select * from cliente
select * from agente
select * from plataforma
select * from oficina
select *
from v_Clientes_Operaciones where id_cliente = 1 and id_accion in (1,5) and id_estado = 2
order by fecha_hora_operacion desc
select * from cuenta_bancaria
select * from operacion order by 1 desc
select * from operacion_retiro order by 1 desc
select * from operacion_carga order by 1 desc
select * from accion
update operacion set id_estado = 2 where id_operacion = 4;
update oficina set minimo_espera_retiro = 0;
select * from estado

select * from cliente_sesion
select * from agente
select * from v_Agentes where agente_usuario = 'oficina1';
select * from cliente