DROP SCHEMA IF EXISTS CLINICA_PAZCITAS;
CREATE SCHEMA IF NOT EXISTS CLINICA_PAZCITAS;
USE CLINICA_PAZCITAS;

-- ----------------------------
-- Creación de Tablas
-- ----------------------------

CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido_paterno` varchar(50) NOT NULL,
  `apellido_materno` varchar(50) DEFAULT NULL,
  `dni` varchar(8) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `email` varchar(100) NOT NULL,
  `genero` char(1) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB;

CREATE TABLE `administrador` (
  `id_administrador` int NOT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_administrador`),
  CONSTRAINT `administrador_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB;

CREATE TABLE `sede` (
  `id_sede` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `activo` tinyint NOT NULL,
  PRIMARY KEY (`id_sede`)
) ENGINE=InnoDB;

CREATE TABLE `consultorio` (
  `id_consultorio` int NOT NULL AUTO_INCREMENT,
  `nombre_consultorio` varchar(20) NOT NULL,
  `piso` int DEFAULT NULL,
  `capacidad` int DEFAULT NULL,
  `asignado` tinyint DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  `fid_sede` int DEFAULT NULL,
  PRIMARY KEY (`id_consultorio`),
  KEY `fid_sede` (`fid_sede`),
  CONSTRAINT `consultorio_ibfk_1` FOREIGN KEY (`fid_sede`) REFERENCES `sede` (`id_sede`)
) ENGINE=InnoDB;

CREATE TABLE `cuenta_usuario` (
  `id_cuenta` int NOT NULL AUTO_INCREMENT,
  `fid_usuario` int DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `rol` enum('PACIENTE','MÉDICO','ADMINISTRADOR') NOT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_cuenta`),
  UNIQUE KEY `fid_usuario` (`fid_usuario`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `cuenta_usuario_ibfk_1` FOREIGN KEY (`fid_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB;

CREATE TABLE `especialidad` (
  `id_especialidad` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `activo` tinyint NOT NULL,
  PRIMARY KEY (`id_especialidad`)
) ENGINE=InnoDB;

CREATE TABLE `seguro` (
  `id_seguro` int NOT NULL AUTO_INCREMENT,
  `nombre_seguro` varchar(100) NOT NULL,
  `tipo` enum('NINGUNO','PARCIAL','TOTAL') DEFAULT NULL,
  `porcentaje_cobertura` decimal(10,2) NOT NULL,
  `vigencia` date DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_seguro`)
) ENGINE=InnoDB;

CREATE TABLE `paciente` (
  `id_paciente` int NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  `fid_seguro` int DEFAULT NULL,
  PRIMARY KEY (`id_paciente`),
  KEY `fid_seguro` (`fid_seguro`),
  CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `paciente_ibfk_2` FOREIGN KEY (`fid_seguro`) REFERENCES `seguro` (`id_seguro`)
) ENGINE=InnoDB;

CREATE TABLE `historial_medico` (
  `id_historial` int NOT NULL AUTO_INCREMENT,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  `fid_paciente` int DEFAULT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `fid_paciente` (`fid_paciente`),
  CONSTRAINT `historial_medico_ibfk_1` FOREIGN KEY (`fid_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB;

CREATE TABLE `turno` (
  `id_turno` int NOT NULL AUTO_INCREMENT,
  `dia` enum('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO') DEFAULT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_turno`)
) ENGINE=InnoDB;

CREATE TABLE `medico` (
  `id_medico` int NOT NULL,
  `codigo_medico` varchar(20) NOT NULL,
  `activo` tinyint DEFAULT NULL,
  `fid_sede` int DEFAULT NULL,
  `fid_consultorio` int DEFAULT NULL,
  `fid_especialidad` int DEFAULT NULL,
  PRIMARY KEY (`id_medico`),
  UNIQUE KEY `codigo_medico` (`codigo_medico`),
  KEY `fid_sede` (`fid_sede`),
  KEY `fid_consultorio` (`fid_consultorio`),
  KEY `fid_especialidad` (`fid_especialidad`),
  CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `medico_ibfk_2` FOREIGN KEY (`fid_sede`) REFERENCES `sede` (`id_sede`),
  CONSTRAINT `medico_ibfk_3` FOREIGN KEY (`fid_consultorio`) REFERENCES `consultorio` (`id_consultorio`),
  CONSTRAINT `medico_ibfk_4` FOREIGN KEY (`fid_especialidad`) REFERENCES `especialidad` (`id_especialidad`)
) ENGINE=InnoDB;

CREATE TABLE `horario_trabajo` (
  `id_horario_trabajo` int NOT NULL AUTO_INCREMENT,
  `fid_medico` int DEFAULT NULL,
  `fid_turno` int DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_horario_trabajo`),
  KEY `fid_medico` (`fid_medico`),
  KEY `fid_turno` (`fid_turno`),
  CONSTRAINT `horario_trabajo_ibfk_1` FOREIGN KEY (`fid_medico`) REFERENCES `medico` (`id_medico`),
  CONSTRAINT `horario_trabajo_ibfk_2` FOREIGN KEY (`fid_turno`) REFERENCES `turno` (`id_turno`)
) ENGINE=InnoDB;

CREATE TABLE `cita` (
  `id_cita` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `estado_cita` enum('PROGRAMADA','CANCELADA','ATENDIDA') DEFAULT NULL,
  `estado_atencion` enum('EN_ESPERA','EN_CONSULTORIO','ATENDIDO') DEFAULT NULL,
  `motivo_consulta` varchar(100) DEFAULT NULL,
  `fid_paciente` int DEFAULT NULL,
  `fid_horario_trabajo` int DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_cita`),
  KEY `fid_paciente` (`fid_paciente`),
  KEY `fid_horario_trabajo` (`fid_horario_trabajo`),
  CONSTRAINT `cita_ibfk_1` FOREIGN KEY (`fid_paciente`) REFERENCES `paciente` (`id_paciente`),
  CONSTRAINT `cita_ibfk_2` FOREIGN KEY (`fid_horario_trabajo`) REFERENCES `horario_trabajo` (`id_horario_trabajo`)
) ENGINE=InnoDB;

CREATE TABLE `medicamento` (
  `id_medicamento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `presentacion` varchar(100) NOT NULL,
  `stock` int NOT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_medicamento`)
) ENGINE=InnoDB;

CREATE TABLE `receta` (
  `id_receta` int NOT NULL AUTO_INCREMENT,
  `fecha_prescripcion` date DEFAULT NULL,
  `indicaciones` varchar(100) DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_receta`)
) ENGINE=InnoDB;

CREATE TABLE `nota_clinica` (
  `id_nota` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(120) DEFAULT NULL,
  `diagnostico` varchar(120) DEFAULT NULL,
  `observaciones` varchar(120) DEFAULT NULL,
  `fid_cita` int DEFAULT NULL,
  `fid_receta` int DEFAULT NULL,
  `fid_historial` int DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_nota`),
  KEY `fid_cita` (`fid_cita`),
  KEY `fid_receta` (`fid_receta`),
  KEY `fid_historial` (`fid_historial`),
  CONSTRAINT `nota_clinica_ibfk_1` FOREIGN KEY (`fid_cita`) REFERENCES `cita` (`id_cita`),
  CONSTRAINT `nota_clinica_ibfk_2` FOREIGN KEY (`fid_receta`) REFERENCES `receta` (`id_receta`),
  CONSTRAINT `nota_clinica_ibfk_3` FOREIGN KEY (`fid_historial`) REFERENCES `historial_medico` (`id_historial`)
) ENGINE=InnoDB;

CREATE TABLE `pago` (
  `id_pago` int NOT NULL AUTO_INCREMENT,
  `fecha_pago` datetime NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `monto_cubierto_seguro` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `estado` enum('PENDIENTE','CANCELADO','VENCIDO') DEFAULT NULL,
  `fid_seguro` int DEFAULT NULL,
  `fid_cita` int DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `fid_seguro` (`fid_seguro`),
  KEY `fid_cita` (`fid_cita`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`fid_seguro`) REFERENCES `seguro` (`id_seguro`),
  CONSTRAINT `pago_ibfk_2` FOREIGN KEY (`fid_cita`) REFERENCES `cita` (`id_cita`)
) ENGINE=InnoDB;

CREATE TABLE `receta_medicamento` (
  `id_receta_medicamento` int NOT NULL AUTO_INCREMENT,
  `fid_receta` int DEFAULT NULL,
  `fid_medicamento` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_receta_medicamento`),
  KEY `fid_receta` (`fid_receta`),
  KEY `fid_medicamento` (`fid_medicamento`),
  CONSTRAINT `receta_medicamento_ibfk_1` FOREIGN KEY (`fid_receta`) REFERENCES `receta` (`id_receta`),
  CONSTRAINT `receta_medicamento_ibfk_2` FOREIGN KEY (`fid_medicamento`) REFERENCES `medicamento` (`id_medicamento`)
) ENGINE=InnoDB;

CREATE TABLE `sede_especialidad` (
  `id_sede_especialidad` int NOT NULL AUTO_INCREMENT,
  `fid_sede` int DEFAULT NULL,
  `fid_especialidad` int DEFAULT NULL,
  `activo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_sede_especialidad`),
  KEY `fid_sede` (`fid_sede`),
  KEY `fid_especialidad` (`fid_especialidad`),
  CONSTRAINT `sede_especialidad_ibfk_1` FOREIGN KEY (`fid_sede`) REFERENCES `sede` (`id_sede`),
  CONSTRAINT `sede_especialidad_ibfk_2` FOREIGN KEY (`fid_especialidad`) REFERENCES `especialidad` (`id_especialidad`)
) ENGINE=InnoDB;


-- ----------------------------
-- Creación de Procedimientos
-- ----------------------------

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_ADMINISTRADOR`(
	IN _id_administrador INT
)
BEGIN
	UPDATE administrador SET activo = 0 WHERE id_administrador = _id_administrador;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_CITA`(
    IN _id_cita INT
)
BEGIN
    UPDATE cita SET estado_cita = 'CANCELADA' WHERE id_cita = _id_cita;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_CONSULTORIO`(
    IN _id_consultorio INT
)
BEGIN
    UPDATE consultorio SET activo = 0 WHERE id_consultorio = _id_consultorio;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_ESPECIALIDAD`(
    IN _id_especialidad INT
)
BEGIN
    UPDATE especialidad SET activo = 0 WHERE id_especialidad = _id_especialidad;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_HISTORIAL`(
	IN _id_historial INT
)
BEGIN
	UPDATE historial_medico
    SET activo = 0
    WHERE id_historial = _id_historial;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_HORARIO`(
	in _id_horario_trabajo int
)
begin
	update horario_trabajo set activo = 0 where id_horario_trabajo = _id_horario_trabajo;
end ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_MEDICAMENTO`(
	IN _id_medicamento int
)
BEGIN
	UPDATE medicamento set activo = 0 where id_medicamento = _id_medicamento;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_MEDICO`(
	IN _id_medico INT
)
BEGIN
	UPDATE medico SET activo = 0 WHERE id_medico = _id_medico;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_PACIENTE`(
	IN _id_paciente INT
)
BEGIN
	UPDATE paciente SET activo = 0 WHERE id_paciente = _id_paciente;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_PAGO`(
	IN _id_pago INT
)
BEGIN
	UPDATE pago SET activo = 0 WHERE id_pago = _id_pago;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_SEDE`(
    IN _id_sede INT
)
BEGIN
    UPDATE sede SET activo = 0 WHERE id_sede = _id_sede;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_SEDE_ESPECIALIDAD`(
	in _id_sede_especialidad INT
)
BEGIN
	update sede_especialidad set activo = 0 where id_sede_especialidad = _id_sede_especialidad;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_SEDE_ESPECIALIDAD_X_SEDE`(
	in _id_sede INT
)
BEGIN
	DELETE FROM sede_especialidad WHERE fid_sede = _id_sede;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `ELIMINAR_SEGURO`(
	IN _id_seguro INT
)
BEGIN
	UPDATE seguro SET activo = 0 WHERE id_seguro = _id_seguro;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_ADMINISTRADOR`(
	OUT _id_administrador int,
    in _nombre varchar(75),
    in _apellido_paterno varchar(75),
    in _apellido_materno varchar(75),
    in _dni varchar(10),
    in _email varchar(30),
    in _fecha_nacimiento date,
    in _genero char
)
BEGIN
	INSERT INTO usuario(nombre,apellido_paterno,apellido_materno, dni, email, fecha_nacimiento, genero)
    VALUES(_nombre,_apellido_paterno,_apellido_materno,_dni, _email, _fecha_nacimiento, _genero);
    SET _id_administrador = @@last_insert_id;
    INSERT INTO administrador(id_administrador,activo) VALUES(_id_administrador,1);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_CITA`(
	OUT _id_cita INT,
    in _fecha date,
    IN _motivo_consulta VARCHAR(100),
    IN _fid_paciente INT,
    IN _fid_horario INT
)
BEGIN
	INSERT INTO cita( fecha,estado_cita,estado_atencion, motivo_consulta,fid_paciente,fid_horario_trabajo, activo)
    VALUES(_fecha, 'PROGRAMADA','EN_ESPERA', _motivo_consulta,_fid_paciente,_fid_horario, 1);
    SET _id_cita = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_CONSULTORIO`(
    OUT _id_consultorio INT,
    IN _nombre_consultorio VARCHAR(100),
    IN _piso INT,
    IN _capacidad INT,
    IN _fid_sede INT
)
BEGIN
    INSERT INTO consultorio(nombre_consultorio, piso, capacidad, asignado, activo, fid_sede)
    VALUES(_nombre_consultorio, _piso, _capacidad,0,1, _fid_sede);
    SET _id_consultorio = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_CUENTA`(
	OUT _id_cuenta int,
    in _username varchar(75),
    in _password varchar(75),
    in _rol enum('PACIENTE', 'MÉDICO', 'ADMINISTRADOR'),
    in _fid_usuario int
)
BEGIN
	INSERT INTO cuenta_usuario(username,password,rol, fid_usuario,activo)
    VALUES(_username, MD5(_password), _rol, _fid_usuario,1);
    SET _id_cuenta = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_ESPECIALIDAD`(
    OUT _id_especialidad INT,
    IN _nombre VARCHAR(100),
    IN _descripcion VARCHAR(100)
)
BEGIN
    INSERT INTO especialidad(nombre, descripcion, activo)
    VALUES(_nombre, _descripcion, 1);
    SET _id_especialidad = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_HISTORIAL_MEDICO`(
	OUT _id_historial INT,
    IN _fid_paciente INT
)
BEGIN
	INSERT INTO historial_medico(fecha_actualizacion,activo,fid_paciente)
    VALUES(SYSDATE(),1,_fid_paciente);
    SET _id_historial = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_HORARIO`(
	OUT _id_horario_trabajo INT,
    IN _fid_medico int,
    IN _fid_turno int
)
BEGIN
	INSERT INTO horario_trabajo(fid_medico,fid_turno, activo)
    VALUES (_fid_medico,_fid_turno, 1);
    SET _id_horario_trabajo = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_MEDICAMENTO`(
	OUT _id_medicamento INT,
    IN _nombre VARCHAR(100),
    IN _presentacion VARCHAR(100),
    IN _stock INT
)
BEGIN
	INSERT INTO medicamento(nombre,presentacion,stock,activo)
    VALUES (_nombre, _presentacion, _stock,1);
    SET _id_medicamento = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_MEDICO`(
	OUT _id_medico int,
    in _nombre varchar(75),
    in _apellido_paterno varchar(75),
    in _apellido_materno varchar(75),
    in _dni varchar(10),
    in _email varchar(45),
    in _fecha_nacimiento date,
    in _genero char,
    in _codigo_medico varchar(15),
    in _fid_sede int,
    in _fid_consultorio int,
    in _fid_especialidad int
)
BEGIN
	INSERT INTO usuario(nombre,apellido_paterno,apellido_materno, dni, email, fecha_nacimiento, genero)
    VALUES(_nombre,_apellido_paterno,_apellido_materno,_dni, _email, _fecha_nacimiento, _genero);
    SET _id_medico = @@last_insert_id;
    INSERT INTO medico(id_medico,codigo_medico,activo,fid_sede, fid_consultorio, fid_especialidad)
    VALUES(_id_medico,_codigo_medico,1,_fid_sede,_fid_consultorio,_fid_especialidad);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_NOTA_CLINICA`(
	OUT _id_nota INT,
    IN _descripcion VARCHAR(120),
    IN _diagnostico VARCHAR(120),
    IN _observaciones VARCHAR(120),
    IN _fid_cita INT,
    IN _fid_receta INT,
    IN _fid_historial INT
)
BEGIN
	INSERT INTO nota_clinica(descripcion,diagnostico,observaciones,fid_cita,fid_receta,fid_historial, activo)
    VALUES(_descripcion,_diagnostico,_observaciones,_fid_cita,_fid_receta,_fid_historial, 1);
    SET _id_nota = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_PACIENTE`(
	OUT _id_paciente int,
    in _nombre varchar(75),
    in _apellido_paterno varchar(75),
    in _apellido_materno varchar(75),
    in _dni varchar(10),
    in _email varchar(30),
    in _fecha_nacimiento date,
    in _genero char,
    in _direccion varchar(30),
    in _telefono varchar(20),
    in _fid_seguro int
)
BEGIN
	INSERT INTO usuario(nombre,apellido_paterno,apellido_materno, dni, email, fecha_nacimiento, genero)
    VALUES(_nombre,_apellido_paterno,_apellido_materno,_dni, _email, _fecha_nacimiento, _genero);
    SET _id_paciente = @@last_insert_id;
    INSERT INTO paciente(id_paciente,direccion,telefono,activo,fid_seguro)
    VALUES(_id_paciente,_direccion,_telefono,1,_fid_seguro);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_PAGO`(
	OUT _id_pago INT,
	IN _fecha_pago datetime,
	IN _monto_total decimal(10,2),
	IN _monto_cubierto_seguro decimal(10,2),
    IN _subtotal decimal(10,2),
	in _estado ENUM('PENDIENTE','CANCELADO','VENCIDO'),
	IN _fid_seguro INT,
    in _fid_cita int
)
BEGIN
	INSERT INTO pago(fecha_pago,monto_total,monto_cubierto_seguro,subtotal,estado,fid_seguro,fid_cita,activo)
	VALUES (_fecha_pago,_monto_total,_monto_cubierto_seguro,_subtotal,_estado,_fid_seguro,_fid_cita,1);
	SET _id_pago=@@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_RECETA`(
	OUT _id_receta INT,
    IN _indicaciones VARCHAR(100)
)
BEGIN
	INSERT INTO receta(fecha_prescripcion,indicaciones, activo)
    VALUES (SYSDATE(),_indicaciones, 1);
    SET _id_receta = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_RECETA_MEDICAMENTO`(
	OUT _id_receta_medicamento int,
    in _fid_receta int,
    in _fid_medicamento int,
    in _cantidad int
)
BEGIN
	INSERT INTO receta_medicamento(fid_receta, fid_medicamento, cantidad, activo)
    VALUES(_fid_receta, _fid_medicamento, _cantidad, 1);
    SET _id_receta_medicamento = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_SEDE`(
    OUT _id_sede INT,
    IN _nombre VARCHAR(100),
    IN _direccion VARCHAR(255)
)
BEGIN
    INSERT INTO sede(nombre, direccion, activo)
    VALUES(_nombre, _direccion, 1);
    SET _id_sede = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_SEDE_ESPECIALIDAD`(
	out _id_sede_especialidad INT,
    in _fid_sede INT,
    in _fid_especialidad INT
)
BEGIN
	insert into sede_especialidad(fid_sede, fid_especialidad,activo) values(_fid_sede, _fid_especialidad, 1);
    SET _id_sede_especialidad = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_SEGURO`(
	OUT _id_seguro INT,
	IN _nombre_seguro VARCHAR(100),
	IN _tipo ENUM('TOTAL','PARCIAL','NINGUNO'),
	IN _porcentaje_cobertura decimal(10,2),
    in _vigencia date
)
BEGIN
	INSERT INTO seguro(nombre_seguro,tipo,porcentaje_cobertura,vigencia,activo)
	VALUES (_nombre_seguro,_tipo,_porcentaje_cobertura,_vigencia, 1);
	SET _id_seguro = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `INSERTAR_TURNO`(
	OUT _id_turno INT,
    IN _dia ENUM('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO'),
    IN _hora_inicio TIME,
    IN _hora_fin TIME
)
BEGIN
	INSERT INTO turno(dia,hora_inicio,hora_fin,activo)
    VALUES (_dia,_hora_inicio,_hora_fin,1);
    SET _id_turno = @@last_insert_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_ADMINISTRADOR_TODOS`()
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero
	FROM administrador a INNER JOIN usuario u ON a.id_administrador = u.id_usuario WHERE a.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_CITA_TODOS`()
BEGIN
    SELECT c.id_cita, c.fecha, c.estado_cita, c.estado_atencion, c.motivo_consulta,
    c.fid_paciente, u.nombre, u.apellido_paterno, u.apellido_materno, u.dni, u.fecha_nacimiento,
    u.email, u.genero, p.direccion, p.telefono, h.id_horario_trabajo,h.fid_medico, h.fid_turno
    FROM cita c inner join paciente p on c.fid_paciente = p.id_paciente inner join usuario u on u.id_usuario = p.id_paciente inner join
    horario_trabajo h on c.fid_horario_trabajo = h.id_horario_trabajo where c.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_CITA_X_MEDICO`(
	IN _id_medico int
)
BEGIN
    SELECT c.id_cita, c.fecha, c.estado_cita, c.estado_atencion, c.motivo_consulta,
    c.fid_paciente, u.nombre, u.apellido_paterno, u.apellido_materno, u.dni, u.fecha_nacimiento,
    u.email, u.genero, p.direccion, p.telefono, h.id_horario_trabajo,h.fid_medico, h.fid_turno
    FROM cita c inner join paciente p on c.fid_paciente = p.id_paciente inner join usuario u on u.id_usuario = p.id_paciente inner join
    horario_trabajo h on c.fid_horario_trabajo = h.id_horario_trabajo where c.activo = 1 and h.fid_medico = _id_medico
    ORDER BY c.fecha;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_CITA_X_MEDICO_X_FECHA`(
    IN _id_medico INT,
    IN _fecha_inicio DATE,
    IN _fecha_fin DATE
)
BEGIN
    SELECT
        c.id_cita,
        c.fecha,
        c.estado_cita,
        c.estado_atencion,
        c.motivo_consulta,
        c.fid_paciente,
        u.nombre,
        u.apellido_paterno,
        u.apellido_materno,
        u.dni,
        u.fecha_nacimiento,
        u.email,
        u.genero,
        p.direccion,
        p.telefono,
        h.id_horario_trabajo,
        h.fid_medico,
        h.fid_turno
    FROM cita c
    INNER JOIN paciente p ON c.fid_paciente = p.id_paciente
    INNER JOIN usuario u ON u.id_usuario = p.id_paciente
    INNER JOIN horario_trabajo h ON c.fid_horario_trabajo = h.id_horario_trabajo
    WHERE c.activo = 1
      AND h.fid_medico = _id_medico
      AND c.fecha BETWEEN _fecha_inicio AND _fecha_fin
    ORDER BY c.fecha;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_CITA_X_PACIENTE`(
    IN _id_paciente INT
)
BEGIN
    SELECT c.id_cita, c.fecha, c.estado_cita, c.estado_atencion, c.motivo_consulta,
    c.fid_paciente, u.nombre, u.apellido_paterno, u.apellido_materno, u.dni, u.fecha_nacimiento,
    u.email, u.genero, p.direccion, p.telefono, h.id_horario_trabajo, h.fid_medico, h.fid_turno
    FROM cita c inner join paciente p on c.fid_paciente = p.id_paciente inner join usuario u on u.id_usuario = p.id_paciente inner join
    horario_trabajo h on c.fid_horario_trabajo = h.id_horario_trabajo where c.activo = 1 and c.fid_paciente=_id_paciente;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_CITA_X_PACIENTE_COMPLETO_SIN_PACIENTE`(
    IN _id_paciente INT
)
BEGIN
    SELECT
        c.id_cita,
        c.fecha,
        c.estado_cita,
        c.estado_atencion,
        c.motivo_consulta,

        um.id_usuario AS id_medico_usuario,
        m.codigo_medico,
        um.nombre AS nombre_medico,
        um.apellido_paterno AS apellido_paterno_medico,
        um.apellido_materno AS apellido_materno_medico,
        um.dni AS dni_medico,
        um.email AS email_medico,
        um.genero AS genero_medico,

        h.id_horario_trabajo,

        e.id_especialidad,
        e.nombre AS nombre_especialidad,
        e.descripcion AS descripcion_especialidad,

        s.id_sede,
        s.nombre AS nombre_sede,
        s.direccion AS direccion_sede,

        con.id_consultorio,
        con.nombre_consultorio,
        con.piso,
        con.capacidad,

        t.id_turno,
        t.dia,
        t.hora_inicio,
        t.hora_fin

    FROM cita c
    INNER JOIN horario_trabajo h ON c.fid_horario_trabajo = h.id_horario_trabajo
    INNER JOIN medico m ON h.fid_medico = m.id_medico
    INNER JOIN usuario um ON um.id_usuario = m.id_medico
    INNER JOIN sede s ON m.fid_sede = s.id_sede
    INNER JOIN consultorio con ON m.fid_consultorio = con.id_consultorio
    INNER JOIN especialidad e ON m.fid_especialidad = e.id_especialidad
    INNER JOIN turno t ON h.fid_turno = t.id_turno

    WHERE c.activo = 1
      AND c.fid_paciente = _id_paciente
    ORDER BY c.fecha DESC;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_CONSULTORIOS_TODOS`()
BEGIN
    SELECT id_consultorio, nombre_consultorio, piso, capacidad, asignado, fid_sede,
    s.nombre, s.direccion FROM consultorio c
    inner join sede s on s.id_sede = c.fid_sede where c.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_CONSULTORIOS_X_SEDE`(
	IN _id_sede INT
)
BEGIN
    SELECT id_consultorio, nombre_consultorio, piso, capacidad, asignado
    FROM consultorio c
    inner join sede s
    on s.id_sede = c.fid_sede
    where s.id_sede = _id_sede  and c.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_DETALLE_RECETA`()
BEGIN
    SELECT r.id_receta, r.fecha_prescripcion, r.indicaciones,
       rm.id_medicamento, m.nombre AS medicamento, rm.cantidad
	FROM receta r
	INNER JOIN receta_medicamento rm ON r.id_receta = rm.id_receta
	INNER JOIN medicamento m ON rm.id_medicamento = m.id_medicamento;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_ESPECIALIDAD_TODOS`()
BEGIN
    SELECT id_especialidad, nombre, descripcion
    FROM especialidad WHERE activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_ESPECIALIDAD_X_SEDE`(
    IN _id_sede INT
)
BEGIN
    SELECT e.id_especialidad, e.nombre, e.descripcion
    FROM sede_especialidad se
    INNER JOIN especialidad e ON se.fid_especialidad = e.id_especialidad
    INNER JOIN sede s ON se.fid_sede = s.id_sede
    WHERE se.fid_sede = _id_sede AND s.activo = 1 AND e.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_HISTORIALES_TODOS`()
BEGIN
	SELECT
    h.id_historial, h.fecha_actualizacion, p.id_paciente,
    u.nombre, u.apellido_paterno, u.apellido_materno, u.dni
    FROM historial_medico h
    INNER JOIN paciente p ON h.fid_paciente = p.id_paciente
    INNER JOIN usuario u ON p.id_paciente = u.id_usuario
    WHERE h.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_HORARIO_TODOS`()
BEGIN
	SELECT h.id_horario_trabajo, h.fid_turno, t.dia, t.hora_inicio, t.hora_fin ,h.fid_medico
    FROM horario_trabajo h inner join turno t on h.fid_turno = t.id_turno WHERE h.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_HORARIO_X_MEDICO`(
    IN _id_medico INT
)
BEGIN
    SELECT h.id_horario_trabajo, h.fid_turno, t.dia, t.hora_inicio, t.hora_fin ,h.fid_medico
    FROM horario_trabajo h inner join turno t on h.fid_turno = t.id_turno WHERE h.fid_medico = _id_medico;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_LINEAS_X_RECETA`(
	IN _fid_receta int
)
BEGIN
	select id_receta_medicamento, fid_medicamento, nombre, presentacion, cantidad
	from receta_medicamento r inner join medicamento m on r.fid_medicamento = m.id_medicamento
	where r.fid_receta = _fid_receta;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_MEDICAMENTOS_TODOS`()
BEGIN
	SELECT
		id_medicamento, nombre, presentacion, stock
    FROM medicamento where activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_MEDICAMENTOS_X_NOMBRE`(
	in _nombre varchar(40)
)
BEGIN
	SELECT
		id_medicamento, nombre, presentacion, stock
    FROM medicamento where activo = 1 AND nombre LIKE CONCAT('%',_nombre,'%');
end ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_MEDICOS_CON_NUMERO_CITAS`(
	IN _id_especialidad int,
    in _id_sede int
)
BEGIN
select u.nombre as nombre_medico, count(*) from cita c inner join horario_trabajo h on c.fid_horario_trabajo = h.id_horario_trabajo inner join medico m on m.id_medico = h.fid_medico
inner join usuario u on u.id_usuario = m.id_medico  and m.fid_especialidad = _id_especialidad and m.fid_sede = _id_sede;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_MEDICOS_X_SEDE_X_ESP`(
	IN _id_sede INT,
    IN _id_especialidad INT
)
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero,
    m.codigo_medico, s.id_sede, s.nombre as nombre_sede, s.direccion, c.id_consultorio, c.nombre_consultorio,
    c.piso, c.capacidad, c.asignado, e.id_especialidad, e.nombre as nombre_especialidad, e.descripcion FROM medico m
    INNER JOIN usuario u ON m.id_medico = u.id_usuario
    INNER JOIN sede s ON s.id_sede = m.fid_sede
    INNER JOIN consultorio c on m.fid_consultorio = c.id_consultorio
    inner join especialidad e on m.fid_especialidad = e.id_especialidad
    WHERE m.activo = 1 and m.fid_sede = _id_sede and m.fid_especialidad = _id_especialidad;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_MEDICO_TODOS`()
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero,
    m.codigo_medico, s.id_sede, s.nombre as nombre_sede, s.direccion, c.id_consultorio, c.nombre_consultorio,
    c.piso, c.capacidad, c.asignado, e.id_especialidad, e.nombre as nombre_especialidad, e.descripcion FROM medico m
    INNER JOIN usuario u ON m.id_medico = u.id_usuario INNER JOIN sede s ON s.id_sede = m.fid_sede INNER JOIN consultorio c on m.fid_consultorio = c.id_consultorio
    inner join especialidad e on m.fid_especialidad = e.id_especialidad WHERE m.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_NOTAS_CLINICAS_TODOS`()
BEGIN
	SELECT
        nc.id_nota,
        nc.descripcion,
        nc.diagnostico,
        nc.observaciones,
        nc.fid_cita AS id_cita,
        nc.fid_receta AS id_receta,
        nc.fid_historial AS id_historial
    FROM
        nota_clinica nc;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_NOTAS_CLINICAS_X_HISTORIAL`(
	IN _id_historial int
)
BEGIN
	SELECT
        nc.id_nota,
        nc.descripcion,
        nc.diagnostico,
        nc.observaciones,
        nc.fid_cita AS id_cita,
        nc.fid_receta AS id_receta,
        nc.fid_historial AS id_historial
    FROM
        nota_clinica nc where _id_historial = fid_historial;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_PACIENTE_TODOS`()
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero,
    p.direccion, p.telefono, seg.id_seguro, seg.nombre_seguro,
    seg.tipo, seg.porcentaje_cobertura, seg.vigencia FROM paciente p INNER JOIN usuario u ON p.id_paciente = u.id_usuario
	inner join seguro seg on seg.id_seguro = p.fid_seguro WHERE p.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_SEDES_TODOS`()
BEGIN
    SELECT id_sede, nombre, direccion
    FROM sede where activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_SEDES_X_ESPECIALIDAD`(
	IN _id_sede int
)
begin
	select fid_especialidad, nombre as nombre_especialidad from sede_especialidad se inner join especialidad e on se.fid_especialidad = e.id_especialidad where se.fid_sede = _id_sede and se.activo = 1;
end ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_SEDE_X_ESPECIALIDAD`(
    IN _id_especialidad INT
)
BEGIN
    SELECT s.id_sede, s.nombre, s.direccion
    FROM sede_especialidad se
    INNER JOIN sede s ON se.fid_sede = s.id_sede
    INNER JOIN especialidad e ON se.fid_especialidad = e.id_especialidad
    WHERE se.fid_especialidad = _id_especialidad AND s.activo = 1 AND e.activo = 1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_SOLO_RECETAS`()
BEGIN
    SELECT id_receta, fecha_prescripcion, indicaciones
    FROM receta;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_TODOS_PAGO`()
BEGIN
	SELECT p.id_pago,p.fecha_pago,p.monto_total,p.monto_cubierto_seguro,p.subtotal,p.estado,
    p.fid_seguro, s.nombre_seguro, s.tipo, s.porcentaje_cobertura, s.vigencia , p.fid_cita
	FROM pago p INNER JOIN seguro s ON p.fid_seguro = s.id_seguro
	WHERE s.activo=1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_TODOS_SEGURO`()
BEGIN
	SELECT s.id_seguro,s.nombre_seguro,s.tipo,s.porcentaje_cobertura, s.vigencia
	FROM seguro s
	WHERE s.activo=1;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_TURNOS_SEMANA`(
    IN p_id_medico INT,
    IN p_fecha_inicio DATE
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE dias_restantes INT;
    DECLARE dia_actual DATE;
    DECLARE dia_semana VARCHAR(20);

    DROP TEMPORARY TABLE IF EXISTS turnos_disponibles;

    CREATE TEMPORARY TABLE turnos_disponibles (
        fecha DATE,
        id_horario_trabajo INT,
        dia VARCHAR(20),
        hora_inicio TIME,
        hora_fin TIME
    );

    SET dias_restantes = 7 - DAYOFWEEK(p_fecha_inicio);
    IF dias_restantes = 6 THEN
        SET dias_restantes = 0;
    ELSE
        SET dias_restantes = dias_restantes + 1;
    END IF;

    WHILE i <= dias_restantes DO
        SET dia_actual = DATE_ADD(p_fecha_inicio, INTERVAL i DAY);

        SET dia_semana = CASE DAYOFWEEK(dia_actual)
            WHEN 1 THEN 'DOMINGO'
            WHEN 2 THEN 'LUNES'
            WHEN 3 THEN 'MARTES'
            WHEN 4 THEN 'MIERCOLES'
            WHEN 5 THEN 'JUEVES'
            WHEN 6 THEN 'VIERNES'
            WHEN 7 THEN 'SABADO'
        END;

        INSERT INTO turnos_disponibles (fecha, id_horario_trabajo, dia, hora_inicio, hora_fin)
        SELECT
            dia_actual,
            ht.id_horario_trabajo,
            t.dia,
            t.hora_inicio,
            t.hora_fin
        FROM horario_trabajo ht
		INNER JOIN turno t ON ht.fid_turno = t.id_turno
        WHERE ht.fid_medico = p_id_medico
          AND ht.activo = 1
          AND t.activo = 1
          AND t.dia = dia_semana
          AND NOT EXISTS (
              SELECT 1
              FROM cita c
              WHERE c.fid_horario_trabajo = ht.id_horario_trabajo
                AND c.fecha = dia_actual
                AND c.activo = 1
                AND c.estado_cita <> 'CANCELADA'
          );

        SET i = i + 1;
    END WHILE;

    SELECT * FROM turnos_disponibles ORDER BY fecha, hora_inicio;

    DROP TEMPORARY TABLE IF EXISTS turnos_disponibles;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `LISTAR_TURNO_TODOS`()
BEGIN
	SELECT
        t.id_turno,
        t.dia,
        t.hora_inicio,
        t.hora_fin
    FROM turno t;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MARCAR_CONSULTORIO_ASIGNADO`(
	IN _id_consultorio INT
)
BEGIN
	UPDATE consultorio
	SET asignado=1
    WHERE id_consultorio = _id_consultorio;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MARCAR_CONSULTORIO_NO_ASIGNADO`(
	IN _id_consultorio INT
)
BEGIN
	UPDATE consultorio
	SET asignado=0
    WHERE id_consultorio = _id_consultorio;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_ADMINISTRADOR`(
	in _id_administrador int,
    in _nombre varchar(75),
    in _apellido_paterno varchar(75),
    in _apellido_materno varchar(75),
    in _dni varchar(10),
    in _email varchar(30),
    in _fecha_nacimiento date,
    in _genero char
)
BEGIN
	UPDATE usuario SET nombre = _nombre, apellido_paterno = _apellido_paterno, apellido_materno = _apellido_materno, dni = _dni,
    email = _email, fecha_nacimiento = _fecha_nacimiento, genero = _genero WHERE id_usuario = _id_administrador;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_CITA`(
    IN _id_cita INT,
    IN _estado_cita ENUM('PROGRAMADA','CANCELADA','ATENDIDA'),
    in _estado_atencion ENUM('ATENDIDO','EN_ESPERA','EN_CONSULTORIO'),
    IN _motivo_consulta VARCHAR(50)
)
BEGIN
    UPDATE cita SET estado_cita = _estado_cita, estado_atencion = _estado_atencion,
    motivo_consulta = _motivo_consulta WHERE id_cita = _id_cita;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_CONSULTORIO`(
    IN _id_consultorio INT,
    IN _nombre_consultorio VARCHAR(100),
    IN _piso INT,
    IN _capacidad INT,
    IN _fid_sede INT
)
BEGIN
    UPDATE consultorio SET nombre_consultorio = _nombre_consultorio, piso = _piso, capacidad = _capacidad,fid_sede = _fid_sede
    WHERE id_consultorio = _id_consultorio;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_ESPECIALIDAD`(
    IN _id_especialidad INT,
    IN _nombre VARCHAR(100),
    IN _descripcion VARCHAR(100)
)
BEGIN
    UPDATE especialidad SET nombre = _nombre, descripcion = _descripcion
    WHERE id_especialidad = _id_especialidad;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_FECHA_CITA`(
    IN _id_cita INT,
    IN _id_turno INT,
    IN _id_medico INT
)
BEGIN
    DECLARE _id_horario INT;

    SELECT h.id_horario_trabajo
    INTO _id_horario
    FROM horario_trabajo h
    WHERE h.fid_turno = _id_turno
      AND h.fid_medico = _id_medico
      AND h.activo = 1
    LIMIT 1;

    UPDATE cita
    SET fid_horario_trabajo = _id_horario
    WHERE id_cita = _id_cita;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_FECHA_CITA_POR_FECHA_Y_HORA`(
    IN _id_cita INT,
    IN _fecha DATE,
    IN _hora TIME,
    IN _id_medico INT
)
BEGIN
    DECLARE _dia_enum ENUM('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO');
    DECLARE _id_turno INT;
    DECLARE _id_horario INT;

    SET _dia_enum = CASE DAYOFWEEK(_fecha)
        WHEN 1 THEN 'DOMINGO'
        WHEN 2 THEN 'LUNES'
        WHEN 3 THEN 'MARTES'
        WHEN 4 THEN 'MIERCOLES'
        WHEN 5 THEN 'JUEVES'
        WHEN 6 THEN 'VIERNES'
        WHEN 7 THEN 'SABADO'
    END;

    SELECT t.id_turno
    INTO _id_turno
    FROM turno t
    WHERE t.dia = _dia_enum
      AND t.hora_inicio <= _hora AND _hora < t.hora_fin
      AND t.activo = 1
    LIMIT 1;

    SELECT h.id_horario_trabajo
    INTO _id_horario
    FROM horario_trabajo h
    WHERE h.fid_turno = _id_turno
      AND h.fid_medico = _id_medico
      AND h.activo = 1
    LIMIT 1;

    UPDATE cita
    SET
        fid_horario_trabajo = _id_horario,
        fecha = _fecha
    WHERE id_cita = _id_cita;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_HORARIO`(
	IN _id_horario_trabajo INT,
    IN _fid_medico int,
    IN _fid_turno int
)
BEGIN
	UPDATE horario_trabajo
    SET fid_medico = _fid_medico, fid_turno = _fid_turno
    WHERE id_horario_trabajo = _id_horario_trabajo;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_MEDICAMENTO`(
	IN _id_medicamento INT,
    IN _nombre VARCHAR(100),
    IN _presentacion VARCHAR(100),
    IN _stock INT
)
BEGIN
	UPDATE medicamento
    SET nombre = _nombre, presentacion = _presentacion, stock = _stock
	WHERE id_medicamento = _id_medicamento;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_MEDICO`(
	in _id_medico int,
    in _nombre varchar(75),
    in _apellido_paterno varchar(75),
    in _apellido_materno varchar(75),
    in _dni varchar(10),
    in _email varchar(30),
    in _fecha_nacimiento date,
    in _genero char,
    in _codigo_medico varchar(15),
    in _fid_sede int,
    in _fid_consultorio int,
    in _fid_especialidad int
)
BEGIN
	UPDATE usuario SET nombre = _nombre, apellido_paterno = _apellido_paterno, apellido_materno = _apellido_materno, dni = _dni,
    email = _email, fecha_nacimiento = _fecha_nacimiento, genero = _genero WHERE id_usuario = _id_medico;
    update medico set codigo_medico = _codigo_medico, fid_sede = _fid_sede,
    fid_consultorio = _fid_consultorio, fid_especialidad = _fid_especialidad WHERE id_medico = _id_medico;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_NOTA_CLINICA`(
	IN _id_nota INT,
    IN _descripcion VARCHAR(120),
    IN _diagnostico VARCHAR(120),
    IN _observaciones VARCHAR(120)
)
BEGIN
	UPDATE nota_clinica
    SET descripcion = _descripcion,
    diagnostico = _diagnostico,
    observaciones = _observaciones
    WHERE id_nota = _id_nota;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_PACIENTE`(
	in _id_paciente int,
    in _nombre varchar(75),
    in _apellido_paterno varchar(75),
    in _apellido_materno varchar(75),
    in _dni varchar(10),
    in _email varchar(30),
    in _fecha_nacimiento date,
    in _genero char,
    in _direccion varchar(30),
    in _telefono varchar(20),
    in _fid_seguro int
)
BEGIN
	UPDATE usuario SET nombre = _nombre, apellido_paterno = _apellido_paterno, apellido_materno = _apellido_materno, dni = _dni,
    email = _email, fecha_nacimiento = _fecha_nacimiento, genero = _genero WHERE id_usuario = _id_paciente;
    update paciente set direccion = _direccion, telefono = _telefono, fid_seguro = _fid_seguro WHERE id_paciente = _id_paciente;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_PAGO`(
	IN _id_pago INT,
	IN _fecha_pago datetime,
	IN _monto_total decimal(10,2),
	IN _monto_cubierto_seguro decimal(10,2),
	IN _subtotal decimal(10,2),
	in _estado ENUM('PENDIENTE','CANCELADO','VENCIDO'),
    in _fid_cita int
)
BEGIN
	UPDATE pago
	SET fecha_pago=_fecha_pago,monto_total=_monto_total,monto_cubierto_seguro=_monto_cubierto_seguro,
    subtotal=_subtotal,estado=_estado, fid_cita = _fid_cita
	WHERE id_pago = _id_pago;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_RECETA`(
	IN _id_receta INT,
	IN _indicaciones VARCHAR(100)
)
BEGIN
	UPDATE receta SET indicaciones = _indicaciones
    WHERE id_receta = _id_receta;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_SEDE`(
    IN _id_sede INT,
    IN _nombre VARCHAR(100),
    IN _direccion VARCHAR(255)
)
BEGIN
    UPDATE sede SET nombre = _nombre, direccion = _direccion
    WHERE id_sede = _id_sede;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_SEGURO`(
	IN _id_seguro INT,
	IN _nombre_seguro VARCHAR(100),
	IN _tipo ENUM('TOTAL','PARCIAL','NINGUNO'),
	IN _porcentaje_cobertura decimal(10,2),
    in _vigencia date
)
BEGIN
	UPDATE seguro
	SET nombre_seguro=_nombre_seguro,tipo=_tipo,porcentaje_cobertura=_porcentaje_cobertura,
	vigencia = _vigencia WHERE id_seguro = _id_seguro;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `MODIFICAR_TURNO`(
	IN _id_turno INT,
    IN _dia ENUM('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO'),
    IN _hora_inicio TIME,
    IN _hora_fin TIME
)
BEGIN
	UPDATE turno
    SET dia = _dia, hora_inicio = _hora_inicio, hora_fin = _hora_fin
    WHERE id_turno = _id_turno;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_ADMINISTRADOR_X_ID`(
	in _id_admin int
)
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero
	FROM administrador a INNER JOIN usuario u ON a.id_administrador = u.id_usuario WHERE u.id_usuario = _id_admin;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_CITA_X_ID`(
    IN _id_cita INT
)
BEGIN
    SELECT c.id_cita, c.fecha, c.estado_cita, c.estado_atencion, c.motivo_consulta,
    c.fid_paciente, u.nombre, u.apellido_paterno, u.apellido_materno, u.dni, u.fecha_nacimiento,
    u.email, u.genero, p.direccion, p.telefono, h.id_horario_trabajo,h.fid_medico, h.fid_turno
    FROM cita c inner join paciente p on c.fid_paciente = p.id_paciente inner join usuario u on u.id_usuario = p.id_paciente inner join
    horario_trabajo h on c.fid_horario_trabajo = h.id_horario_trabajo where c.id_cita = c.id_cita;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_CITA_X_ID_COMPLETO_SIN_PACIENTE`(
    IN _id_cita INT
)
BEGIN
    SELECT
        c.id_cita,
        c.fecha,
        c.estado_cita,
        c.estado_atencion,
        c.motivo_consulta,

        um.id_usuario AS id_medico_usuario,
        m.codigo_medico,
        um.nombre AS nombre_medico,
        um.apellido_paterno AS apellido_paterno_medico,
        um.apellido_materno AS apellido_materno_medico,
        um.dni AS dni_medico,
        um.email AS email_medico,
        um.genero AS genero_medico,

        h.id_horario_trabajo,

        e.id_especialidad,
        e.nombre AS nombre_especialidad,
        e.descripcion AS descripcion_especialidad,

        s.id_sede,
        s.nombre AS nombre_sede,
        s.direccion AS direccion_sede,

        con.id_consultorio,
        con.nombre_consultorio,
        con.piso,
        con.capacidad,

        t.id_turno,
        t.dia,
        t.hora_inicio,
        t.hora_fin

    FROM cita c
    INNER JOIN horario_trabajo h ON c.fid_horario_trabajo = h.id_horario_trabajo
    INNER JOIN medico m ON h.fid_medico = m.id_medico
    INNER JOIN usuario um ON um.id_usuario = m.id_medico
    INNER JOIN sede s ON m.fid_sede = s.id_sede
    INNER JOIN consultorio con ON m.fid_consultorio = con.id_consultorio
    INNER JOIN especialidad e ON m.fid_especialidad = e.id_especialidad
    INNER JOIN turno t ON h.fid_turno = t.id_turno

    WHERE c.activo = 1
      AND c.id_cita = _id_cita;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_CONSULTORIO_X_ID`(
    IN _id_consultorio INT
)
BEGIN
    SELECT id_consultorio, nombre_consultorio, piso, capacidad, asignado, fid_sede
    FROM consultorio WHERE id_consultorio = _id_consultorio;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_CONSULTORIO_X_MEDICO`(
	IN _id_medico INT
)
BEGIN
	SELECT id_consultorio, nombre_consultorio, piso, capacidad, asignado
    FROM consultorio c
    inner join medico m
    on m.fid_consultorio = c.id_consultorio
    where m.id_medico = _id_medico;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_ESPECIALIDAD_X_ID`(
    IN _id_especialidad INT
)
BEGIN
    SELECT id_especialidad, nombre, descripcion, activo
    FROM especialidad WHERE id_especialidad = _id_especialidad;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_HISTORIAL`(
	in _id_paciente int
)
BEGIN
	SELECT
    h.id_historial, h.fecha_actualizacion, p.id_paciente,
    u.nombre, u.apellido_paterno, u.apellido_materno, u.dni
    FROM historial_medico h
    INNER JOIN paciente p ON h.fid_paciente = p.id_paciente
    INNER JOIN usuario u ON p.id_paciente = u.id_usuario
    WHERE h.activo = 1 and h.fid_paciente = _id_paciente;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_HORARIO_X_ID`(
    IN _id_horario INT
)
BEGIN
    SELECT h.id_horario_trabajo, h.fid_turno, t.dia, t.hora_inicio, t.hora_fin ,h.fid_medico
    FROM horario_trabajo h inner join turno t on h.fid_turno = t.id_turno WHERE h.id_horario_trabajo = _id_horario;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_MEDICO_X_CADENA`(
    IN cadena VARCHAR(50)
)
BEGIN
    SELECT
        u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno,u.dni,
        u.email,u.fecha_nacimiento,u.genero,m.codigo_medico,s.id_sede,s.nombre AS nombre_sede,
        s.direccion,c.id_consultorio,c.nombre_consultorio,c.piso,c.capacidad,c.asignado,
        e.id_especialidad,e.nombre AS nombre_especialidad,e.descripcion
    FROM medico m
    INNER JOIN usuario u ON m.id_medico = u.id_usuario
    INNER JOIN sede s ON s.id_sede = m.fid_sede
    INNER JOIN consultorio c ON m.fid_consultorio = c.id_consultorio
    INNER JOIN especialidad e ON m.fid_especialidad = e.id_especialidad
    WHERE
        u.nombre LIKE CONCAT('%', cadena, '%')
        OR u.apellido_paterno LIKE CONCAT('%', cadena, '%')
        OR u.apellido_materno LIKE CONCAT('%', cadena, '%')
        OR s.nombre LIKE CONCAT('%', cadena, '%')
        OR e.nombre LIKE CONCAT('%', cadena, '%');
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_MEDICO_X_ID`(
	IN _id_medico int
)
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero,
    m.codigo_medico, s.id_sede, s.nombre as nombre_sede, s.direccion, c.id_consultorio, c.nombre_consultorio,
    c.piso, c.capacidad, c.asignado, e.id_especialidad, e.nombre as nombre_especialidad, e.descripcion  FROM medico m
    INNER JOIN usuario u ON m.id_medico = u.id_usuario INNER JOIN sede s ON s.id_sede = m.fid_sede INNER JOIN consultorio c on m.fid_consultorio = c.id_consultorio
    inner join especialidad e on m.fid_especialidad = e.id_especialidad WHERE m.id_medico = _id_medico;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_PACIENTE_X_DNI`(
	in _dni varchar(20)
)
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero,
    p.direccion, p.telefono, seg.id_seguro, seg.nombre_seguro,
    seg.tipo, seg.porcentaje_cobertura, seg.vigencia FROM paciente p INNER JOIN usuario u ON p.id_paciente = u.id_usuario
	inner join seguro seg on seg.id_seguro = p.fid_seguro WHERE u.dni = _dni;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_PACIENTE_X_ID`(
	in _id_paciente int
)
BEGIN
	SELECT u.id_usuario,u.nombre,u.apellido_paterno,u.apellido_materno, u.dni, u.email, u.fecha_nacimiento, u.genero,
    p.direccion, p.telefono, seg.id_seguro, seg.nombre_seguro,
    seg.tipo, seg.porcentaje_cobertura, seg.vigencia FROM paciente p INNER JOIN usuario u ON p.id_paciente = u.id_usuario
	inner join seguro seg on seg.id_seguro = p.fid_seguro WHERE p.id_paciente = _id_paciente;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_SEDE_X_ID`(
    IN _id_sede INT
)
BEGIN
    SELECT id_sede, nombre, direccion
    FROM sede WHERE id_sede = _id_sede;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_TURNOS_LIBRES`(
    IN _fecha DATE,
    IN _id_medico INT
)
BEGIN
    DECLARE _dia_enum ENUM('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO');

    SET _dia_enum = CASE DAYOFWEEK(_fecha)
        WHEN 1 THEN 'DOMINGO'
        WHEN 2 THEN 'LUNES'
        WHEN 3 THEN 'MARTES'
        WHEN 4 THEN 'MIERCOLES'
        WHEN 5 THEN 'JUEVES'
        WHEN 6 THEN 'VIERNES'
        WHEN 7 THEN 'SABADO'
    END;

    SELECT
        t.id_turno,
        t.dia,
        t.hora_inicio,
        t.hora_fin
    FROM turno t
    INNER JOIN horario_trabajo h ON h.fid_turno = t.id_turno
    WHERE
        h.fid_medico = _id_medico
        AND t.dia = _dia_enum
        AND h.id_horario_trabajo NOT IN (
            SELECT c.fid_horario_trabajo
            FROM cita c
            WHERE c.fecha = _fecha
              AND c.activo = 1
              AND c.estado_cita <> 'CANCELADA'
        )
    ORDER BY t.hora_inicio;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `OBTENER_TURNO_X_ID`(
    IN _id_turno INT
)
BEGIN
    SELECT id_turno, dia, hora_inicio, hora_fin
    FROM turno WHERE id_turno = _id_turno;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `VERIFICAR_CUENTA_ADMINISTRADOR`(
	IN _username VARCHAR(30),
    IN _password VARCHAR(150)
)
BEGIN
	SELECT id_cuenta, fid_usuario, username, password
    FROM cuenta_usuario c inner join administrador m on m.id_administrador = c.fid_usuario
    where c.activo = 1 AND username = _username AND password = MD5(_password);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `VERIFICAR_CUENTA_GENERAL`(
    IN p_identificador VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_rol ENUM('PACIENTE', 'MÉDICO', 'ADMINISTRADOR')
)
BEGIN
    SELECT
        cu.id_cuenta,
        cu.fid_usuario,
        cu.username,
        cu.rol,
        u.nombre,
        u.apellido_paterno,
        u.apellido_materno
    FROM cuenta_usuario cu
    INNER JOIN usuario u ON u.id_usuario = cu.fid_usuario
    WHERE cu.activo = 1
      AND cu.rol = p_rol
      AND (u.dni = p_identificador OR cu.username = p_identificador)
      AND (cu.password = p_password OR cu.password = MD5(p_password));
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `VERIFICAR_CUENTA_MEDICO`(
	IN _username VARCHAR(30),
    IN _password VARCHAR(150)
)
BEGIN
	SELECT id_cuenta, fid_usuario, username, password
    FROM cuenta_usuario c inner join medico m on m.id_medico = c.fid_usuario
    where c.activo = 1 AND username = _username AND password = MD5(_password);
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`pazadmin`@`%` PROCEDURE `VERIFICAR_CUENTA_PACIENTE`(
	IN _username VARCHAR(30),
    IN _password VARCHAR(150)
)
BEGIN
	SELECT id_cuenta, fid_usuario, username, password
    FROM cuenta_usuario c inner join paciente p on p.id_paciente = c.fid_usuario
    where c.activo = 1 AND username = _username AND password = MD5(_password);
END ;;
DELIMITER ;

DELIMITER $
CREATE PROCEDURE LISTAR_CONSULTORIOS_X_SEDE_NO_ASIGNADOS(
	IN _id_sede INT
)
BEGIN
    SELECT id_consultorio, nombre_consultorio, piso, capacidad, asignado
    FROM consultorio c 
    inner join sede s
    on s.id_sede = c.fid_sede
    where s.id_sede = _id_sede  and c.activo = 1 and c.asignado = 0;
END$


DELIMITER $
CREATE PROCEDURE VERIFICAR_USERNAME_EXISTE(
    IN p_username VARCHAR(100)
)
BEGIN
    SELECT 
        COUNT(*) > 0 AS existe
    FROM cuenta_usuario
    WHERE username = p_username;
END$

DELIMITER $
CREATE PROCEDURE VERIFICAR_CONSULTORIO_EXISTE_EN_SEDE(
    IN _nombre_consultorio VARCHAR(100),
    IN _id_sede INT
)
BEGIN
    SELECT 
        COUNT(*) > 0 AS existe
    FROM consultorio
    WHERE nombre_consultorio = _nombre_consultorio
    AND fid_sede = _id_sede;
END$

DELIMITER $
CREATE PROCEDURE OBTENER_PACIENTE_X_CADENA(
    IN _cadena VARCHAR(50)
)
BEGIN
    SELECT 
        u.id_usuario, u.nombre, u.apellido_paterno, u.apellido_materno, u.dni,
        u.email, u.fecha_nacimiento, u.genero,
        p.direccion, p.telefono, seg.id_seguro, seg.nombre_seguro,
        seg.tipo, seg.porcentaje_cobertura, seg.vigencia
    FROM paciente p 
    INNER JOIN usuario u ON p.id_paciente = u.id_usuario
    INNER JOIN seguro seg ON seg.id_seguro = p.fid_seguro
    WHERE 
        u.nombre LIKE CONCAT('%', _cadena, '%')
        OR u.apellido_paterno LIKE CONCAT('%', _cadena, '%')
        OR u.apellido_materno LIKE CONCAT('%', _cadena, '%')
        OR u.dni LIKE CONCAT('%', _cadena, '%');
END$

DELIMITER $
DROP PROCEDURE IF EXISTS LISTAR_CITA_X_MEDICO_X_ESTADO$
CREATE PROCEDURE LISTAR_CITA_X_MEDICO_X_ESTADO(
	IN _id_medico int,
    in _estado enum('PROGRAMADA','ATENDIDA','CANCELADA')
)
BEGIN
    SELECT c.id_cita, c.fecha, c.estado_cita, c.estado_atencion, c.motivo_consulta, 
    c.fid_paciente, u.nombre, u.apellido_paterno, u.apellido_materno, u.dni, u.fecha_nacimiento,
    u.email, u.genero, p.direccion, p.telefono, h.id_horario_trabajo,h.fid_medico, h.fid_turno
    FROM cita c inner join paciente p on c.fid_paciente = p.id_paciente inner join usuario u on u.id_usuario = p.id_paciente inner join 
    horario_trabajo h on c.fid_horario_trabajo = h.id_horario_trabajo where c.activo = 1 and h.fid_medico = _id_medico AND c.estado_cita = _estado
    ORDER BY c.fecha;
END$
DROP PROCEDURE IF EXISTS LISTAR_NOTAS_CLINICAS_X_HISTORIAL$
CREATE PROCEDURE LISTAR_NOTAS_CLINICAS_X_HISTORIAL(
	IN _id_historial int
)
BEGIN
	SELECT
        nc.id_nota,
        nc.descripcion,
        nc.diagnostico,
        nc.observaciones,
        nc.fid_cita AS id_cita,
        nc.fid_receta AS id_receta,
        nc.fid_historial AS id_historial
    FROM
        nota_clinica nc where _id_historial = fid_historial;
END$

DROP PROCEDURE IF EXISTS OBTENER_HISTORIAL$
CREATE PROCEDURE OBTENER_HISTORIAL(
	in _id_paciente int
)
BEGIN
	SELECT
    h.id_historial, h.fecha_actualizacion, p.id_paciente,
    u.nombre, u.apellido_paterno, u.apellido_materno, u.dni
    FROM historial_medico h
    INNER JOIN paciente p ON h.fid_paciente = p.id_paciente
    INNER JOIN usuario u ON p.id_paciente = u.id_usuario
    WHERE h.activo = 1 and h.fid_paciente = _id_paciente;
END$























-- Inserts Sede
SET @id_sede := 0;
CALL INSERTAR_SEDE(@id_sede, 'Sede Los Olivos', 'Avenida Universitaria Nº 2020');
CALL INSERTAR_SEDE(@id_sede, 'Sede Magdalena', 'Calle Las Magnolias Nº 20');
CALL INSERTAR_SEDE(@id_sede, 'Sede Miraflores', 'Calle Ultima Esperanza Nº 20');
CALL INSERTAR_SEDE(@id_sede, 'Sede Central', 'Av. Salud 123 - Lima');
CALL INSERTAR_SEDE(@id_sede, 'Sede Sur', 'Av. Esperanza 456 - Arequipa');
CALL INSERTAR_SEDE(@id_sede, 'Sede Universidad Católica', 'Av. Universitaria S/N');






-- Inserts Especialidad
SET @id_esp := 0;
CALL INSERTAR_ESPECIALIDAD(@id_esp, 'Pediatría', 'Atención médica infantil');
CALL INSERTAR_ESPECIALIDAD(@id_esp, 'Cardiología', 'Enfermedades del corazón');
CALL INSERTAR_ESPECIALIDAD(@id_esp, 'Dermatología', 'Problemas de la piel');
CALL INSERTAR_ESPECIALIDAD(@id_esp, 'Ginecología', 'Salud reproductiva femenina');
CALL INSERTAR_ESPECIALIDAD(@id_esp, 'Neurología', 'Trastornos del sistema nervioso');
CALL INSERTAR_ESPECIALIDAD(@id_esp, 'Medicina General', 'Atención médica primaria');





-- Inserts Sede_Especialidad
SET @id_se := 0;

-- Sede 1 - Sede Los Olivos
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 1, 1); -- Pediatría
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 1, 2); -- Cardiología
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 1, 3); -- Dermatología
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 1, 4); -- Ginecología
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 1, 5); -- Neurología

-- Sede 2 - Sede Magdalena
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 2, 1);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 2, 2);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 2, 4);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 2, 6); -- Medicina General

-- Sede 3 - Sede Miraflores
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 3, 2);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 3, 3);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 3, 4);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 3, 5);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 3, 6);

-- Sede 4 - Sede Central
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 4, 1);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 4, 2);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 4, 3);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 4, 4);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 4, 5);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 4, 6);

-- Sede 5 - Sede Sur
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 5, 1);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 5, 3);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 5, 4);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 5, 6);

-- Sede 6 - Sede Universidad Católica
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 6, 1);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 6, 2);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 6, 5);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 6, 6);
CALL INSERTAR_SEDE_ESPECIALIDAD(@id_se, 6, 3);






-- Inserts Consultorios
SET @id_con := 0;

-- Sede 1 - Sede Los Olivos
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 101', 1, 2, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 102', 1, 2, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 201', 2, 3, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 202', 2, 3, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 301', 3, 4, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 302', 3, 2, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 303', 3, 3, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 304', 3, 4, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 305', 3, 2, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 401', 4, 2, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 402', 4, 3, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 403', 4, 3, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 404', 4, 4, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 405', 4, 2, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 501', 5, 3, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 502', 5, 2, 1);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio LO 503', 5, 4, 1);

-- Sede 2 - Sede Magdalena
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MG 101', 1, 2, 2);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MG 102', 1, 3, 2);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MG 201', 2, 2, 2);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MG 301', 3, 4, 2);

-- Sede 3 - Sede Miraflores
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MF 101', 1, 2, 3);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MF 102', 1, 2, 3);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MF 201', 2, 3, 3);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MF 202', 2, 4, 3);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MF 301', 3, 3, 3);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio MF 302', 3, 3, 3);

-- Sede 4 - Sede Central
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SC 101', 1, 3, 4);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SC 102', 1, 3, 4);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SC 201', 2, 4, 4);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SC 202', 2, 4, 4);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SC 301', 3, 5, 4);

-- Sede 5 - Sede Sur
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SS 101', 1, 2, 5);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SS 102', 1, 2, 5);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio SS 201', 2, 3, 5);

-- Sede 6 - Sede Universidad Católica
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio UC 101', 1, 3, 6);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio UC 102', 1, 3, 6);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio UC 201', 2, 4, 6);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio UC 202', 2, 4, 6);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio UC 301', 3, 5, 6);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio UC 302', 3, 2, 6);
CALL INSERTAR_CONSULTORIO(@id_con, 'Consultorio UC 401', 4, 2, 6);





-- Médicos Sede 1 - Los Olivos (Consultorios 1-18)
SET @id_medico := 0;
CALL INSERTAR_MEDICO(@id_medico, 'Carlos', 'Gomez', 'Perez', '12345678', 'carlos.gomez@pazcitas.com', '1980-05-15', 'M', 'CMP00001', 1, 1, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Ana', 'Lopez', 'Martinez', '87654321', 'ana.lopez@pazcitas.com', '1985-11-20', 'F', 'CMP00002', 1, 2, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Luis', 'Fernandez', 'Garcia', '11223344', 'luis.fernandez@pazcitas.com', '1978-02-10', 'M', 'CMP00003', 1, 3, 3);
CALL INSERTAR_MEDICO(@id_medico, 'Maria', 'Rodriguez', 'Sanchez', '44332211', 'maria.rodriguez@pazcitas.com', '1982-07-30', 'F', 'CMP00004', 1, 4, 4);
CALL INSERTAR_MEDICO(@id_medico, 'Jorge', 'Diaz', 'Vargas', '55667788', 'jorge.diaz@pazcitas.com', '1990-01-25', 'M', 'CMP00005', 1, 5, 5);
CALL INSERTAR_MEDICO(@id_medico, 'Sofia', 'Torres', 'Ramirez', '88776655', 'sofia.torres@pazcitas.com', '1988-09-12', 'F', 'CMP00006', 1, 6, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Pedro', 'Mendoza', 'Flores', '99887766', 'pedro.mendoza@pazcitas.com', '1975-03-18', 'M', 'CMP00007', 1, 7, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Laura', 'Castro', 'Rojas', '66778899', 'laura.castro@pazcitas.com', '1991-06-05', 'F', 'CMP00008', 1, 8, 3);
CALL INSERTAR_MEDICO(@id_medico, 'Diego', 'Ortiz', 'Cruz', '10102020', 'diego.ortiz@pazcitas.com', '1984-12-01', 'M', 'CMP00009', 1, 9, 4);
CALL INSERTAR_MEDICO(@id_medico, 'Valeria', 'Morales', 'Reyes', '30304040', 'valeria.morales@pazcitas.com', '1989-08-22', 'F', 'CMP00010', 1, 10, 5);
CALL INSERTAR_MEDICO(@id_medico, 'Javier', 'Soto', 'Gutierrez', '50506060', 'javier.soto@pazcitas.com', '1981-04-14', 'M', 'CMP00011', 1, 11, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Camila', 'Guerrero', 'Paredes', '70708080', 'camila.guerrero@pazcitas.com', '1992-10-09', 'F', 'CMP00012', 1, 12, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Miguel', 'Ramos', 'Salazar', '90901010', 'miguel.ramos@pazcitas.com', '1979-07-07', 'M', 'CMP00013', 1, 13, 3);
CALL INSERTAR_MEDICO(@id_medico, 'Isabella', 'Benites', 'Chavez', '21213131', 'isabella.benites@pazcitas.com', '1986-05-28', 'F', 'CMP00014', 1, 14, 4);
CALL INSERTAR_MEDICO(@id_medico, 'Ricardo', 'Acosta', 'Medina', '41415151', 'ricardo.acosta@pazcitas.com', '1983-11-11', 'M', 'CMP00015', 1, 15, 5);
CALL INSERTAR_MEDICO(@id_medico, 'Daniela', 'Espinoza', 'Cordova', '61617171', 'daniela.espinoza@pazcitas.com', '1993-02-19', 'F', 'CMP00016', 1, 16, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Fernando', 'Castillo', 'Vega', '81819191', 'fernando.castillo@pazcitas.com', '1977-09-03', 'M', 'CMP00017', 1, 17, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Luciana', 'Aguilar', 'Solis', '13132424', 'luciana.aguilar@pazcitas.com', '1987-12-24', 'F', 'CMP00018', 1, 18, 3);

-- Médicos Sede 2 - Magdalena (Consultorios 19-22)
CALL INSERTAR_MEDICO(@id_medico, 'Roberto', 'Rios', 'Delgado', '35354646', 'roberto.rios@pazcitas.com', '1980-08-08', 'M', 'CMP00019', 2, 19, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Patricia', 'Luna', 'Campos', '57576868', 'patricia.luna@pazcitas.com', '1984-04-04', 'F', 'CMP00020', 2, 20, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Hector', 'Navarro', 'Salas', '79798080', 'hector.navarro@pazcitas.com', '1976-10-10', 'M', 'CMP00021', 2, 21, 4);
CALL INSERTAR_MEDICO(@id_medico, 'Silvia', 'Herrera', 'Valencia', '12122323', 'silvia.herrera@pazcitas.com', '1988-01-01', 'F', 'CMP00022', 2, 22, 6);

-- Médicos Sede 3 - Miraflores (Consultorios 23-28)
CALL INSERTAR_MEDICO(@id_medico, 'Oscar', 'Quispe', 'Ponce', '34344545', 'oscar.quispe@pazcitas.com', '1982-03-03', 'M', 'CMP00023', 3, 23, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Carolina', 'Velasquez', 'Leon', '56566767', 'carolina.velasquez@pazcitas.com', '1990-07-07', 'F', 'CMP00024', 3, 24, 3);
CALL INSERTAR_MEDICO(@id_medico, 'Raul', 'Ibañez', 'Huaman', '78788989', 'raul.ibanez@pazcitas.com', '1979-11-11', 'M', 'CMP00025', 3, 25, 4);
CALL INSERTAR_MEDICO(@id_medico, 'Adriana', 'Cabrera', 'Figueroa', '14142525', 'adriana.cabrera@pazcitas.com', '1986-06-06', 'F', 'CMP00026', 3, 26, 5);
CALL INSERTAR_MEDICO(@id_medico, 'Manuel', 'Miranda', 'Bustamante', '36364747', 'manuel.miranda@pazcitas.com', '1981-09-09', 'M', 'CMP00027', 3, 27, 6);
CALL INSERTAR_MEDICO(@id_medico, 'Natalia', 'Peralta', 'Maldonado', '58586969', 'natalia.peralta@pazcitas.com', '1991-02-02', 'F', 'CMP00028', 3, 28, 2);

-- Médicos Sede 4 - Central (Consultorios 29-33)
CALL INSERTAR_MEDICO(@id_medico, 'Andres', 'Guzman', 'Montoya', '70708181', 'andres.guzman@pazcitas.com', '1983-05-05', 'M', 'CMP00029', 4, 29, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Gabriela', 'Farfan', 'Palomino', '92920303', 'gabriela.farfan@pazcitas.com', '1987-08-08', 'F', 'CMP00030', 4, 30, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Martin', 'Jimenez', 'Alvarado', '15152626', 'martin.jimenez@pazcitas.com', '1978-12-12', 'M', 'CMP00031', 4, 31, 3);
CALL INSERTAR_MEDICO(@id_medico, 'Paola', 'Santillan', 'Osorio', '37374848', 'paola.santillan@pazcitas.com', '1989-03-03', 'F', 'CMP00032', 4, 32, 4);
CALL INSERTAR_MEDICO(@id_medico, 'Francisco', 'Pineda', 'Zavala', '59597070', 'francisco.pineda@pazcitas.com', '1985-10-10', 'M', 'CMP00033', 4, 33, 5);

-- Médicos Sede 5 - Sur (Consultorios 34-36)
CALL INSERTAR_MEDICO(@id_medico, 'Monica', 'Ortega', 'Carranza', '71718282', 'monica.ortega@pazcitas.com', '1984-06-06', 'F', 'CMP00034', 5, 34, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Ivan', 'Roldan', 'Coronado', '93930404', 'ivan.roldan@pazcitas.com', '1980-02-02', 'M', 'CMP00035', 5, 35, 3);
CALL INSERTAR_MEDICO(@id_medico, 'Juliana', 'Tello', 'Barrios', '16162727', 'juliana.tello@pazcitas.com', '1992-09-09', 'F', 'CMP00036', 5, 36, 6);

-- Médicos Sede 6 - Universidad Católica (Consultorios 37-42)
CALL INSERTAR_MEDICO(@id_medico, 'Eduardo', 'Vilchez', 'Escobar', '38384949', 'eduardo.vilchez@pazcitas.com', '1986-01-01', 'M', 'CMP00037', 6, 37, 1);
CALL INSERTAR_MEDICO(@id_medico, 'Beatriz', 'Zamora', 'Gallardo', '60607171', 'beatriz.zamora@pazcitas.com', '1982-04-04', 'F', 'CMP00038', 6, 38, 2);
CALL INSERTAR_MEDICO(@id_medico, 'Victor', 'Linares', 'Cisneros', '82829393', 'victor.linares@pazcitas.com', '1977-07-07', 'M', 'CMP00039', 6, 39, 5);
CALL INSERTAR_MEDICO(@id_medico, 'Ximena', 'Yañez', 'Prado', '17172828', 'ximena.yanez@pazcitas.com', '1993-11-11', 'F', 'CMP00040', 6, 40, 6);
CALL INSERTAR_MEDICO(@id_medico, 'Alonso', 'Calderon', 'Rivas', '39395050', 'alonso.calderon@pazcitas.com', '1988-08-08', 'M', 'CMP00041', 6, 41, 3);
CALL INSERTAR_MEDICO(@id_medico, 'Tatiana', 'Salcedo', 'Bravo', '61617272', 'tatiana.salcedo@pazcitas.com', '1985-03-03', 'F', 'CMP00042', 6, 42, 1);





SET @id_turno := 0;

-- Turnos LUNES
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '08:00:00', '09:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '09:00:00', '10:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '10:00:00', '11:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '11:00:00', '12:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '14:00:00', '15:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '15:00:00', '16:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '16:00:00', '17:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '17:00:00', '18:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '18:00:00', '19:00:00');
CALL INSERTAR_TURNO(@id_turno, 'LUNES', '19:00:00', '20:00:00');

-- Turnos MARTES
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '08:00:00', '09:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '09:00:00', '10:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '10:00:00', '11:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '11:00:00', '12:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '14:00:00', '15:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '15:00:00', '16:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '16:00:00', '17:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '17:00:00', '18:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '18:00:00', '19:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MARTES', '19:00:00', '20:00:00');

-- Turnos MIERCOLES
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '08:00:00', '09:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '09:00:00', '10:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '10:00:00', '11:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '11:00:00', '12:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '14:00:00', '15:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '15:00:00', '16:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '16:00:00', '17:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '17:00:00', '18:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '18:00:00', '19:00:00');
CALL INSERTAR_TURNO(@id_turno, 'MIERCOLES', '19:00:00', '20:00:00');

-- Turnos JUEVES
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '08:00:00', '09:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '09:00:00', '10:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '10:00:00', '11:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '11:00:00', '12:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '14:00:00', '15:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '15:00:00', '16:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '16:00:00', '17:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '17:00:00', '18:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '18:00:00', '19:00:00');
CALL INSERTAR_TURNO(@id_turno, 'JUEVES', '19:00:00', '20:00:00');

-- Turnos VIERNES
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '08:00:00', '09:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '09:00:00', '10:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '10:00:00', '11:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '11:00:00', '12:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '14:00:00', '15:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '15:00:00', '16:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '16:00:00', '17:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '17:00:00', '18:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '18:00:00', '19:00:00');
CALL INSERTAR_TURNO(@id_turno, 'VIERNES', '19:00:00', '20:00:00');






SET @id_horario_trabajo := 0;

-- Médicos 1 al 14 (40 horas/semana)
CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 1, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 2, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 3, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 4, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 5, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 6, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 7, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 8, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 9, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 10, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 11, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 12, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 13, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 28); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 14, 48);

-- Médicos 15 al 28 (35 horas/semana)
CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 15, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 16, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 17, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 18, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 19, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 20, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 21, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 22, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 23, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 24, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 25, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 26, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 27, 47);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 21); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 22); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 23); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 24); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 25); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 26); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 27); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 28, 47);

-- Médicos 29 al 42 (32 horas/semana)
CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 29, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 30, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 31, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 32, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 33, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 34, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 35, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 36, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 37, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 38, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 39, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 40, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 41, 48);
CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 1); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 2); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 3); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 4); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 5); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 6); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 7); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 8); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 11); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 12); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 13); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 14); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 15); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 16); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 17); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 18); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 31); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 32); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 33); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 34); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 35); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 36); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 37); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 38); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 41); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 42); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 43); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 44); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 45); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 46); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 47); CALL INSERTAR_HORARIO(@id_horario_trabajo, 42, 48);



-- Insertar Seguro
SET @id_seguro := 0;
CALL INSERTAR_SEGURO(@id_seguro, 'Pacífico Salud - Plan Integral', 'TOTAL', 100.00, '2025-12-31');
CALL INSERTAR_SEGURO(@id_seguro, 'Rimac Seguros - Plan Red Preferente', 'PARCIAL', 85.50, '2025-10-30');
CALL INSERTAR_SEGURO(@id_seguro, 'Mapfre - Plan Familiar', 'PARCIAL', 70.00, '2026-06-15');
CALL INSERTAR_SEGURO(@id_seguro, 'La Positiva - Plan Esencial', 'PARCIAL', 50.00, '2025-08-20');
CALL INSERTAR_SEGURO(@id_seguro, 'Particular (Sin Cobertura)', 'NINGUNO', 0.00, '2099-12-31');




-- Insertar Paciente
SET @id_paciente := 0;

CALL INSERTAR_PACIENTE(@id_paciente, 'Elena', 'Vasquez', 'Torres', '70123456', 'elena.vasquez@example.com', '1995-03-22', 'F', 'Av. Arequipa 123', '987654321', 1);
CALL INSERTAR_PACIENTE(@id_paciente, 'Marco', 'Solano', 'Rojas', '71234567', 'marco.solano@example.com', '1988-11-10', 'M', 'Calle Schell 45', '912345678', 2);
CALL INSERTAR_PACIENTE(@id_paciente, 'Lucia', 'Mendoza', 'Peña', '72345678', 'lucia.mendoza@example.com', '2001-07-15', 'F', 'Jr. de la Union 890', '923456789', 3);
CALL INSERTAR_PACIENTE(@id_paciente, 'Bruno', 'Castillo', 'Diaz', '73456789', 'bruno.castillo@example.com', '1979-01-30', 'M', 'Av. Larco 777', '934567890', 4);
CALL INSERTAR_PACIENTE(@id_paciente, 'Carla', 'Flores', 'Paredes', '74567890', 'carla.flores@example.com', '1999-09-05', 'F', 'Calle Los Pinos 111', '945678901', 5);
CALL INSERTAR_PACIENTE(@id_paciente, 'David', 'Gomez', 'Salazar', '75678901', 'david.gomez@example.com', '1985-06-12', 'M', 'Av. Javier Prado 2020', '956789012', 1);
CALL INSERTAR_PACIENTE(@id_paciente, 'Sofia', 'Quispe', 'Chavez', '76789012', 'sofia.quispe@example.com', '2005-02-18', 'F', 'Calle Las Begonias 321', '967890123', 2);
CALL INSERTAR_PACIENTE(@id_paciente, 'Alejandro', 'Vargas', 'Medina', '77890123', 'alejandro.vargas@example.com', '1965-10-25', 'M', 'Av. Angamos 543', '978901234', 3);
CALL INSERTAR_PACIENTE(@id_paciente, 'Valeria', 'Rios', 'Campos', '78901234', 'valeria.rios@example.com', '1992-04-09', 'F', 'Calle Berlin 987', '989012345', 1);
CALL INSERTAR_PACIENTE(@id_paciente, 'Mateo', 'Ortiz', 'Cruz', '79012345', 'mateo.ortiz@example.com', '2010-12-01', 'M', 'Av. El Sol 100', '990123456', 5);





-- Insertar Cita
SET @id_cita := 0;

-- Citas de Mayo y Junio 2025 (serán pasadas)
CALL INSERTAR_CITA(@id_cita, '2025-05-26', 'Control anual pediátrico', 43, 1);
CALL INSERTAR_CITA(@id_cita, '2025-05-27', 'Vacunación pendiente', 44, 12);
CALL INSERTAR_CITA(@id_cita, '2025-05-28', 'Revisión de crecimiento', 45, 23);
CALL INSERTAR_CITA(@id_cita, '2025-05-29', 'Consulta por fiebre', 46, 35);
CALL INSERTAR_CITA(@id_cita, '2025-05-30', 'Alergia estacional', 47, 46);
CALL INSERTAR_CITA(@id_cita, '2025-05-26', 'Chequeo cardiológico', 48, 41);
CALL INSERTAR_CITA(@id_cita, '2025-05-27', 'Lectura de Holter', 49, 52);
CALL INSERTAR_CITA(@id_cita, '2025-05-28', 'Control de presión', 50, 63);
CALL INSERTAR_CITA(@id_cita, '2025-05-29', 'Prueba de esfuerzo', 51, 75);
CALL INSERTAR_CITA(@id_cita, '2025-05-30', 'Consulta por arritmia', 52, 86);
CALL INSERTAR_CITA(@id_cita, '2025-06-02', 'Revisión de lunares', 43, 81);
CALL INSERTAR_CITA(@id_cita, '2025-06-03', 'Tratamiento acné', 44, 92);
CALL INSERTAR_CITA(@id_cita, '2025-06-04', 'Consulta por eccema', 45, 103);
CALL INSERTAR_CITA(@id_cita, '2025-06-05', 'Control de dermatitits', 46, 115);
CALL INSERTAR_CITA(@id_cita, '2025-06-06', 'Caída de cabello', 47, 126);
CALL INSERTAR_CITA(@id_cita, '2025-06-02', 'Control ginecológico anual', 48, 121);
CALL INSERTAR_CITA(@id_cita, '2025-06-03', 'Resultados Papanicolau', 49, 132);
CALL INSERTAR_CITA(@id_cita, '2025-06-04', 'Consulta prenatal', 50, 143);
CALL INSERTAR_CITA(@id_cita, '2025-06-05', 'Planificación familiar', 51, 155);
CALL INSERTAR_CITA(@id_cita, '2025-06-06', 'Ecografía de control', 52, 166);

-- Citas de Julio y Agosto 2025 (serán futuras/programadas)
CALL INSERTAR_CITA(@id_cita, '2025-07-07', 'Dolor de cabeza crónico', 43, 161);
CALL INSERTAR_CITA(@id_cita, '2025-07-08', 'Seguimiento de migraña', 44, 172);
CALL INSERTAR_CITA(@id_cita, '2025-07-09', 'Evaluación neurológica', 45, 183);
CALL INSERTAR_CITA(@id_cita, '2025-07-10', 'Resultados de EEG', 46, 195);
CALL INSERTAR_CITA(@id_cita, '2025-07-11', 'Consulta por mareos', 47, 206);
CALL INSERTAR_CITA(@id_cita, '2025-07-07', 'Control pediátrico', 48, 201);
CALL INSERTAR_CITA(@id_cita, '2025-07-08', 'Revisión de vacunas', 49, 212);
CALL INSERTAR_CITA(@id_cita, '2025-07-09', 'Consulta por tos', 50, 223);
CALL INSERTAR_CITA(@id_cita, '2025-07-10', 'Certificado médico escolar', 51, 235);
CALL INSERTAR_CITA(@id_cita, '2025-07-11', 'Control nutricional', 52, 246);
CALL INSERTAR_CITA(@id_cita, '2025-07-14', 'Evaluación preoperatoria', 43, 241);
CALL INSERTAR_CITA(@id_cita, '2025-07-15', 'Control post-infarto', 44, 252);
CALL INSERTAR_CITA(@id_cita, '2025-07-16', 'Chequeo de marcapasos', 45, 263);
CALL INSERTAR_CITA(@id_cita, '2025-07-17', 'Dolor en el pecho', 46, 275);
CALL INSERTAR_CITA(@id_cita, '2025-07-18', 'Hipertensión arterial', 47, 286);
CALL INSERTAR_CITA(@id_cita, '2025-07-14', 'Control de psoriasis', 48, 281);
CALL INSERTAR_CITA(@id_cita, '2025-07-15', 'Revisión de verruga', 49, 292);
CALL INSERTAR_CITA(@id_cita, '2025-07-16', 'Biopsia de piel', 50, 303);
CALL INSERTAR_CITA(@id_cita, '2025-07-17', 'Alergia cutánea', 51, 315);
CALL INSERTAR_CITA(@id_cita, '2025-07-18', 'Peeling químico', 52, 326);
CALL INSERTAR_CITA(@id_cita, '2025-07-21', 'Control ginecológico', 43, 321);
CALL INSERTAR_CITA(@id_cita, '2025-07-22', 'Colocación de DIU', 44, 332);
CALL INSERTAR_CITA(@id_cita, '2025-07-23', 'Ecografía transvaginal', 45, 343);
CALL INSERTAR_CITA(@id_cita, '2025-07-24', 'Consulta por menopausia', 46, 355);
CALL INSERTAR_CITA(@id_cita, '2025-07-25', 'Revisión de mamografía', 47, 366);
CALL INSERTAR_CITA(@id_cita, '2025-07-21', 'Evaluación de memoria', 48, 361);
CALL INSERTAR_CITA(@id_cita, '2025-07-22', 'Consulta por temblores', 49, 372);
CALL INSERTAR_CITA(@id_cita, '2025-07-23', 'Control de epilepsia', 50, 383);
CALL INSERTAR_CITA(@id_cita, '2025-07-24', 'Resultados resonancia', 51, 395);
CALL INSERTAR_CITA(@id_cita, '2025-07-25', 'Estudio del sueño', 52, 406);
CALL INSERTAR_CITA(@id_cita, '2025-08-04', 'Control niño sano', 43, 401);
CALL INSERTAR_CITA(@id_cita, '2025-08-05', 'Consulta por asma', 44, 412);
CALL INSERTAR_CITA(@id_cita, '2025-08-06', 'Revisión de desarrollo', 45, 423);
CALL INSERTAR_CITA(@id_cita, '2025-08-07', 'Problemas de alimentación', 46, 435);
CALL INSERTAR_CITA(@id_cita, '2025-08-08', 'Certificado de salud', 47, 446);
CALL INSERTAR_CITA(@id_cita, '2025-08-04', 'Monitoreo de arritmia', 48, 441);
CALL INSERTAR_CITA(@id_cita, '2025-08-05', 'Control de colesterol', 49, 452);
CALL INSERTAR_CITA(@id_cita, '2025-08-06', 'Ecocardiograma', 50, 463);
CALL INSERTAR_CITA(@id_cita, '2025-08-07', 'Evaluación de riesgo', 51, 475);
CALL INSERTAR_CITA(@id_cita, '2025-08-08', 'Consulta por fatiga', 52, 486);
CALL INSERTAR_CITA(@id_cita, '2025-07-28', 'Tratamiento para rosácea', 43, 481);
CALL INSERTAR_CITA(@id_cita, '2025-07-29', 'Extracción de quiste', 44, 492);
CALL INSERTAR_CITA(@id_cita, '2025-07-30', 'Consulta por urticaria', 45, 503);
CALL INSERTAR_CITA(@id_cita, '2025-07-31', 'Seguimiento de tratamiento', 46, 515);
CALL INSERTAR_CITA(@id_cita, '2025-08-01', 'Revisión de cicatriz', 47, 526);
CALL INSERTAR_CITA(@id_cita, '2025-07-28', 'Control de embarazo', 48, 521);
CALL INSERTAR_CITA(@id_cita, '2025-07-29', 'Prueba de Papanicolau', 49, 532);
CALL INSERTAR_CITA(@id_cita, '2025-07-30', 'Consulta de fertilidad', 50, 543);
CALL INSERTAR_CITA(@id_cita, '2025-07-31', 'Revisión postparto', 51, 555);
CALL INSERTAR_CITA(@id_cita, '2025-08-01', 'Mamografía anual', 52, 566);
CALL INSERTAR_CITA(@id_cita, '2025-08-11', 'Consulta por vértigo', 43, 561);
CALL INSERTAR_CITA(@id_cita, '2025-08-12', 'Revisión neurológica', 44, 568);
CALL INSERTAR_CITA(@id_cita, '2025-08-13', 'Dolor neuropático', 45, 575);
CALL INSERTAR_CITA(@id_cita, '2025-08-14', 'Estudio de conducción nerviosa', 46, 582);
CALL INSERTAR_CITA(@id_cita, '2025-08-15', 'Seguimiento ACV', 47, 589);
CALL INSERTAR_CITA(@id_cita, '2025-08-11', 'Control pediátrico general', 48, 596);
CALL INSERTAR_CITA(@id_cita, '2025-08-12', 'Dificultades de aprendizaje', 49, 603);
CALL INSERTAR_CITA(@id_cita, '2025-08-13', 'Consulta por alergias', 50, 610);
CALL INSERTAR_CITA(@id_cita, '2025-08-14', 'Vacuna de refuerzo', 51, 617);
CALL INSERTAR_CITA(@id_cita, '2025-08-15', 'Revisión de crecimiento', 52, 624);
CALL INSERTAR_CITA(@id_cita, '2025-08-18', 'Control de dermatitis', 43, 666);
CALL INSERTAR_CITA(@id_cita, '2025-08-19', 'Revisión de acné', 44, 673);
CALL INSERTAR_CITA(@id_cita, '2025-08-21', 'Control de presión arterial', 45, 865);
CALL INSERTAR_CITA(@id_cita, '2025-08-25', 'Consulta por migraña', 46, 1065);
CALL INSERTAR_CITA(@id_cita, '2025-08-26', 'Chequeo neurológico', 47, 1073);
CALL INSERTAR_CITA(@id_cita, '2025-08-28', 'Medicina General: Chequeo', 48, 1321);

-- --- 3. Actualización del estado para citas pasadas (Mayo y Junio 2025) ---
CALL MODIFICAR_CITA(1, 'ATENDIDA', 'ATENDIDO', 'Control anual pediátrico');
CALL MODIFICAR_CITA(2, 'ATENDIDA', 'ATENDIDO', 'Vacunación pendiente');
CALL MODIFICAR_CITA(3, 'CANCELADA', 'EN_ESPERA', 'Revisión de crecimiento');
CALL MODIFICAR_CITA(4, 'ATENDIDA', 'ATENDIDO', 'Consulta por fiebre');
CALL MODIFICAR_CITA(5, 'ATENDIDA', 'ATENDIDO', 'Alergia estacional');
CALL MODIFICAR_CITA(6, 'ATENDIDA', 'ATENDIDO', 'Chequeo cardiológico');
CALL MODIFICAR_CITA(7, 'ATENDIDA', 'ATENDIDO', 'Lectura de Holter');
CALL MODIFICAR_CITA(8, 'ATENDIDA', 'ATENDIDO', 'Control de presión');
CALL MODIFICAR_CITA(9, 'CANCELADA', 'EN_ESPERA', 'Prueba de esfuerzo');
CALL MODIFICAR_CITA(10, 'ATENDIDA', 'ATENDIDO', 'Consulta por arritmia');
CALL MODIFICAR_CITA(11, 'ATENDIDA', 'ATENDIDO', 'Revisión de lunares');
CALL MODIFICAR_CITA(12, 'ATENDIDA', 'ATENDIDO', 'Tratamiento acné');
CALL MODIFICAR_CITA(13, 'ATENDIDA', 'ATENDIDO', 'Consulta por eccema');
CALL MODIFICAR_CITA(14, 'ATENDIDA', 'ATENDIDO', 'Control de dermatitits');
CALL MODIFICAR_CITA(15, 'CANCELADA', 'EN_ESPERA', 'Caída de cabello');
CALL MODIFICAR_CITA(16, 'ATENDIDA', 'ATENDIDO', 'Control ginecológico anual');
CALL MODIFICAR_CITA(17, 'ATENDIDA', 'ATENDIDO', 'Resultados Papanicolau');
CALL MODIFICAR_CITA(18, 'ATENDIDA', 'ATENDIDO', 'Consulta prenatal');
CALL MODIFICAR_CITA(19, 'ATENDIDA', 'ATENDIDO', 'Planificación familiar');
CALL MODIFICAR_CITA(20, 'ATENDIDA', 'ATENDIDO', 'Ecografía de control');






-- Insertar Administradores
SET @id_admin := 0;
CALL INSERTAR_ADMINISTRADOR(@id_admin, 'Armando', 'Paredes', 'Estela', '10000001', 'aparedes@pazcitas.com', '1985-10-15', 'M');
CALL INSERTAR_ADMINISTRADOR(@id_admin, 'Beatriz', 'Flores', 'Del Campo', '10000002', 'bflores@pazcitas.com', '1990-04-25', 'F');
CALL INSERTAR_ADMINISTRADOR(@id_admin, 'César', 'Mendoza', 'Ríos', '10000003', 'cmendoza@pazcitas.com', '1978-12-01', 'M');
CALL INSERTAR_ADMINISTRADOR(@id_admin, 'Daniela', 'Salazar', 'Guerra', '10000004', 'dsalazar@pazcitas.com', '1992-07-18', 'F');
CALL INSERTAR_ADMINISTRADOR(@id_admin, 'Ernesto', 'Valdivia', 'Soto', '10000005', 'evaldivia@pazcitas.com', '1980-02-28', 'M');
CALL INSERTAR_ADMINISTRADOR(@id_admin, 'Fátima', 'Linares', 'Ponce', '10000006', 'flinares@pazcitas.com', '1995-11-30', 'F');






-- Insetar Cuentas

SET @id_cuenta := 0;

-- Creación de Cuentas para ADMINISTRADORES (Contraseña: admin123)
CALL INSERTAR_CUENTA(@id_cuenta, '10000001', 'admin123', 'ADMINISTRADOR', 53);
CALL INSERTAR_CUENTA(@id_cuenta, '10000002', 'admin123', 'ADMINISTRADOR', 54);
CALL INSERTAR_CUENTA(@id_cuenta, '10000003', 'admin123', 'ADMINISTRADOR', 55);
CALL INSERTAR_CUENTA(@id_cuenta, '10000004', 'admin123', 'ADMINISTRADOR', 56);
CALL INSERTAR_CUENTA(@id_cuenta, '10000005', 'admin123', 'ADMINISTRADOR', 57);
CALL INSERTAR_CUENTA(@id_cuenta, '10000006', 'admin123', 'ADMINISTRADOR', 58);

-- Creación de Cuentas para MÉDICOS (Contraseña: medico123)
CALL INSERTAR_CUENTA(@id_cuenta, '12345678', 'medico123', 'MÉDICO', 1);
CALL INSERTAR_CUENTA(@id_cuenta, '87654321', 'medico123', 'MÉDICO', 2);
CALL INSERTAR_CUENTA(@id_cuenta, '11223344', 'medico123', 'MÉDICO', 3);
CALL INSERTAR_CUENTA(@id_cuenta, '44332211', 'medico123', 'MÉDICO', 4);
CALL INSERTAR_CUENTA(@id_cuenta, '55667788', 'medico123', 'MÉDICO', 5);
CALL INSERTAR_CUENTA(@id_cuenta, '88776655', 'medico123', 'MÉDICO', 6);
CALL INSERTAR_CUENTA(@id_cuenta, '99887766', 'medico123', 'MÉDICO', 7);
CALL INSERTAR_CUENTA(@id_cuenta, '66778899', 'medico123', 'MÉDICO', 8);
CALL INSERTAR_CUENTA(@id_cuenta, '10102020', 'medico123', 'MÉDICO', 9);
CALL INSERTAR_CUENTA(@id_cuenta, '30304040', 'medico123', 'MÉDICO', 10);
CALL INSERTAR_CUENTA(@id_cuenta, '50506060', 'medico123', 'MÉDICO', 11);
CALL INSERTAR_CUENTA(@id_cuenta, '70708080', 'medico123', 'MÉDICO', 12);
CALL INSERTAR_CUENTA(@id_cuenta, '90901010', 'medico123', 'MÉDICO', 13);
CALL INSERTAR_CUENTA(@id_cuenta, '21213131', 'medico123', 'MÉDICO', 14);
CALL INSERTAR_CUENTA(@id_cuenta, '41415151', 'medico123', 'MÉDICO', 15);
CALL INSERTAR_CUENTA(@id_cuenta, '61617171', 'medico123', 'MÉDICO', 16);
CALL INSERTAR_CUENTA(@id_cuenta, '81819191', 'medico123', 'MÉDICO', 17);
CALL INSERTAR_CUENTA(@id_cuenta, '13132424', 'medico123', 'MÉDICO', 18);
CALL INSERTAR_CUENTA(@id_cuenta, '35354646', 'medico123', 'MÉDICO', 19);
CALL INSERTAR_CUENTA(@id_cuenta, '57576868', 'medico123', 'MÉDICO', 20);
CALL INSERTAR_CUENTA(@id_cuenta, '79798080', 'medico123', 'MÉDICO', 21);
CALL INSERTAR_CUENTA(@id_cuenta, '12122323', 'medico123', 'MÉDICO', 22);
CALL INSERTAR_CUENTA(@id_cuenta, '34344545', 'medico123', 'MÉDICO', 23);
CALL INSERTAR_CUENTA(@id_cuenta, '56566767', 'medico123', 'MÉDICO', 24);
CALL INSERTAR_CUENTA(@id_cuenta, '78788989', 'medico123', 'MÉDICO', 25);
CALL INSERTAR_CUENTA(@id_cuenta, '14142525', 'medico123', 'MÉDICO', 26);
CALL INSERTAR_CUENTA(@id_cuenta, '36364747', 'medico123', 'MÉDICO', 27);
CALL INSERTAR_CUENTA(@id_cuenta, '58586969', 'medico123', 'MÉDICO', 28);
CALL INSERTAR_CUENTA(@id_cuenta, '70708181', 'medico123', 'MÉDICO', 29);
CALL INSERTAR_CUENTA(@id_cuenta, '92920303', 'medico123', 'MÉDICO', 30);
CALL INSERTAR_CUENTA(@id_cuenta, '15152626', 'medico123', 'MÉDICO', 31);
CALL INSERTAR_CUENTA(@id_cuenta, '37374848', 'medico123', 'MÉDICO', 32);
CALL INSERTAR_CUENTA(@id_cuenta, '59597070', 'medico123', 'MÉDICO', 33);
CALL INSERTAR_CUENTA(@id_cuenta, '71718282', 'medico123', 'MÉDICO', 34);
CALL INSERTAR_CUENTA(@id_cuenta, '93930404', 'medico123', 'MÉDICO', 35);
CALL INSERTAR_CUENTA(@id_cuenta, '16162727', 'medico123', 'MÉDICO', 36);
CALL INSERTAR_CUENTA(@id_cuenta, '38384949', 'medico123', 'MÉDICO', 37);
CALL INSERTAR_CUENTA(@id_cuenta, '60607171', 'medico123', 'MÉDICO', 38);
CALL INSERTAR_CUENTA(@id_cuenta, '82829393', 'medico123', 'MÉDICO', 39);
CALL INSERTAR_CUENTA(@id_cuenta, '17172828', 'medico123', 'MÉDICO', 40);
CALL INSERTAR_CUENTA(@id_cuenta, '39395050', 'medico123', 'MÉDICO', 41);
CALL INSERTAR_CUENTA(@id_cuenta, '61617272', 'medico123', 'MÉDICO', 42);

-- Creación de Cuentas para PACIENTES (Contraseña: paciente123)
CALL INSERTAR_CUENTA(@id_cuenta, '70123456', 'paciente123', 'PACIENTE', 43);
CALL INSERTAR_CUENTA(@id_cuenta, '71234567', 'paciente123', 'PACIENTE', 44);
CALL INSERTAR_CUENTA(@id_cuenta, '72345678', 'paciente123', 'PACIENTE', 45);
CALL INSERTAR_CUENTA(@id_cuenta, '73456789', 'paciente123', 'PACIENTE', 46);
CALL INSERTAR_CUENTA(@id_cuenta, '74567890', 'paciente123', 'PACIENTE', 47);
CALL INSERTAR_CUENTA(@id_cuenta, '75678901', 'paciente123', 'PACIENTE', 48);
CALL INSERTAR_CUENTA(@id_cuenta, '76789012', 'paciente123', 'PACIENTE', 49);
CALL INSERTAR_CUENTA(@id_cuenta, '77890123', 'paciente123', 'PACIENTE', 50);
CALL INSERTAR_CUENTA(@id_cuenta, '78901234', 'paciente123', 'PACIENTE', 51);
CALL INSERTAR_CUENTA(@id_cuenta, '79012345', 'paciente123', 'PACIENTE', 52);







-- Creación de Historiales Médicos para cada Paciente
SET @id_historial := 0;
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 43); -- Paciente: Elena Vasquez
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 44); -- Paciente: Marco Solano
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 45); -- Paciente: Lucia Mendoza
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 46); -- Paciente: Bruno Castillo
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 47); -- Paciente: Carla Flores
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 48); -- Paciente: David Gomez
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 49); -- Paciente: Sofia Quispe
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 50); -- Paciente: Alejandro Vargas
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 51); -- Paciente: Valeria Rios
CALL INSERTAR_HISTORIAL_MEDICO(@id_historial, 52); -- Paciente: Mateo Ortiz


-- Creación del Catálogo de Medicamentos (30 items)

SET @id_medicamento := 0;
-- Analgésicos y Antiinflamatorios
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Paracetamol', 'Tabletas 500 mg', 200);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Ibuprofeno', 'Tabletas 400 mg', 150);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Naproxeno', 'Tabletas 550 mg', 120);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Diclofenaco', 'Gel 1% - Tubo 60g', 80);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Aspirina', 'Tabletas 100 mg', 250);
-- Antibióticos
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Amoxicilina', 'Cápsulas 500 mg', 180);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Azitromicina', 'Tabletas 500 mg', 100);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Ciprofloxacino', 'Tabletas 500 mg', 90);
-- Antialérgicos
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Loratadina', 'Tabletas 10 mg', 300);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Cetirizina', 'Gotas 10 mg/ml - Frasco 15ml', 100);
-- Gastrointestinales
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Omeprazol', 'Cápsulas 20 mg', 220);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Loperamida', 'Tabletas 2 mg', 75);
-- Tratamientos Crónicos
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Metformina', 'Tabletas 850 mg', 160);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Losartán', 'Tabletas 50 mg', 190);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Atorvastatina', 'Tabletas 20 mg', 140);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Salbutamol', 'Inhalador 100 mcg', 110);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Enalapril', 'Tabletas 10 mg', 130);
-- Vitaminas y Suplementos
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Vitamina C', 'Tabletas efervescentes 1g', 95);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Complejo B', 'Tabletas', 150);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Ácido Fólico', 'Tabletas 5 mg', 120);
-- Tópicos
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Clotrimazol', 'Crema 1% - Tubo 20g', 85);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Hidrocortisona', 'Crema 1% - Tubo 15g', 70);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Mupirocina', 'Ungüento 2% - Tubo 15g', 60);
-- Otros
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Melatonina', 'Tabletas 3 mg', 50);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Dextrometorfano', 'Jarabe 120 ml', 100);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Ambroxol', 'Jarabe 15mg/5ml - Frasco 120ml', 115);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Sertralina', 'Tabletas 50 mg', 80);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Clonazepam', 'Gotas 2.5 mg/ml - Frasco 20ml', 40);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Furosemida', 'Tabletas 40 mg', 130);
CALL INSERTAR_MEDICAMENTO(@id_medicamento, 'Hierro Polimaltosado', 'Gotas - Frasco 30ml', 90);







-- --- Creación de recetas y notas clínicas para las citas marcadas como ATENDIDAS ---
USE CLINICA_PAZCITAS;
SET @id_receta := 0, @id_nota := 0, @id_receta_med := 0;

-- Cita 1 (ID Paciente: 43, ID Historial: 1)
CALL INSERTAR_RECETA(@id_receta, 'Tomar una tableta al día con el desayuno por 30 días.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 19, 1); -- Complejo B
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente acude a control anual pediátrico.', 'Desarrollo psicomotor adecuado.', 'Se refuerzan pautas de alimentación. Se receta suplemento vitamínico.', 1, @id_receta, 1);

-- Cita 2 (ID Paciente: 44, ID Historial: 2)
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente acude para completar esquema de vacunación.', 'Esquema de vacunación completado.', 'Se administran vacunas correspondientes a la edad sin incidencias. Se indica observación por 24h.', 2, NULL, 2);

-- Cita 4 (ID Paciente: 46, ID Historial: 4)
CALL INSERTAR_RECETA(@id_receta, 'Dar 5ml cada 8 horas por 3 días si la fiebre supera 38.5°C.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 1, 1); -- Paracetamol
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente pediátrico con fiebre de 24h de evolución.', 'Faringoamigdalitis viral.', 'Garganta congestiva sin placas. Se indica manejo sintomático, hidratación y reposo. Signos de alarma explicados.', 4, @id_receta, 4);

-- Cita 5 (ID Paciente: 47, ID Historial: 5)
CALL INSERTAR_RECETA(@id_receta, 'Tomar una tableta por la noche durante 10 días.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 9, 1); -- Loratadina
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente consulta por estornudos y congestión nasal estacional.', 'Rinitis alérgica.', 'Se prescribe antihistamínico y se recomienda evitar alérgenos conocidos.', 5, @id_receta, 5);

-- Cita 6 (ID Paciente: 48, ID Historial: 6)
CALL INSERTAR_RECETA(@id_receta, 'Una tableta diaria en ayunas de por vida.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 14, 1); -- Losartán
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente en chequeo cardiológico de rutina.', 'Hipertensión Arterial Esencial (Grado 1).', 'Paciente controlado. Se mantiene tratamiento y se recomienda reducir consumo de sodio.', 6, @id_receta, 6);

-- Cita 7 (ID Paciente: 49, ID Historial: 7)
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Revisión de resultados de Holter de 24 horas.', 'Ritmo sinusal sin arritmias significativas.', 'El estudio no muestra arritmias que expliquen los síntomas. Se sugiere control de estrés.', 7, NULL, 7);

-- Cita 8 (ID Paciente: 50, ID Historial: 8)
CALL INSERTAR_RECETA(@id_receta, 'Tomar una tableta al día con el almuerzo.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 17, 1); -- Enalapril
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Control de presión arterial.', 'Hipertensión Arterial controlada.', 'Presión en rango meta. Paciente adherente al tratamiento. Continuar con misma dosis.', 8, @id_receta, 8);

-- Cita 10 (ID Paciente: 52, ID Historial: 10)
CALL INSERTAR_RECETA(@id_receta, 'Tomar media tableta al día.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 5, 1); -- Aspirina 100mg
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente refiere palpitaciones ocasionales.', 'Fibrilación Auricular Paroxística.', 'Se indica antiagregante para prevención de ACV. Se solicita ecocardiograma.', 10, @id_receta, 10);

-- Cita 11 (ID Paciente: 43, ID Historial: 1)
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente consulta por lunar de reciente aparición en espalda.', 'Nevo melanocítico benigno.', 'No se observan criterios de malignidad. Se indica auto-monitoreo y control en 1 año.', 11, NULL, 1);

-- Cita 12 (ID Paciente: 44, ID Historial: 2)
CALL INSERTAR_RECETA(@id_receta, 'Aplicar una capa fina en áreas afectadas por la noche.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 23, 1); -- Mupirocina
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente adolescente consulta por acné.', 'Acné vulgar moderado.', 'Se inicia tratamiento tópico y se dan recomendaciones de higiene facial.', 12, @id_receta, 2);

-- Cita 13 (ID Paciente: 45, ID Historial: 3)
CALL INSERTAR_RECETA(@id_receta, 'Aplicar en lesiones 2 veces al día por 7 días.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 22, 1); -- Hidrocortisona Crema
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente con placas eritematosas y pruriginosas en pliegues.', 'Dermatitis atópica (Eccema).', 'Se indica corticoide tópico de baja potencia y emolientes.', 13, @id_receta, 3);

-- Cita 14 (ID Paciente: 46, ID Historial: 4)
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Control de dermatitis seborreica.', 'Dermatitis Seborreica controlada.', 'Lesiones en remisión. Se recomienda continuar con shampoo medicado de forma intermitente.', 14, NULL, 4);

-- Cita 16 (ID Paciente: 48, ID Historial: 6)
CALL INSERTAR_RECETA(@id_receta, 'Tomar una cápsula diaria por 3 meses.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 20, 1); -- Ácido Fólico
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Control ginecológico anual de rutina.', 'Paciente sana, sin hallazgos patológicos.', 'Resultados de Papanicolau normales. Se receta ácido fólico como prevención.', 16, @id_receta, 6);

-- Cita 17 (ID Paciente: 49, ID Historial: 7)
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Entrega de resultados de Papanicolau.', 'Resultado: Negativo para lesión intraepitelial o malignidad.', 'Se comunican resultados normales a la paciente. Se indica control anual.', 17, NULL, 7);

-- Cita 18 (ID Paciente: 50, ID Historial: 8)
CALL INSERTAR_RECETA(@id_receta, 'Tomar 1 tableta de cada uno al día con las comidas.');
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 20, 1); -- Ácido Fólico
CALL INSERTAR_RECETA_MEDICAMENTO(@id_receta_med, @id_receta, 30, 1); -- Hierro Polimaltosado
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Consulta prenatal, 14 semanas de gestación.', 'Embarazo intrauterino de 14 semanas, normoevolutivo.', 'Feto activo con latido presente. Se indican suplementos y se solicita ecografía morfológica.', 18, @id_receta, 8);

-- Cita 19 (ID Paciente: 51, ID Historial: 9)
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Paciente solicita asesoría en métodos anticonceptivos.', 'Asesoría en Planificación Familiar.', 'Se explican opciones, ventajas y desventajas. Paciente elige iniciar anticonceptivos orales. Se entrega receta aparte.', 19, NULL, 9);

-- Cita 20 (ID Paciente: 52, ID Historial: 10)
CALL INSERTAR_NOTA_CLINICA(@id_nota, 'Revisión de ecografía obstétrica.', 'Ecografía morfológica sin hallazgos patológicos.', 'Biometría fetal acorde a edad gestacional. Sin marcadores de aneuploidía. Todo normal.', 20, NULL, 10);











-- Pagos
SET @id_pago := 0;

-- Citas de Mayo y Junio (ATENDIDAS y CANCELADAS)
CALL INSERTAR_PAGO(@id_pago, '2025-05-26', 150.00, 150.00, 0.00, 'CANCELADO', 1, 1);
CALL INSERTAR_PAGO(@id_pago, '2025-05-27', 150.00, 128.25, 21.75, 'CANCELADO', 2, 2);
CALL INSERTAR_PAGO(@id_pago, '2025-05-28', 50.00, 35.00, 15.00, 'CANCELADO', 3, 3);
CALL INSERTAR_PAGO(@id_pago, '2025-05-29', 150.00, 75.00, 75.00, 'CANCELADO', 4, 4);
CALL INSERTAR_PAGO(@id_pago, '2025-05-30', 150.00, 0.00, 150.00, 'CANCELADO', 5, 5);
CALL INSERTAR_PAGO(@id_pago, '2025-05-26', 150.00, 150.00, 0.00, 'CANCELADO', 1, 6);
CALL INSERTAR_PAGO(@id_pago, '2025-05-27', 150.00, 128.25, 21.75, 'CANCELADO', 2, 7);
CALL INSERTAR_PAGO(@id_pago, '2025-05-28', 150.00, 105.00, 45.00, 'CANCELADO', 3, 8);
CALL INSERTAR_PAGO(@id_pago, '2025-05-29', 50.00, 50.00, 0.00, 'CANCELADO', 1, 9);
CALL INSERTAR_PAGO(@id_pago, '2025-05-30', 150.00, 0.00, 150.00, 'CANCELADO', 5, 10);
CALL INSERTAR_PAGO(@id_pago, '2025-06-02', 150.00, 150.00, 0.00, 'CANCELADO', 1, 11);
CALL INSERTAR_PAGO(@id_pago, '2025-06-03', 150.00, 128.25, 21.75, 'CANCELADO', 2, 12);
CALL INSERTAR_PAGO(@id_pago, '2025-06-04', 150.00, 105.00, 45.00, 'CANCELADO', 3, 13);
CALL INSERTAR_PAGO(@id_pago, '2025-06-05', 150.00, 75.00, 75.00, 'CANCELADO', 4, 14);
CALL INSERTAR_PAGO(@id_pago, '2025-06-06', 50.00, 0.00, 50.00, 'CANCELADO', 5, 15);
CALL INSERTAR_PAGO(@id_pago, '2025-06-02', 150.00, 150.00, 0.00, 'CANCELADO', 1, 16);
CALL INSERTAR_PAGO(@id_pago, '2025-06-03', 150.00, 128.25, 21.75, 'CANCELADO', 2, 17);
CALL INSERTAR_PAGO(@id_pago, '2025-06-04', 150.00, 105.00, 45.00, 'CANCELADO', 3, 18);
CALL INSERTAR_PAGO(@id_pago, '2025-06-05', 150.00, 150.00, 0.00, 'CANCELADO', 1, 19);
CALL INSERTAR_PAGO(@id_pago, '2025-06-06', 150.00, 0.00, 150.00, 'CANCELADO', 5, 20);

-- Citas de Julio y Agosto (PROGRAMADAS)
CALL INSERTAR_PAGO(@id_pago, '2025-07-07', 150.00, 150.00, 0.00, 'CANCELADO', 1, 21);
CALL INSERTAR_PAGO(@id_pago, '2025-07-08', 150.00, 128.25, 21.75, 'CANCELADO', 2, 22);
CALL INSERTAR_PAGO(@id_pago, '2025-07-09', 150.00, 105.00, 45.00, 'CANCELADO', 3, 23);
CALL INSERTAR_PAGO(@id_pago, '2025-07-10', 150.00, 75.00, 75.00, 'CANCELADO', 4, 24);
CALL INSERTAR_PAGO(@id_pago, '2025-07-11', 150.00, 0.00, 150.00, 'CANCELADO', 5, 25);
CALL INSERTAR_PAGO(@id_pago, '2025-07-07', 150.00, 150.00, 0.00, 'CANCELADO', 1, 26);
CALL INSERTAR_PAGO(@id_pago, '2025-07-08', 150.00, 128.25, 21.75, 'CANCELADO', 2, 27);
CALL INSERTAR_PAGO(@id_pago, '2025-07-09', 150.00, 105.00, 45.00, 'CANCELADO', 3, 28);
CALL INSERTAR_PAGO(@id_pago, '2025-07-10', 150.00, 150.00, 0.00, 'CANCELADO', 1, 29);
CALL INSERTAR_PAGO(@id_pago, '2025-07-11', 150.00, 0.00, 150.00, 'CANCELADO', 5, 30);
CALL INSERTAR_PAGO(@id_pago, '2025-07-14', 150.00, 150.00, 0.00, 'CANCELADO', 1, 31);
CALL INSERTAR_PAGO(@id_pago, '2025-07-15', 150.00, 128.25, 21.75, 'CANCELADO', 2, 32);
CALL INSERTAR_PAGO(@id_pago, '2025-07-16', 150.00, 105.00, 45.00, 'CANCELADO', 3, 33);
CALL INSERTAR_PAGO(@id_pago, '2025-07-17', 150.00, 75.00, 75.00, 'CANCELADO', 4, 34);
CALL INSERTAR_PAGO(@id_pago, '2025-07-18', 150.00, 0.00, 150.00, 'CANCELADO', 5, 35);
CALL INSERTAR_PAGO(@id_pago, '2025-07-14', 150.00, 150.00, 0.00, 'CANCELADO', 1, 36);
CALL INSERTAR_PAGO(@id_pago, '2025-07-15', 150.00, 128.25, 21.75, 'CANCELADO', 2, 37);
CALL INSERTAR_PAGO(@id_pago, '2025-07-16', 150.00, 105.00, 45.00, 'CANCELADO', 3, 38);
CALL INSERTAR_PAGO(@id_pago, '2025-07-17', 150.00, 150.00, 0.00, 'CANCELADO', 1, 39);
CALL INSERTAR_PAGO(@id_pago, '2025-07-18', 150.00, 0.00, 150.00, 'CANCELADO', 5, 40);
CALL INSERTAR_PAGO(@id_pago, '2025-07-21', 150.00, 150.00, 0.00, 'CANCELADO', 1, 41);
CALL INSERTAR_PAGO(@id_pago, '2025-07-22', 150.00, 128.25, 21.75, 'CANCELADO', 2, 42);
CALL INSERTAR_PAGO(@id_pago, '2025-07-23', 150.00, 105.00, 45.00, 'CANCELADO', 3, 43);
CALL INSERTAR_PAGO(@id_pago, '2025-07-24', 150.00, 75.00, 75.00, 'CANCELADO', 4, 44);
CALL INSERTAR_PAGO(@id_pago, '2025-07-25', 150.00, 0.00, 150.00, 'CANCELADO', 5, 45);
CALL INSERTAR_PAGO(@id_pago, '2025-07-21', 150.00, 150.00, 0.00, 'CANCELADO', 1, 46);
CALL INSERTAR_PAGO(@id_pago, '2025-07-22', 150.00, 128.25, 21.75, 'CANCELADO', 2, 47);
CALL INSERTAR_PAGO(@id_pago, '2025-07-23', 150.00, 105.00, 45.00, 'CANCELADO', 3, 48);
CALL INSERTAR_PAGO(@id_pago, '2025-07-24', 150.00, 150.00, 0.00, 'CANCELADO', 1, 49);
CALL INSERTAR_PAGO(@id_pago, '2025-07-25', 150.00, 0.00, 150.00, 'CANCELADO', 5, 50);
CALL INSERTAR_PAGO(@id_pago, '2025-08-04', 150.00, 150.00, 0.00, 'CANCELADO', 1, 51);
CALL INSERTAR_PAGO(@id_pago, '2025-08-05', 150.00, 128.25, 21.75, 'CANCELADO', 2, 52);
CALL INSERTAR_PAGO(@id_pago, '2025-08-06', 150.00, 105.00, 45.00, 'CANCELADO', 3, 53);
CALL INSERTAR_PAGO(@id_pago, '2025-08-07', 150.00, 75.00, 75.00, 'CANCELADO', 4, 54);
CALL INSERTAR_PAGO(@id_pago, '2025-08-08', 150.00, 0.00, 150.00, 'CANCELADO', 5, 55);
CALL INSERTAR_PAGO(@id_pago, '2025-08-04', 150.00, 150.00, 0.00, 'CANCELADO', 1, 56);
CALL INSERTAR_PAGO(@id_pago, '2025-08-05', 150.00, 128.25, 21.75, 'CANCELADO', 2, 57);
CALL INSERTAR_PAGO(@id_pago, '2025-08-06', 150.00, 105.00, 45.00, 'CANCELADO', 3, 58);
CALL INSERTAR_PAGO(@id_pago, '2025-08-07', 150.00, 150.00, 0.00, 'CANCELADO', 1, 59);
CALL INSERTAR_PAGO(@id_pago, '2025-08-08', 150.00, 0.00, 150.00, 'CANCELADO', 5, 60);
CALL INSERTAR_PAGO(@id_pago, '2025-07-28', 150.00, 150.00, 0.00, 'CANCELADO', 1, 61);
CALL INSERTAR_PAGO(@id_pago, '2025-07-29', 150.00, 128.25, 21.75, 'CANCELADO', 2, 62);
CALL INSERTAR_PAGO(@id_pago, '2025-07-30', 150.00, 105.00, 45.00, 'CANCELADO', 3, 63);
CALL INSERTAR_PAGO(@id_pago, '2025-07-31', 150.00, 75.00, 75.00, 'CANCELADO', 4, 64);
CALL INSERTAR_PAGO(@id_pago, '2025-08-01', 150.00, 0.00, 150.00, 'CANCELADO', 5, 65);
CALL INSERTAR_PAGO(@id_pago, '2025-07-28', 150.00, 150.00, 0.00, 'CANCELADO', 1, 66);
CALL INSERTAR_PAGO(@id_pago, '2025-07-29', 150.00, 128.25, 21.75, 'CANCELADO', 2, 67);
CALL INSERTAR_PAGO(@id_pago, '2025-07-30', 150.00, 105.00, 45.00, 'CANCELADO', 3, 68);
CALL INSERTAR_PAGO(@id_pago, '2025-07-31', 150.00, 150.00, 0.00, 'CANCELADO', 1, 69);
CALL INSERTAR_PAGO(@id_pago, '2025-08-01', 150.00, 0.00, 150.00, 'CANCELADO', 5, 70);
CALL INSERTAR_PAGO(@id_pago, '2025-08-11', 150.00, 150.00, 0.00, 'CANCELADO', 1, 71);
CALL INSERTAR_PAGO(@id_pago, '2025-08-12', 150.00, 128.25, 21.75, 'CANCELADO', 2, 72);
CALL INSERTAR_PAGO(@id_pago, '2025-08-13', 150.00, 105.00, 45.00, 'CANCELADO', 3, 73);
CALL INSERTAR_PAGO(@id_pago, '2025-08-14', 150.00, 75.00, 75.00, 'CANCELADO', 4, 74);
CALL INSERTAR_PAGO(@id_pago, '2025-08-15', 150.00, 0.00, 150.00, 'CANCELADO', 5, 75);
CALL INSERTAR_PAGO(@id_pago, '2025-08-11', 150.00, 150.00, 0.00, 'CANCELADO', 1, 76);
CALL INSERTAR_PAGO(@id_pago, '2025-08-12', 150.00, 128.25, 21.75, 'CANCELADO', 2, 77);
CALL INSERTAR_PAGO(@id_pago, '2025-08-13', 150.00, 105.00, 45.00, 'CANCELADO', 3, 78);
CALL INSERTAR_PAGO(@id_pago, '2025-08-14', 150.00, 150.00, 0.00, 'CANCELADO', 1, 79);
CALL INSERTAR_PAGO(@id_pago, '2025-08-15', 150.00, 0.00, 150.00, 'CANCELADO', 5, 80);
CALL INSERTAR_PAGO(@id_pago, '2025-08-18', 150.00, 150.00, 0.00, 'CANCELADO', 1, 81);
CALL INSERTAR_PAGO(@id_pago, '2025-08-19', 150.00, 128.25, 21.75, 'CANCELADO', 2, 82);
CALL INSERTAR_PAGO(@id_pago, '2025-08-21', 150.00, 105.00, 45.00, 'CANCELADO', 3, 83);
CALL INSERTAR_PAGO(@id_pago, '2025-08-25', 150.00, 75.00, 75.00, 'CANCELADO', 4, 84);
CALL INSERTAR_PAGO(@id_pago, '2025-08-26', 150.00, 0.00, 150.00, 'CANCELADO', 5, 85);