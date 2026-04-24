create database tp1;
use tp1;
-- -----------------------------------------------------
-- Table piezas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS piezas (
  id_pieza INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(100) NULL,
  PRIMARY KEY (id_pieza)
  );


-- -----------------------------------------------------
-- Table operarios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS operarios (
  id_operario INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  dni CHAR(8) NOT NULL,
  fecha_ingreso DATE NOT NULL,
  PRIMARY KEY (id_operario),
  constraint uq_dni unique(dni)
);


-- -----------------------------------------------------
-- Table importadores
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS importadores (
  id_importador INT NOT NULL AUTO_INCREMENT,
  nombre_empresa VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  email VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_importador)
  );


-- -----------------------------------------------------
-- Table televisores
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS televisores (
  id_televisor INT NOT NULL AUTO_INCREMENT,
  marca VARCHAR(45) NOT NULL,
  modelo VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_televisor)
  );


-- -----------------------------------------------------
-- Table facturas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS facturas (
  id_factura INT NOT NULL AUTO_INCREMENT,
  id_importador INT NOT NULL,
  id_pieza INT NOT NULL,
  fecha DATETIME NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (id_factura),
  CONSTRAINT fk_importadores_has_piezas_importadores
    FOREIGN KEY (id_importador)
    REFERENCES importadores (id_importador)
    ON DELETE cascade
    ON UPDATE cascade,
  CONSTRAINT fk_importadores_has_piezas_piezas1
    FOREIGN KEY (id_pieza)
    REFERENCES piezas (id_pieza)
    ON DELETE cascade
    ON UPDATE cascade
    );


-- -----------------------------------------------------
-- Table fichas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS fichas (
  id_ficha INT NOT NULL AUTO_INCREMENT,
  id_operario INT NOT NULL,
  id_pieza INT NOT NULL,
  fecha DATE NOT NULL,
  cantidad INT NOT NULL,
  PRIMARY KEY (id_ficha),
  CONSTRAINT fk_operarios_has_piezas_operarios1
    FOREIGN KEY (id_operario)
    REFERENCES operarios (id_operario)
    ON DELETE cascade
    ON UPDATE cascade,
  CONSTRAINT fk_operarios_has_piezas_piezas1
    FOREIGN KEY (id_pieza)
    REFERENCES piezas (id_pieza)
    ON DELETE cascade
    ON UPDATE cascade
    );


-- -----------------------------------------------------
-- Table mapas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mapas (
  id_mapa INT NOT NULL AUTO_INCREMENT,
  id_televisor INT NOT NULL,
  id_pieza INT NOT NULL,
  posicion VARCHAR(100) NULL,
  cantidad INT NOT NULL,
  PRIMARY KEY (id_mapa),
  CONSTRAINT fk_televisores_has_piezas_televisores1
    FOREIGN KEY (id_televisor)
    REFERENCES televisores (id_televisor)
    ON DELETE cascade
    ON UPDATE cascade,
  CONSTRAINT fk_televisores_has_piezas_piezas1
    FOREIGN KEY (id_pieza)
    REFERENCES piezas (id_pieza)
    ON DELETE cascade
    ON UPDATE cascade
    );
    
    --------------------------------------------------------------------------------------------------
INSERT INTO piezas (nombre, descripcion) VALUES
('Pantalla LED', 'Pantalla principal del televisor'),
('Placa madre', 'Controla el funcionamiento general'),
('Fuente de poder', 'Suministro de energia'),
('Parlantes', 'Salida de audio'),
('Control remoto', 'Dispositivo de control');

INSERT INTO operarios (nombre, apellido, dni, fecha_ingreso) VALUES
('Juan', 'Perez', '12345678', '2020-01-10'),
('Maria', 'Gomez', '23456789', '2019-03-15'),
('Carlos', 'Lopez', '34567890', '2021-07-20'),
('Ana', 'Martinez', '45678901', '2018-11-05'),
('Luis', 'Fernandez', '56789012', '2022-02-01');

INSERT INTO importadores (nombre_empresa, telefono, email) VALUES
('TechImport SA', '111111111', 'contacto@techimport.com'),
('GlobalParts', '222222222', 'info@globalparts.com'),
('Electronica Sur', '333333333', 'ventas@electrosur.com'),
('Importadora Norte', '444444444', 'norte@import.com'),
('Distribuciones LATAM', '555555555', 'latam@dist.com');

INSERT INTO televisores (marca, modelo) VALUES
('Samsung', 'A100'),
('LG', 'B200'),
('Sony', 'X300'),
('Philips', 'P400'),
('TCL', 'T500');

INSERT INTO facturas (id_importador, id_pieza, fecha, cantidad, precio_unitario) VALUES
(1, 1, '2024-01-10 10:00:00', 10, 15000.50),
(2, 2, '2024-02-12 12:30:00', 5, 20000.00),
(3, 3, '2024-03-05 09:15:00', 8, 12000.75),
(4, 4, '2024-04-18 14:45:00', 15, 5000.25),
(5, 5, '2024-05-20 16:20:00', 20, 3000.00);

INSERT INTO fichas (id_operario, id_pieza, fecha, cantidad) VALUES
(1, 1, '2024-01-11', 2),
(2, 2, '2024-01-12', 1),
(3, 3, '2024-01-13', 3),
(4, 4, '2024-01-14', 4),
(5, 5, '2024-01-15', 2);

INSERT INTO mapas (id_televisor, id_pieza, posicion, cantidad) VALUES
(1, 1, 'Frontal', 1),
(1, 2, 'Interno', 1),
(2, 3, 'Posterior', 1),
(3, 4, 'Laterales', 2),
(4, 5, 'Externo', 1);


-- Ver qué operario trabajó en qué pieza
SELECT 	o.nombre,
		p.nombre AS pieza,
		f.cantidad
FROM 	fichas f
JOIN	operarios o ON f.id_operario = o.id_operario
JOIN 	piezas p ON f.id_pieza = p.id_pieza;

-- Ver todos los televisores aunque no tengan piezas asignadas

SELECT 	t.marca,
		t.modelo,
		m.posicion,
		m.cantidad
FROM televisores t
LEFT JOIN mapas m ON t.id_televisor = m.id_televisor;