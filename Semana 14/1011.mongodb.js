use('directorio_talento');
db.perfiles.find();

// Un documento en concreto
use('directorio_talento');
db.perfiles.find(
    {
        seccion: '004D'
    }
);

// Comparadores = Operadores logicos
use('directorio_talento');
db.empresas.insertMany(
    [
        {
            nombre: 'BITSS',
            rubro: 'Educación',
            empleados: 32,
            ciudad: 'Puerto Montt',
            creado_por: 'Sebastián Barros'
        },
        {
            nombre: 'OpenAI',
            rubro: 'IA',
            empleados: 87,
            ciudad: 'Santiago',
            creado_por: 'Sebastián Barros'
        }
    ]
);

// JSON = JavaScript Object Notation
use('directorio_talento');
db.ofertas.insertMany(
    [
        {
            cargo : "Analista SOC",
            empresa : "AquaChile",
            modalidad : "Hibrido",
            sueldo : 3000000,
            vacantes : 3,
            requisitos : [
                "Redes",
                "Linux ",
                "SIEM ",
                "Wireshark"
            ],
            activa : true,
            creado_por : "Sebastián Barros"
        }
    ]
);

// Operador $GT = Mayor a // $GTE = Mayor o igual a // $LTE =  Menor o igual a
use('directorio_talento');
db.ofertas.find(
    {
        sueldo : {$gt : 3000000}
    }
);

// $NE = Not Equals
use('directorio_talento');
db.ofertas.find(
    {
        sueldo : {$ne : 500000}
    }
);

// $NI = Not In, Para cadenas de textos
use('directorio_talento');
db.ofertas.find(
    {
        modalidad : {$nin : ["Presencial", "precencial"]}
    }
);

// Traer todas las posibles formas de Presencial
use('directorio_talento');
db.ofertas.find(
    {
        modalidad : /Presencial/i
    }
);