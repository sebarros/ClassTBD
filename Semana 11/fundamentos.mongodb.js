// Usar BD, si no existe la crea, si existe la usa
use('tinder');

// llamar BD, seleccionar coleccion y funcion
db.explorar.insertOne(
    {
        "username" : "Luchito",
        "age" : 20,
        "description" : "Me gusta archlinux",
        "hobbies" : ["programar", "pokemon tcg"],
        "photos" : "https://i.blogs.es/af4349/dhh_linux/200_200.jpeg"
    }
)

// Buscar todos
use('tinder');
db.explorar.find();

// Buscar uno
use('tinder');
db.explorar.findOne(
    {
        "username" : "Pepita"
    }
);