// lib/data/libros_mock.dart
// Lista de libros de ejemplo, solo para poder ver la app funcionando
// mientras se define cómo va a cargarse el catálogo real.

import '../models/libro.dart';

const List<Libro> librosMock = [
  Libro(
    id: '1',
    titulo: 'Cien Años de Soledad',
    autor: 'Gabriel García Márquez',
    editorial: 'Sudamericana',
    genero: 'Novela',
    descripcion:
    'La saga de la familia Buendía a lo largo de generaciones en el '
        'pueblo imaginario de Macondo.',
  ),
  Libro(
    id: '2',
    titulo: 'Rayuela',
    autor: 'Julio Cortázar',
    editorial: 'Sudamericana',
    genero: 'Novela',
    descripcion:
    'Novela experimental que puede leerse en distintos órdenes, '
        'siguiendo la historia de Horacio Oliveira.',
  ),
  Libro(
    id: '3',
    titulo: 'Ficciones',
    autor: 'Jorge Luis Borges',
    editorial: 'Emecé',
    genero: 'Cuento',
    descripcion:
    'Colección de relatos breves que exploran laberintos, espejos '
        'e infinitos.',
  ),
  Libro(
    id: '4',
    titulo: 'La Casa de los Espíritus',
    autor: 'Isabel Allende',
    editorial: 'Plaza & Janés',
    genero: 'Novela',
    descripcion:
    'La historia de la familia Trueba, narrada a través de varias '
        'generaciones de mujeres.',
  ),
  Libro(
    id: '5',
    titulo: 'El Aleph',
    autor: 'Jorge Luis Borges',
    editorial: 'Emecé',
    genero: 'Cuento',
    descripcion:
    'Otro de los grandes libros de cuentos de Borges, con el relato '
        'que le da título al volumen.',
  ),
  Libro(
    id: '6',
    titulo: 'Pedro Páramo',
    autor: 'Juan Rulfo',
    editorial: 'Fondo de Cultura Económica',
    genero: 'Novela',
    descripcion:
    'Juan Preciado viaja a Comala en busca de su padre, Pedro Páramo, '
        'y encuentra un pueblo habitado por fantasmas.',
  ),
];