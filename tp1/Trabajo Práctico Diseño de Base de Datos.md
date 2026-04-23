Trabajo Práctico Diseño de Base de Datos

A partir de la siguiente especificación, un Analista deberá recolectar datos para poder diseñar una Base de Datos.

a) Determinar las entidades relevantes al Sistema.

componentes 1:m
importador 0:n
m:n
factura

componentes 1:n
operarios 1:m
n:m
ficha 

televisores 1:m
componentes 1:n
m:n
mapa

b) Determinar los atributos de cada entidad.
COMPONENTE
-
IMPORTADOR
FACTURA
OPERARIO
FICHA
    -fecha
    -cantidad
TELEVISOR
MAPA
    -ubicacion
    -orden


c) Confeccionar el Diagrama de Entidad Relación (DER), junto al Diccionario de Datos

d) Realizar el Diagrama de Tablas e implementar en código SQL la Base de Datos.

e) Crear al menos 2 consultas relacionadas para poder probar la Base de Datos.


Esta empresa se encuentra ubicada en Tierra del Fuego y se dedica al armado de televisores.

Las componentes de los televisores pueden ser comprados a un importador, en tal caso la compra viene acompañada de la factura, otras piezas son fabricadas en la empresa, para lo cual esas piezas tienen asignado un operario que se dedica exclusivamente a un tipo de pieza, aunque una pieza puede ser fabricada por más de un operario, el operario completa una hoja de confección con las la fecha y la cantidad fabricada.

Los diferentes modelos de televisores están compuestos por 300 o más piezas, aunque una pieza puede estar incorporada en más de un televisor, existe un mapa de armado para cada modelo de televisor donde se indica la ubicación y el orden de las piezas que lo componen.

