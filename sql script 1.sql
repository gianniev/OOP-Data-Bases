-- Creamos base de datos
CREATE database biblioteca;

-- Creamos schema biblioteca
CREATE SCHEMA biblioteca;

-- Comando para veriicar en que base de datos estamos trabajando
SELECT current_database();


-- Creamos dipos de datos para ser utilizado como objetos
CREATE TYPE biblioteca.tipo_generos AS (
	generos TEXT[]
);

CREATE TYPE biblioteca.tipo_editorial AS (
	nombre varchar(100),
	anio_publicación INT
);

-- Creación de objeto tipo libro
CREATE TYPE biblioteca.tipo_libro AS (
    titulo VARCHAR(100),
    generos biblioteca.tipo_generos,
    disponible BOOLEAN,
    anio_publicacion INT
);  

-- Creamos las tablas autores,editoriales y libros
CREATE TABLE biblioteca.autores (
	id_autor SERIAL PRIMARY KEY,
	nombre_autor varchar(100) NOT NULL
);

CREATE TABLE biblioteca.editoriales (
	id_editorial SERIAL PRIMARY KEY,
	info_editorial biblioteca.tipo_editorial NOT NULL
); 	

CREATE TABLE biblioteca.libros (
	id_libro SERIAL PRIMARY KEY,
	info_libro biblioteca.tipo_libro NOT NULL,
	id_autor INT REFERENCES biblioteca.autores(id_autor),
	id_editorial INT REFERENCES biblioteca.editoriales(id_editorial)
);

SELECT * FROM biblioteca.libros;
SELECT * FROM biblioteca.editoriales;
-- Insertamos data de prueba para verificar que funcione correctamente.
-- Insertamos un autor
INSERT INTO biblioteca.autores (nombre_autor) VALUES ('J.R.R Tolkien');

-- Insertamos editorial
INSERT INTO biblioteca.editoriales (info_editorial) 
VALUES (row('Anaya', 1954)::biblioteca.tipo_editorial);

-- Insertamos Datos del libro
INSERT INTO biblioteca.libros (info_libro) 
VALUES( 
	ROW('El Señor de los Anillos', ROW(ARRAY['Fantasía', 'Aventura'])::biblioteca.tipo_generos, TRUE, 1954)::biblioteca.tipo_libro
);

ALTER TABLE biblioteca.autores
ADD COLUMN titulos INT DEFAULT 0;

-- Verificar
SELECT * FROM biblioteca.autores;
SELECT * FROM biblioteca.libros;
SELECT * FROM biblioteca. editoriales;

-- Actualizo manualmente que el autor J.R.R Tolkien ya tiene 1 libro en la biblioteca.
UPDATE biblioteca.autores
SET titulos = 1
WHERE ID_autor= 1;

-- Actualizo manualmente que el id_libro del señor de los anillos es 1.
UPDATE biblioteca.libros
SET id_libro = 1
WHERE id_autor = 1;

-- Elimino el registro para ingresarlo luego con el resto de libros

DELETE FROM biblioteca.libros
WHERE id_libro = 1;
-- Inserción de datos en las 3 tablas

INSERT INTO biblioteca.autores(nombre_autor, titulos) VALUES
('J.K. Rowling', 0),
('Gabriel García Márquez', 0),
('Jane Austen', 0),
('George Orwell', 0),
('Agatha Christie', 0),
('Isaac Asimov', 0),
('Virginia Woolf', 0),
('Ernest Hemingway', 0),
('Toni Morrison', 0);

INSERT INTO biblioteca.editoriales (info_editorial) VALUES
(ROW('Bloomsbury', 1997)::biblioteca.tipo_editorial),
(ROW('Sudamericana', 1967)::biblioteca.tipo_editorial),
(ROW('Penguin Classics', 1813)::biblioteca.tipo_editorial),
(ROW('Secker & Warburg', 1949)::biblioteca.tipo_editorial),
(ROW('Collins Crime Club', 1934)::biblioteca.tipo_editorial),
(ROW('Doubleday', 1953)::biblioteca.tipo_editorial),
(ROW('Hogarth Press', 1925)::biblioteca.tipo_editorial),
(ROW('Scribner', 1929)::biblioteca.tipo_editorial),
(ROW('Knopf', 1987)::biblioteca.tipo_editorial);


INSERT INTO biblioteca.libros (info_libro, id_autor, id_editorial) VALUES
(
    ROW('El Señor de los Anillos', ROW(ARRAY['Fantasía', 'Aventura'])::biblioteca.tipo_generos, TRUE, 1954)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'J.R.R. Tolkien'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Anaya')
),
(
    ROW('Harry Potter y la Piedra Filosofal', ROW(ARRAY['Fantasía', 'Juvenil'])::biblioteca.tipo_generos, TRUE, 1997)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'J.K. Rowling'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Bloomsbury')
),
(
    ROW('Cien Años de Soledad', ROW(ARRAY['Realismo Mágico', 'Ficción'])::biblioteca.tipo_generos, TRUE, 1967)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'Gabriel García Márquez'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Sudamericana')
),
(
    ROW('Orgullo y Prejuicio', ROW(ARRAY['Romance', 'Clásico'])::biblioteca.tipo_generos, TRUE, 1813)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'Jane Austen'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Penguin Classics')
),
(
    ROW('1984', ROW(ARRAY['Distopía', 'Ciencia Ficción'])::biblioteca.tipo_generos, TRUE, 1949)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'George Orwell'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Secker & Warburg')
),
(
    ROW('Asesinato en el Orient Express', ROW(ARRAY['Misterio', 'Crimen'])::biblioteca.tipo_generos, TRUE, 1934)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'Agatha Christie'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Collins Crime Club')
),
(
    ROW('Fundación', ROW(ARRAY['Ciencia Ficción', 'Épica'])::biblioteca.tipo_generos, TRUE, 1951)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'Isaac Asimov'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Doubleday')
),
(
    ROW('Mrs. Dalloway', ROW(ARRAY['Modernismo', 'Ficción'])::biblioteca.tipo_generos, TRUE, 1925)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'Virginia Woolf'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Hogarth Press')
),
(
    ROW('Adiós a las Armas', ROW(ARRAY['Guerra', 'Romance'])::biblioteca.tipo_generos, TRUE, 1929)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'Ernest Hemingway'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Scribner')
),
(
    ROW('Beloved', ROW(ARRAY['Ficción Histórica', 'Drama'])::biblioteca.tipo_generos, TRUE, 1987)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'Toni Morrison'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Knopf')
);

-- Actualizo el id de autor en el libro del Señor de los Anillos
UPDATE biblioteca.libros
SET id_autor = 1
WHERE id_libro = 2;


select * from biblioteca.libros
ORDER BY id_libro asc;
select * from biblioteca.autores;

-- Con este código eliminamos toda la información de las tablas.
-- TRUNCATE TABLE biblioteca.libros, biblioteca.autores, biblioteca.editoriales RESTART IDENTITY CASCADE;