-- Trabajo Practico sobre triggers

-- Crea una base de datos llamada testDisparador que contenga una tabla llamada alumnos con las siguientes columnas.

-- Tabla alumnos:
-- •	id (entero sin signo)
-- •	nombre (cadena de caracteres)
-- •	apellido (cadena de caracteres)
-- •	nota (número real)

create database testDisparador;
use testDisparador;

CREATE TABLE alumnos (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    nota DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (id)
);
-- Una vez creada la tabla escriba dos triggers con las siguientes características:

-- Trigger 1: trigger_check_nota_before_insert
-- Se ejecuta sobre la tabla alumnos.
-- Se ejecuta antes de una operación de inserción.
-- Si el nuevo valor de la nota que se quiere insertar es negativo, se guarda como 0.
-- Si el nuevo valor de la nota que se quiere insertar es mayor que 10, se guarda como 10.

delimiter //
	create trigger trigger_check_nota_before_insert
		before insert on  alumnos
		for each row
		begin
			if new.nota < 0 then
				set new.nota = 0;
			elseif new.nota > 10 then
				set new.nota = 10;
			end if;
		end 
        //delimiter;

insert into alumnos(nombre, apellido,nota) values ('yamila','suncion',0);
insert into alumnos(nombre, apellido,nota) values ('Elvis','Morales',-15);
insert into alumnos(nombre, apellido,nota) values ('Max','Rodriguez',16);
insert into alumnos(nombre, apellido,nota) values ('Julian','Morales',7);
select * from alumnos;

-- Trigger2 : trigger_check_nota_before_update
-- Se ejecuta sobre la tabla alumnos.
-- Se ejecuta antes de una operación de actualización.
-- Si el nuevo valor de la nota que se quiere actualizar es negativo, se guarda como 0.
-- Si el nuevo valor de la nota que se quiere actualizar es mayor que 10, se guarda como 10.
-- Una vez creados los triggers escriba 3 sentencias de inserción y actualización sobre la tabla alumnos y verifica que los triggers se están ejecutando correctamente.

delimiter //
	create trigger trigger_check_nota_before_update
		before update on  alumnos
		for each row
		begin
			if new.nota < 0 then
				set new.nota = 0;
			elseif new.nota > 10 then
				set new.nota = 10;
			end if;
		end //
delimiter;

select * from alumnos;
update alumnos set nota = -15 where id = 4;
update alumnos set nota = 15 where id = 1;
update alumnos set nota = 2 where id = 2;