--Autor: Julio Eduardo Canizalez Salinas
CREATE TABLE empleados(
 nombre VARCHAR(30),
 documento CHAR(8),
 domicilio VARCHAR(30),
 seccion VARCHAR(20),
 sueldo DECIMAL(6,2),
 cantidadhijos SMALLINT,
 PRIMARY KEY(documento)
);
INSERT INTO empleados VALUES('María Dueñas','22333444','Colon 123','Gerencia',5000,2);
INSERT INTO empleados VALUES('Lorena Maldonado','23444555','Caseros 987','Secretaria',2000,0);
INSERT INTO empleados VALUES('Luis Dueñas','25666777','Sucre 235','Sistemas',4000,1);
INSERT INTO empleados VALUES('Pamela Rivas','26777888','Sarmiento 873','Secretaria',2200,3);
INSERT INTO empleados VALUES('Marlon Hernandez','30000111','Rivadavia 801','Contaduria',3000,0);
INSERT INTO empleados VALUES('Lily Lozano','35111222','Colon 180','Administracion',3200,1);
INSERT INTO empleados VALUES('Rodolfo Caceres','35555888','Coronel Olmedo 588','Sistemas',4000,3);
INSERT INTO empleados VALUES('Marta Vasquez','30141414','Sarmiento 1234','Administracion',3800,4);
INSERT INTO empleados VALUES('Andrea Monroy','28444555',DEFAULT,'Secretaria',NULL,NULL);
--3 - Muestre la cantidad de empleados usando "COUNT" (9 empleados)
SELECT COUNT(documento) FROM empleados;
--4 - Muestre la cantidad de empleados con sueldo no nulo de la sección "Secretaria" (2 empleados)
SELECT * FROM empleados WHERE sueldo IS NOT NULL AND seccion='Secretaria';
--5 - Muestre el sueldo más alto y el más bajo colocando un alias (5000 y 2000)
SELECT * FROM empleados WHERE sueldo=(SELECT max(sueldo) FROM empleados) or sueldo=(SELECT min(sueldo) FROM empleados);
--6 - Muestre el valor mayor de "cantidadhijos" de los empleados "Dueñas" (3 hijos)
SELECT SUM(cantidadhijos) FROM empleados WHERE nombre LIKE '%Dueñas';
--7 - Muestre el promedio de sueldos de todos los empleados (3400. Note que hay un sueldo nulo y no es tenido en cuenta)
SELECT ROUND(AVG(sueldo), 2) FROM empleados WHERE sueldo IS NOT NULL;
--8 - Muestre el promedio de sueldos de los empleados de la sección "Secretaría" (2100)
SELECT ROUND(AVG(sueldo), 2) FROM empleados WHERE sueldo IS NOT NULL AND seccion='Secretaria';
--9 - Muestre el promedio de hijos de todos los empleados de "Sistemas" (2)
SELECT ROUND(AVG(cantidadhijos),2) FROM empleados WHERE seccion='Sistemas';