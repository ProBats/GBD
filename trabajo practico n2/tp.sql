drop database tpGBD;
SET FOREIGN_KEY_CHECKS=1;

create database tpGBD;
use tpGBD;

create table if not exists editoriales(
        id_editorial int not null auto_increment primary key,
        nombre_editorial varchar(50)
)engine=innodb;

create table if not exists empleados(
    id_empleado int not null auto_increment primary key,
    nombre_empleado varchar(70),
    id_editorial int,
    Foreign Key fk_editorial(id_editorial) REFERENCES editoriales(id_editorial)
    on delete cascade on update cascade
)engine=innodb;

create table if not exists libros(
    id_libro int not null auto_increment primary key,
    titulo_libro varchar(100),
    id_editorial int,
    Foreign Key fk_editorial(id_editorial) REFERENCES editoriales(id_editorial)
    on delete cascade on update cascade
)engine=innodb;

INSERT INTO editoriales (id_editorial, nombre_editorial)
VALUES
    (1, 'Editorial Planeta'),
    (2, 'Editorial Santillana'),
    (3, 'Editorial Anaya'),
    (4, 'Editorial Alfaguara'),
    (5, 'Editorial SM'),
    (6, 'Editorial Fondo de Cultura Económica'),
    (7, 'Editorial Siglo XXI'),
    (8, 'Editorial Cátedra'),
    (9, 'Editorial Tecnos'),
    (10, 'Editorial Ariel');


INSERT INTO empleados (id_empleado, nombre_empleado, id_editorial)
VALUES
    (1, 'Juan Pérez', 1),
    (2, 'María Rodríguez', 1),
    (3, 'Pedro López', 2),
    (4, 'Ana Martínez', 2),
    (5, 'Carlos García', 3),
    (6, 'Laura González', 3),
    (7, 'Luis Fernández', 4),
    (8, 'Elena Sánchez', 4),
    (9, 'Javier Ruiz', 5),
    (10, 'Sofía Torres', 5);


INSERT INTO libros (id_libro, titulo_libro, id_editorial)
VALUES
    (1, 'Cien años de soledad', 1),
    (2, 'Don Quijote de la Mancha', 1),
    (3, 'La sombra del viento', 2),
    (4, 'Rayuela', 2),
    (5, 'Crónica de una muerte anunciada', 3),
    (6, 'Los detectives salvajes', 3),
    (7, 'Ficciones', 4),
    (8, 'La casa de los espíritus', 4),
    (9, 'La ciudad y los perros', 5),
    (10, 'Cien años de soledad', 5);

    select * from editoriales;
    select * from empleados;
    select * from libros;

--Ejercicios sobre integridad referencial:

--1.Eliminar una editorial: Si se elimina una editorial de la tabla editoriales, ¿qué sucede con los libros asociados? Escriba una consulta SQL que elimine una editorial y sus libros relacionados.

-- SE ELIMINAN LOS REGISTROS DE LAS OTRAS TABLAS QUE ESTABAN RELACIONADOS
delete from editoriales where id_editorial = 1;

-- 2.  Actualizar el nombre de una editorial: Si se actualiza el nombre de una editorial en la tabla editoriales, ¿qué sucede con los libros relacionados?
-- NO SUCEDE NADA YA QUE ESTAN RELACIONADOS POR EL ID, LO QUE SI AL MOMENTO DE BUSCAR EL NOMBRE DE LA EDITORIAL VA A DAR COMO RESULTADO EL NOMBRE NUEVO.
update editoriales set nombre_editorial = 'Editorial Atlántida' where id_editorial = 2;

-- 3.	Eliminar un empleado: Si se elimina un empleado de la tabla empleados, ¿qué sucede con los libros relacionados con esa editorial?

--NO SUCEDE NADA, SOLO SE ELIMINA EL EMPLEADO
delete from empleados where id_empleado = 3;

-- 4.	Actualizar el nombre de un empleado: Si se actualiza el nombre de un empleado en la tabla empleados, ¿qué sucede con los libros relacionados con esa editorial?

-- NO SUCEDE NADA, SOLO SE ACTUALIZA EL NOMBRE
update empleados set nombre_empleado = 'Julieta Venegas' where id_empleado= 4;
-- 5.	Eliminar un libro: Si se elimina un libro de la tabla libros, ¿qué sucede con la relación con la editorial?

--NO SUCEDE NADA, SOLO SE ELIMINA EL REGISTRO
delete from libros where id_libro = 3;

-- 6.	Cambiar la editorial de un libro: Si se cambia la editorial a la que está asociado un libro en la tabla libros, ¿qué sucede con la relación con la editorial anterior?

--NO SUCEDE NADA 
update libros set id_editorial = 10 where id_libro=4;

-- 7.	Eliminar una editorial con empleados: Si se intenta eliminar una editorial que tiene empleados asociados, ¿qué sucede?

-- SE ELIMINA EL EMPLEADO ASOCIADO.
delete from editoriales where id_editorial = 2;
SELECT * FROM EDITORIALES;

--8.	Eliminar un empleado con libros: Si se intenta eliminar un empleado que tiene libros asociados, ¿qué sucede?
-- NO SUCEDE NADA YA QUE NO TIENEN RELACION EL EMPLEADO CON EL LIBRO.
delete from empleado where id_empleado = 9;
-- 9.	Eliminar una editorial y sus empleados: ¿Cómo se eliminaría una editorial y todos sus empleados?

-- ELIMINANDO SOLO LA EDITORIAL, SE ELIMINAN LOS EMPLEADOS POR LA ACCION REFERENCIAL CACADE

-- 10.	Eliminar una editorial y transferir sus empleados a otra editorial: ¿Cómo se eliminaría una editorial y reasignaría a sus empleados a otra editorial?

-- PRIMERO REALIZO EL UPDATE PARA PASAR LOS REGISTROS A OTRA EDITORIAL Y LUEGO ELIMINO LA EDITORIAL, YA QUE SI ELIMINO PRIMERO LOS DATOS SE PERDERIAN.

update empleados
set id_editorial= 6
where id_editorial = 3;

delete 
from editoriales
where id_editorial = 3;

