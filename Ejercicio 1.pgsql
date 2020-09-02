--Autor: Julio Eduardo Canizalez Salinas

--PARTE I
--Ejercicio 1
--Definiendo la tabla que almacena los datos del estudiante
CREATE TABLE academic_alumno (
    id_alumno SERIAL,
    carne_alumno VARCHAR(9),
    nombre_alumno VARCHAR(50),
    apellido_alumno VARCHAR(50),
    CONSTRAINT pk_id_alumno PRIMARY KEY (id_alumno),
    CONSTRAINT u_carnet UNIQUE (carne_alumno)
);

--Defininendo la tabla que almacena los datos de las materias
CREATE TABLE academic_materia (
    id_materia SERIAL,
    nombre_materia VARCHAR(100),
    uv_materia int,
    CONSTRAINT pk_id_materia PRIMARY KEY (id_materia)
);

--Definiendo la tabla que almacena los datos de los ciclos
CREATE TABLE academic_ciclo(
    id_ciclo SERIAL,
    year_ciclo INT,
    numero_ciclo INT,
    CONSTRAINT pk_id_ciclo PRIMARY KEY (id_ciclo),
    CONSTRAINT check_valid_year CHECK (year_ciclo>=2020),
    CONSTRAINT check_valid_ciclo CHECK (numero_ciclo BETWEEN 1 AND 2)
);--Entendiendo que hay 2 ciclos por año y que también este año se implementaría este sistema (por eso el check es validando el año 2020)


--Defineindo la tabla para almacenar las notas finales
CREATE TABLE academic_nota_final(
    id_alumno INT,
    id_materia INT,
    id_ciclo INT,
    nota_ciclo REAL,
    aprobada INT,
    CONSTRAINT check_valid_input CHECK (nota_ciclo BETWEEN 0 AND 10),
    CONSTRAINT fk_id_alumno FOREIGN KEY (id_alumno) REFERENCES academic_alumno(id_alumno) ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_id_materia FOREIGN KEY (id_materia) REFERENCES academic_materia(id_materia) ON UPDATE RESTRICT ON DELETE RESTRICT 
);--Restricciones creadas para evitar fraudes en el sistema de notas
--Columna aprobada: 0=reporbada, 1 aprobada


--INSERCIONES DE DATOS

--Agregando datos a la tabla ciclo
INSERT INTO academic_ciclo (year_ciclo, numero_ciclo) VALUES (2020,1);

--Agregando datos a la tabla materia
INSERT INTO academic_materia (nombre_materia, uv_materia) VALUES ('Fundamentos de Administración', 3);
INSERT INTO academic_materia (nombre_materia, uv_materia) VALUES ('Introducción a la Economía I', 4);
INSERT INTO academic_materia (nombre_materia, uv_materia) VALUES ('Principios de Contabilidad', 4);
INSERT INTO academic_materia (nombre_materia, uv_materia) VALUES ('Principios de Matemática', 4);

--Agregando datos a la tabla alumno
INSERT INTO academic_alumno (carne_alumno, nombre_alumno, apellido_alumno) VALUES ('2020MR606', 'Mariano', 'Ramirez');

--Agregando datos a la tabla nota final
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,1,1,8.2,1);--Materia Fundamentos de Administración
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,2,1,7.4,1);--Materia Introducción a la economía I
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,3,1,5.8,0);--Materia Principios de Contabilidad 
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,4,1,6.6,1);--Materia Principios de Matemática

--ENUNCIADO: Cree una sentencia que le permita calcular el C.U.M de Mariano un alumno de primer ciclo
SELECT ROUND(CAST((SUM(n.nota_ciclo * m.uv_materia)/SUM(m.uv_materia)) AS NUMERIC),2) 
AS "C.U.M del ciclo" FROM academic_nota_final n 
INNER JOIN academic_materia m ON m.id_materia = n.id_materia WHERE n.id_alumno = 1 AND n.id_ciclo=1;

--Ejercicio 2: Cree una sentencia que le permita calcular el C.U.M de carrera para Mariano, teniendo en cuenta que ya cursó dos ciclos

--Agregando las nuevas materias
INSERT INTO academic_materia (nombre_materia, uv_materia) VALUES ('Comportamiento Organizacional', 3);
INSERT INTO academic_materia (nombre_materia, uv_materia) VALUES ('Introducción a la Economía II', 4);
INSERT INTO academic_materia (nombre_materia, uv_materia) VALUES ('Matemática I', 5);

--Agregando nuevo ciclo 
INSERT INTO academic_ciclo (year_ciclo, numero_ciclo) VALUES (2020,2);

--Agregando las nuevas notas 
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,5,2,9.1,1);--Materia Comportamiento Organizacional
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,6,2,7.1,1);--Materia Introducción a la Economía II
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,3,2,8.1,1);--Materia Principios de Contabilidad
INSERT INTO academic_nota_final (id_alumno, id_materia, id_ciclo, nota_ciclo, aprobada) VALUES (1,7,2,5.7,0);--Materia Comportamiento Organizacional

--CALCULANDO EL C.U.M DE CARRERA
--Utilizaremos subconsultas

SELECT ROUND(CAST(((SELECT ROUND(CAST(SUM(n.nota_ciclo * m.uv_materia) AS NUMERIC),2) FROM academic_nota_final n 
INNER JOIN academic_materia m ON m.id_materia = n.id_materia WHERE n.id_alumno = 1 AND n.id_ciclo=1 AND n.aprobada=1) + 
(SELECT ROUND(CAST(SUM(n.nota_ciclo * m.uv_materia) AS NUMERIC),2) FROM academic_nota_final n 
INNER JOIN academic_materia m ON m.id_materia = n.id_materia WHERE n.id_alumno = 1 AND n.id_ciclo=2)) / 
(SELECT SUM(m.uv_materia) FROM academic_materia m WHERE m.id_materia IN (SELECT id_materia FROM academic_nota_final WHERE id_alumno=1)) AS NUMERIC),2) 
AS "C.U.M Acumulado al final del Ciclo II"