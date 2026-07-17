-- Active: 1776992206856@@127.0.0.1@3307@punto8
-- Trabajo Práctico Final Gestión de Base de Datos

-- 1 - Crear una función llamada "calcular_total_ventas" que tome como parámetro el mes y el año, y devuelva el total de ventas realizadas en ese mes. Verificar mediante consulta.
use pubs;

delimiter //
drop function if exists calcular_total_ventas//
create function calcular_total_ventas(mes int, anio int)

returns decimal(15,2)
deterministic
reads sql data
begin
    declare total_ventas decimal(15,2);
    select sum(t.price * s.qty)  into total_ventas
    from sales s
    join titles t on s.title_id = t.title_id
    where month(s.ord_date) = mes and year(s.ord_date) = anio;
    
    return total_ventas;
end//
delimiter;
select * from sales
select calcular_total_ventas(11, 1990) as total_ventas_noviembre_1990;


-- 2 - Crear una función llamada "obtener_nombre_empleado" que tome como parámetro el ID de un empleado y devuelva su nombre completo. Verificar mediante consulta.

delimiter //
drop function if exists obtener_nombre_empleado//
create function obtener_nombre_empleado(id_empleado int)
returns varchar(255) 
deterministic
reads sql data
begin
    declare nombre_completo varchar(255);
    select concat(fname, ' ', lname) into nombre_completo
    from employee
    where emp_id = id_empleado;
    
    return nombre_completo;
end//
delimiter;

select obtener_nombre_empleado(2) as nombre_empleado;

-- 3 - Crear un procedimiento almacenado llamado "obtener_promedio" que tome como parámetro de entrada el nombre de un curso y calcule el promedio de las calificaciones de todos los alumnos inscriptos en ese curso. Verificar mediante ejecución del procedimiento.

create database escuela;
use escuela;

CREATE TABLE alumnos (
    id_alumno INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100)
);

CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100)
);

CREATE TABLE inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_alumno INT,
    id_curso INT,
    calificacion DECIMAL(4,2),

    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

INSERT INTO alumnos (nombre, apellido) VALUES
('Juan', 'Pérez'),
('Ana', 'Gómez'),
('Pedro', 'López'),
('Lucía', 'Fernández'),
('Martín', 'Sosa');

INSERT INTO cursos (nombre) VALUES
('Base de Datos'),
('Programación'),
('Redes'),
('Sistemas Operativos'),
('Desarrollo Web');

INSERT INTO inscripciones (id_alumno, id_curso, calificacion) VALUES
(1, 2, 7.00),
(2, 2, 8.00),
(3, 3, 9.50),
(4, 4, 6.00),
(5, 5, 8.50);

delimiter //
drop procedure if exists obtener_promedio//
create procedure obtener_promedio(nombre_curso varchar(255))
begin
    declare promedio decimal(5,2);
    select avg(calificacion) into promedio
    from inscripciones
    where id_curso = (select id_curso from cursos where nombre = nombre_curso);
    
    select promedio as promedio_calificaciones;
end//
delimiter;
call obtener_promedio('Programación');

-- 4 - Crear un procedimiento almacenado "actualizar_stock" que tome como parámetros de entrada el código del producto y la cantidad a agregar al stock actual. El procedimiento debe actualizar el stock sumando la cantidad especificada al stock actual del producto correspondiente. Verificar mediante ejecución del procedimiento.

create database procedimientos;
use procedimientos;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE productos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(255) DEFAULT '',
  precio DECIMAL(10,2) NOT NULL,
  stock INT DEFAULT 0
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);


--  Insercion de registros
INSERT INTO clientes (nombre, direccion, telefono) VALUES
('Juan Pérez', 'Calle Falsa 123', '555-1234'),
('María García', 'Avenida Siempreviva 742', '555-5678'),
('Pedro González', 'Calle 13 No. 6-11', '555-9101'),
('Ana Hernández', 'Carrera 7 No. 32-60', '555-1212'),
('Luisa Rodríguez', 'Avenida Boyacá No. 64C-31', '555-1415'),
('Carlos Vargas', 'Carrera 15 No. 93-75', '555-1617'),
('Cristina Gómez', 'Carrera 45 No. 34-87', '555-1819'),
('Javier Torres', 'Calle 45 No. 23-09', '555-2022'),
('Laura Sánchez', 'Avenida 68 No. 56-18', '555-2225'),
('Andrés Díaz', 'Carrera 7 No. 11-07', '555-2428');


INSERT INTO productos (nombre, descripcion, precio, stock)
VALUES ('Laptop', 'Laptop HP 15", 8GB RAM, 1TB HDD', 1500.00, 10),
('Smartphone', 'Smartphone Samsung Galaxy S21', 1000.00, 15),
('Tablet', 'Tablet Apple iPad Pro 12.9"', 1200.00, 5),
('Monitor', 'Monitor LG 27", 1440p', 500.00, 20),
('Teclado', 'Teclado mecánico Logitech G513', 100.00, 30),
('Mouse', 'Mouse inalámbrico Logitech M720', 50.00, 25),
('Auriculares', 'Auriculares Sony WH-1000XM4', 300.00, 10),
('Altavoces', 'Altavoces Bose SoundLink Revolve+', 250.00, 8),
('Cámara', 'Cámara Canon EOS R5', 4000.00, 2),
('Impresora', 'Impresora multifunción HP LaserJet Pro M428fdw', 600.00, 5);


INSERT INTO ventas (cliente_id, producto_id, cantidad, fecha) VALUES
(1, 1, 5, '2022-01-01'),
(1, 2, 3, '2022-01-02'),
(2, 3, 2, '2022-01-03'),
(2, 1, 1, '2022-01-04'),
(3, 2, 4, '2022-01-05'),
(3, 3, 1, '2022-01-06'),
(4, 1, 3, '2022-01-07'),
(4, 2, 2, '2022-01-08'),
(5, 3, 6, '2022-01-09'),
(5, 1, 2, '2022-01-10');

CREATE PROCEDURE actualizar_stock(IN p_producto_id INT, IN p_cantidad INT, OUT p_nuevo_stock INT)
BEGIN
    UPDATE productos
    SET stock = stock + p_cantidad
    WHERE id = p_producto_id;

    SELECT stock INTO p_nuevo_stock
    FROM productos
    WHERE id = p_producto_id;
END;

call actualizar_stock(1, 4, @nuevo_stock);
SELECT @nuevo_stock AS nuevo_stock;

-- 5 - Crear una vista que muestre el título, el autor, el precio y la editorial de todos los libros de cocina de la base pubs.
use pubs;
CREATE VIEW v_libros_cocina AS
SELECT
    t.title AS Titulo,
    IFNULL(CONCAT(a.au_fname, ' ', a.au_lname), 'Sin autor') AS Autor,
    t.price AS Precio,
    p.pub_name AS Editorial
FROM titles t
LEFT JOIN titleauthor ta
    ON t.title_id = ta.title_id
LEFT JOIN authors a
    ON ta.au_id = a.au_id
JOIN publishers p
    ON t.pub_id = p.pub_id
WHERE t.type LIKE '%cook%';

select * from v_libros_cocina;

-- 6 – Dadas las siguientes tablas:
create database punto6;
use punto6;
CREATE TABLE fabricantes (
    id_fabricante INT PRIMARY KEY,
    nombre_fabricante VARCHAR(255) NOT NULL
);

INSERT INTO fabricantes (id_fabricante, nombre_fabricante)
VALUES(1, 'Fabricante A'),(2, 'Fabricante B'),(3, 'Fabricante C');

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    id_fabricante INT,
    nombre_producto VARCHAR(255) NOT NULL,
    fecha_lanzamiento DATE,
    FOREIGN KEY (id_fabricante) REFERENCES fabricantes(id_fabricante)
);

INSERT INTO productos (id_producto, id_fabricante, nombre_producto, fecha_lanzamiento)
VALUES(1, 1, 'Producto X', '2020-01-01'),(2, 2, 'Producto Y', '2019-12-01'), (3, 3, 'Producto Z', '2021-05-15'); 

-- a) Crear un índice compuesto en las columnas id_fabricante y nombre_producto de la tabla productos.

create index idx_productos_id_fabricante_nombreProducto on productos(id_fabricante, nombre_producto);

-- b) Crear un índice único en la columna id_producto de la tabla productos.

create unique index idx_productos_id_producto on productos(id_producto);

-- c) Modificar el índice idx_productos_id_fabricante_nombre para que sea  único en la columna id_fabricante.

alter table productos
drop index idx_productos_id_fabricante_nombreProducto,
add unique index idx_productos_id_fabricante_nombreProducto(id_fabricante, nombre_producto);

-- d) Crear un nuevo índice único en la columna id_fabricante

create unique index idx_productos_id_fabricante on productos(id_fabricante);

-- e) Eliminar el índice idx_productos_id_fabricante de la tabla productos
drop index idx_productos_id_fabricante on productos;

-- 7 -  Se desea modificar un sistema de gestión de empleados para incluir  un mecanismo automático que transfiera a los empleados que cumplen con ciertos criterios de jubilación a una tabla especializada llamada jubilados. 
-- Los criterios de jubilación son: los empleados deben tener 30 años o más de antigüedad y 65 años o más de edad. Además, se requiere que cualquier inserción en la tabla empleados que cumpla con estos criterios resulte en una inserción automática en la tabla jubilados.
create database punto7;
use punto7;

CREATE TABLE empleados (
  nombre VARCHAR(50) NOT NULL,
  edad INT NOT NULL,
  antiguedad INT NOT NULL
);


CREATE TABLE jubilados (
  nombre VARCHAR(50) NOT NULL,
  edad INT NOT NULL,
  antiguedad INT NOT NULL
);

DELIMITER //

CREATE TRIGGER trigger_jubilacion
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    IF NEW.edad >= 65 AND NEW.antiguedad >= 30 THEN
        INSERT INTO jubilados (nombre, edad, antiguedad)
        VALUES (NEW.nombre, NEW.edad, NEW.antiguedad);
    END IF;
END//
DELIMITER ;

INSERT INTO empleados VALUES ('Juan', 67, 35);
INSERT INTO empleados VALUES ('María', 60, 32);
INSERT INTO empleados VALUES ('Pedro', 70, 25);
INSERT INTO empleados VALUES ('Ana', 68, 31);

SELECT * FROM empleados;
SELECT * FROM jubilados;


-- 8 - Crear un procedimiento almacenado llamado ActualizarEmpleados que tome dos  parámetros de entrada:
-- codigo_empleado (VARCHAR, 10): El identificador del empleado a actualizar.
-- salario_actualizado (DECIMAL): El nuevo salario del empleado.
-- En el procedimiento, utilizar una transacción para realizar la actualización del salario del empleado:
-- Obtener la información actual del empleado especificado.
-- Verificar si el nuevo salario es válido (no puede ser menor que el salario actual).
-- Si el salario es válido, realiza la actualización del salario del empleado.
-- Si el salario actualizado sería menor que el salario actual, muestra un mensaje al usuario indicando que la operación se cancela y realiza un rollback.
-- Llamar al procedimiento ActualizarEmpleados con diferentes valores de codigo_empleado y salario_actualizado, incluyendo casos donde el salario actualizado sería menor que el salario actual.
-- Verificar que el procedimiento funcione correctamente y que se muestren mensajes de error y se realice un rollback cuando corresponda.

create database punto8;
use punto8;

CREATE TABLE empleados (
    codigo_empleado VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL
);

INSERT INTO empleados (codigo_empleado, nombre, salario) VALUES
('EMP001', 'Juan Pérez', 250000.00),
('EMP002', 'María Gómez', 180000.00),
('EMP003', 'Carlos Díaz', 220000.00),
('EMP004', 'Ana López', 195000.00),
('EMP005', 'Pedro Ruiz', 210000.00);

delimiter //
create procedure ActualizarEmpleados(IN codigo_emp VARCHAR(10), IN salario_actualizado DECIMAL(10,2))
begin
    declare salario_actual DECIMAL(10,2);
    
    start transaction;
    
    select salario into salario_actual from empleados where codigo_empleado = codigo_emp;
    
    if salario_actualizado < salario_actual then
        rollback;
        select 'El salario actualizado es menor que el salario actual. Operación cancelada.' as mensaje;
    else
        update empleados set salario = salario_actualizado where codigo_empleado = codigo_emp;
        commit;
        select 'Salario actualizado correctamente.' as mensaje;
    end if;
end//
delimiter ;

select * from empleados;
--Actualizar
CALL ActualizarEmpleados('EMP002', 200000.00);

--rollback
CALL ActualizarEmpleados('EMP003', 180000.00);


-- 9 - Gestión de Usuarios

-- a) Crear un usuario sin privilegios específicos

create user 'max'@'localhost' identified by '123';

-- b) Crear un usuario con privilegios de lectura sobre la base pubs

create user 'elvis'@'localhost' identified by '123';

grant select on pubs.* to 'elvis'@'localhost';

REVOKE SELECT, INSERT, UPDATE, DELETE ON *.* FROM 'elvis'@'localhost';

-- c) Crear un usuario con privilegios de escritura sobre la base pubs

create user 'yamila'@'localhost' identified by '123';

grant insert on pubs.* to 'yamila'@'localhost';

REVOKE SELECT, INSERT, UPDATE, DELETE ON *.* FROM 'yamila'@'localhost';

-- d) Crear un usuario con todos los privilegios sobre la base pubs

create user 'jorge'@'localhost' identified by '123';

grant all privileges on pubs.* to 'jorge'@'localhost';

REVOKE all privileges ON pubs.* FROM 'jorge'@'localhost';

-- e) Crear un usuario con privilegios de lectura sobre la tabla titles

create user 'lautaro'@'localhost' identified by '123';

grant select on pubs.titles to 'lautaro'@'localhost';

REVOKE SELECT, INSERT, UPDATE, DELETE ON *.* FROM 'lautaro'@'localhost';

-- f) Eliminar al usuario que tiene todos los privilegios sobre la base pubs

drop user 'jorge'@'localhost';

-- g) Eliminar a dos usuarios a la vez

drop user 'lautaro'@'localhost', 'yamila'@'localhost';

-- h) Eliminar un usuario y sus privilegios asociados

drop user 'elvis'@'localhost';


-- i) Revisar los privilegios de un usuario

select * from mysql.user;

-- 10 – Gestor Mongo DB

-- a) Activar la base de datos "local" y luego imprimir las colecciones existentes.

use ('local');
db.getCollectionNames()


-- b) Activar la base de datos "test" y luego imprimir las colecciones existentes.

use ('test');
db.getCollectionNames()

-- c) Activar la base de datos "baseEjemplo2".
use ('baseEjemplo2');
-- d) Mostrar las colecciones existentes en la base de datos "baseEjemplo2".
use ('baseEjemplo2');
db.getCollectionNames()

-- e) Crear otra colección llamada usuarios donde almacenar dos documentos con los campos nombre y clave.

use ('baseEjemplo2');
db.createCollection('usuarios')

use ('baseEjemplo2');
item1 = {
    id_user : 1,
    Nombre : "Max" 
};

item2 = {
    id_user : 2,
    Nombre : "Elvis" 
};      

db.usuarios.insert([item1, item2]);

db.usuarios.find();


-- f) Mostrar nuevamente las colecciones existentes en la base de datos "baseEjemplo2".
use ('baseEjemplo2');
db.getCollectionNames()

-- En la base pubs:
-- g) Insertar 2 documentos en la colección clientes con '_id' no repetidos

use ('pubs');
item1 = {
    _id : 2,
    nombre : "Max Rodriguez",
    domicilio : 'Laguna y Lacarra m3. c17',
    provincia : 'Buenos Aires'
};

item2 = {
    _id : 3,
    nombre : "Elvis Morales",
    domicilio : 'Los Piletones c.10',
    provincia : 'Buenos Aires'
};    

db.clientes.insert([item1, item2]);

db.clientes.find();

-- h) Intentar insertar otro documento con clave repetida.

--no se puede porque lanza error por llave duplicada.
use ('pubs');
item3 = {
    _id : 2,
    nombre : "Yamila Suncion",
    domicilio : 'Castro Barros 1500',
    provincia : 'Buenos Aires'
};  

db.clientes.insert(item3);

db.clientes.find();

-- i) Mostrar todos los documentos de la colección libros.
use ('pubs');
db.libros.find();

-- j) Crear una base de datos llamada "blog".
use ('blog');
-- k) Agregar una colección llamada "posts" e insertar 1 documento con una estructura a su elección.

use ('blog');
db.createCollection('posts')

use('blog')
db.posts.insertOne({titulo : 'Introduccion a mongoDB',
                    contenido : 'MongoDB es una base de datos NoSQL orientada a documentos...',
                    autor : 'Juan Perez'
                    });


-- l) Mostrar todas las bases de datos actuales.
show dbs;

-- m) Eliminar la colección "posts"

use ('blog');
db.posts.drop()


use('blog')
db.getCollectionNames()

-- n) Eliminar la base de datos "blog" y mostrar las bases de datos existentes.

use ('blog');
db.dropDatabase()

show dbs;

-- 11 - A partir de la siguiente especificación deberá recolectar datos para poder diseñar una Base de Datos.  

-- a) Determinar las entidades relevantes al Sistema. 
Pieza 
Operario
m:n
toa -> Ficha

Pieza
Importador
m:n
toa -> Factura

Pieza
Televisor
m:n
toa -> Mapa

-- b) Determinar los atributos de cada entidad.
Pieza:
	- id_pieza (pk)
	- nombre
	- descripción

Operario:
	- id_operario (pk)
	- nombre
	- apellido
	- dni
	- fecha_ingreso

Importador:
	- id_importador (pk)
	- nombre_empresa
	- telefono
	- email

Televisor:
	- id_televisor
	- marca
	- modelo

Ficha :
-	id_ficha (pk)
-	id_pieza (fk)
-	id_operario (fk)
-	fecha
-	cantidad

Factura:
	- id_factura (pk)
	- id_pieza (fk)
	- id_importador (fk)
	- fecha
	- cantidad
	- precio_unitario

Mapa:
	- id_mapa (pk)
	- id_pieza (fk)
	- id_televisor (fk)
	- orden_ensamblado
	- posición
	- cantidad

-- c) Confeccionar el Diagrama de Entidad Relación (DER), junto al Diccionario de Datos

--EL DIAGRAMA ESTA COMO IMAGEN FUERA DE ESTE ARCHIVO
Pieza: @id_pieza  + nombre + descripción

Operario: @id_operario + nombre + apellido + dni + fecha_ingreso

Importador: @id_importador + nombre_empresa + teléfono + email

Televisor: @id_televisor + marca + modelo 

Ficha : @id_ficha  + id_pieza + id_operario + fecha + cantidad

Factura: @id_factura  + id_pieza + id_importador + fecha + cantidad + precio_unitario

Mapa: @id_mapa + id_pieza + id_televisor +  orden_ensamblado + posición + cantidad

-- d) Realizar el Diagrama de Tablas e implementar en código SQL (puede utilizar cualquier Gestor) la Base de Datos.

-- EL DIAGRAMA DE TABLAS ESTA EN UNA IMAGEN FUERA DE ESTE ARCHIVO
create database televisores;
use televisores;
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


-- e) Crear al menos 2 consultas relacionadas para poder probar la Base de Datos.

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


-- Esta empresa se encuentra ubicada en Hong Kong y se dedica a la fabricación de Smart TV.

-- Las componentes de los TV pueden ser comprados a un importador, en tal caso la compra viene acompañada de una orden, otros componentes son fabricados en la empresa, para lo cual esos componentes tienen asignado un empleado que se dedica exclusivamente a un tipo de componente, aunque un componente puede ser fabricado por más de un empleado, el empleado completa una hoja de trabajo con la cantidad fabricada y la fecha.

-- Los diferentes modelos de Smart TV tienen de 275 a 430 componentes, aunque un componente puede estar incorporado en más de un TV, existe un mapa de armado para cada modelo de TV donde se indica la ubicación y el orden de los componentes.


