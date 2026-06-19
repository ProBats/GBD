-- Trabajo Práctico Sistema de Usuarios y Permisos

-- 1 - Crear un usuario sin privilegios específicos
create user 'max'@'localhost' identified by '123';
-- 2 - Crear un usuario con privilegios de lectura sobre la base pubs
create user 'elvis'@'localhost' identified by '123';

grant select on pubs.* to 'elvis'@'localhost';

REVOKE SELECT, INSERT, UPDATE, DELETE ON *.* FROM 'elvis'@'localhost';

-- 3 - Crear un usuario con privilegios de escritura sobre la base pubs
create user 'yamila'@'localhost' identified by '123';

grant insert on pubs.* to 'yamila'@'localhost';

REVOKE SELECT, INSERT, UPDATE, DELETE ON *.* FROM 'yamila'@'localhost';

-- 4 - Crear un usuario con todos los privilegios sobre la base pubs
create user 'jorge'@'localhost' identified by '123';

grant all privileges on pubs.* to 'jorge'@'localhost';

REVOKE all privileges ON pubs.* FROM 'jorge'@'localhost';
-- 5 - Crear un usuario con privilegios de lectura sobre la tabla titles
create user 'lautaro'@'localhost' identified by '123';

grant select on pubs.titles to 'lautaro'@'localhost';

REVOKE SELECT, INSERT, UPDATE, DELETE ON *.* FROM 'lautaro'@'localhost';
-- 6 - Eliminar al usuario que tiene todos los privilegios sobre la base pubs
drop user 'jorge'@'localhost';

-- 7 - Eliminar a dos usuarios a la vez
drop user 'lautaro'@'localhost', 'yamila'@'localhost';

-- 8 - Eliminar un usuario y sus privilegios asociados
drop user 'elvis'@'localhost';

-- 9 - Revisar los privilegios de un usuario
select * from mysql.user;
