-- Etapa 4 
-- 1) Consultas de Búsqueda

-- Buscar por título
SELECT l.id_libro, (l.info_libro).titulo, a.nombre_autor
FROM biblioteca.libros as l
JOIN biblioteca.autores as a ON l.id_autor = a.id_autor
WHERE (l.info_libro).titulo ILIKE '%señor%';

-- Buscar por autor
SELECT l.id_libro, (l.info_libro).titulo, a.nombre_autor
FROM biblioteca.libros as l
JOIN biblioteca.autores as a ON l.id_autor = a.id_autor
WHERE a.nombre_autor ILIKE '%TOLKIEN%';

-- Buscar por género
SELECT l.id_libro, (l.info_libro).titulo, a.nombre_autor, ((l.info_libro).generos).generos AS generos
FROM biblioteca.libros l
JOIN biblioteca.autores a ON l.id_autor = a.id_autor
WHERE 'Fantasía' = ANY(((l.info_libro).generos).generos)
ORDER BY l.id_libro ASC;

select * from biblioteca.libros
order by id_libro asc;

-- Consultas de actualización de datos
-- actualizar título de un libro
UPDATE biblioteca.libros
SET info_libro = ROW(
    'El Hobbit',
    (info_libro).generos,
    (info_libro).disponible,
    (info_libro).anio_publicacion
)::biblioteca.tipo_libro
WHERE id_libro = 2;

-- Vuelvo a cambiarlo al nombre original 
UPDATE biblioteca.libros
SET info_libro = ROW(
    'El Señor de los Anillos',
    (info_libro).generos,
    (info_libro).disponible,
    (info_libro).anio_publicacion
)::biblioteca.tipo_libro
WHERE id_libro = 2;

-- Actualizar el genero de un libro
UPDATE biblioteca.libros
SET info_libro = ROW(
    (info_libro).titulo,
    ROW(ARRAY['Fantasía', 'Aventura', 'Épica'])::biblioteca.tipo_generos,
    (info_libro).disponible,
    (info_libro).anio_publicacion
)::biblioteca.tipo_libro
WHERE id_libro = 2;

-- Cambiar la editorial de un libro
UPDATE biblioteca.libros
SET id_editorial = 3
WHERE id_libro = 2;

-- vuelvo a actualizar el script anterior para que mantenga la información real
UPDATE biblioteca.libros
SET id_editorial = 1
WHERE id_autor = 1;

-- Marcar un Libro como No Disponible(FLASE)
UPDATE biblioteca.libros
SET info_libro = row(
	 (info_libro).titulo,
   	 (info_libro).generos,
     FALSE,
     (info_libro).anio_publicacion
)::biblioteca.tipo_libro
where id_libro = 4;
 
SELECT * FROM biblioteca.autores;
SELECT * FROM biblioteca.editoriales;
SELECT * FROM biblioteca.libros
order by id_libro asc;

-- Consultas de eliminación de datos
-- Primero eliminamos un libro por su id
DELETE FROM biblioteca.libros 
WHERE id_libro = 1;

DELETE FROM biblioteca.libros
WHERE id_autor = 4;

-- Creación de trigger
-- Función que permite la actualiación de la columna titulos en la tabla de bibliotecas
CREATE EXTENSION plpgsql;
CREATE OR REPLACE FUNCTION biblioteca.actualizar_titulos()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE biblioteca.autores a
    SET titulos = (
        SELECT COUNT(l.id_libro)
        FROM biblioteca.libros l
        WHERE l.id_autor = a.id_autor
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Trigger para ejecutar función despues de realizar cambios
CREATE TRIGGER trigger_actualizar_titulos
AFTER INSERT OR UPDATE OF id_autor OR DELETE
ON biblioteca.libros
FOR EACH STATEMENT
EXECUTE FUNCTION biblioteca.actualizar_titulos();

SELECT * FROM biblioteca.autores;
select * from biblioteca.libros
order by id_libro asc;

select * from biblioteca.editoriales;

-- Probamos trigger insertando un libro
-- Insertar un libro nuevo de J.K. Rowling
INSERT INTO biblioteca.libros (info_libro, id_autor, id_editorial)
VALUES (
    ROW('Harry Potter y la Cámara Secreta', ROW(ARRAY['Fantasía', 'Juvenil'])::biblioteca.tipo_generos, TRUE, 1998)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'J.K Rowling'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Bloomsbury')
);

INSERT INTO biblioteca.libros (info_libro, id_autor, id_editorial)
VALUES (
    ROW('El Silmarillion', ROW(ARRAY['Fantasía', 'Épica'])::biblioteca.tipo_generos, TRUE, 1977)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'J.R.R Tolkien'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Anaya')
);

INSERT INTO biblioteca.libros (info_libro, id_autor, id_editorial)
VALUES (
    ROW('Los Hijos de Húrin', ROW(ARRAY['Fantasía', 'Épica'])::biblioteca.tipo_generos, TRUE, 2007)::biblioteca.tipo_libro,
    (SELECT id_autor FROM biblioteca.autores WHERE nombre_autor = 'J.R.R Tolkien'),
    (SELECT id_editorial FROM biblioteca.editoriales WHERE (info_editorial).nombre = 'Anaya')
);


-- Script para verificar trigger 
SELECT id_autor, nombre_autor, titulos FROM biblioteca.autores;

 




