-- Parte 5 
-- Ejemplos de utilización de los objetos y colecciones creadas.

-- Utilizamos 'tipo_generos'(Colección) para realizar una búsqueda por generos. 

select * from biblioteca.libros;

SELECT (info_libro).titulo
FROM biblioteca.libros 
WHERE 'Fantasía' = ANY(((info_libro).generos).generos); 

-- Utilizamos 'tipo_editorial'(objeto) 

SELECT (info_editorial).nombre 
FROM biblioteca.editoriales
WHERE (info_editorial).anio_publicacion = 1997;

-- Ejemplo 'tipo_libro'(objeto)
SELECT (info_libro).titulo, ((info_libro).generos).generos 
FROM biblioteca.libros 
WHERE (info_libro).disponible = TRUE;


