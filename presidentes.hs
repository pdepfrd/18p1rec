import Data.List
-- Punto a)

-- Para mayor expresividad
type Dia = Int
type Mes = Int
type Anio = Int

type Fecha = (Anio,Mes,Dia)
type Presidente = String

data Periodo = UnPeriodo {
	presidente :: Presidente,
	inicio :: Fecha,
	fin :: Fecha
} deriving Show

data Accion = UnaAccion {
	descripcion :: String,
	fecha :: Fecha,
	lugar :: String,
	beneficiados :: Int
} deriving Show

type Perspectiva = Accion -> Bool

data Periodista = UnPeriodista {
	nombre :: String,
	perspectiva :: Perspectiva
}

-- Ejemplos
periodosDeEjemplo::[Periodo]
periodosDeEjemplo = [alfonsin, menem1, menem2, puerta] 

alfonsin = UnPeriodo {
	presidente = "Alfonsin",
	inicio = (1983,12,10),
	fin = (1989,7,7)
}
menem1 = UnPeriodo {
	presidente = "Menem",
	inicio = (1989,7,8),
	fin = (1995,12,9)
}
menem2 = UnPeriodo {
	presidente = "Menem",
	inicio = (1995,12,10),
	fin = (1999,12,9)
}
puerta = UnPeriodo {
	presidente = "Puerta",
	inicio = (2001,12,21),
	fin = (2001,12,23)
}

accionesDeEjemplo::[Accion]
accionesDeEjemplo = [juicioJuntas, hiperInflacion, privatizacionYPF ]

juicioJuntas = UnaAccion {
	descripcion = "Juicio a las juntas",
	fecha = (1985, 12, 9),
	lugar = "Buenos Aires",
	beneficiados = 30000000
}

hiperInflacion = UnaAccion {
	descripcion = "hiperInflacion",
	fecha = (1989, 1, 1),
	lugar = "Buenos Aires",
	beneficiados = 10
}

privatizacionYPF = UnaAccion {
	descripcion = "Privatizacion de YPF",
	fecha = (1992, 5, 3),
	lugar = "Campana",
	beneficiados = 1
}

ernesto = UnPeriodista {
	nombre = "Ernesto",
	perspectiva = conformista
}	

maria = UnPeriodista {
	nombre = "Maria",
	perspectiva = complice
}	
juan = UnPeriodista {
	nombre = "Juan",
	perspectiva = oriundo "Campana"
}	
-- a) Quiénes fueron presidente por más de un período (sin importar si fueron sucesivos o no)

presidentesMasDeUnPeriodo :: [Periodo] -> [Presidente]
presidentesMasDeUnPeriodo periodos = filter (masDeUnPeriodo periodos) (todosLosPresidentes periodos) 

todosLosPresidentes periodos = nub (map presidente periodos)
-- nub devuelve la lista sin repeticiones. No era necesario, pero para que quede un poco mas limpia la solucion 

masDeUnPeriodo :: [Periodo] -> Presidente -> Bool
masDeUnPeriodo periodos presidenteBuscado = length (filter ((presidenteBuscado==).presidente) periodos ) >= 2

-- b) En una fecha dada, quién era el presidente.

presidenteEnFecha:: [Periodo] -> Fecha -> Presidente
presidenteEnFecha periodos fecha = (presidente.head.filter (enElPeriodo fecha)) periodos

enElPeriodo:: Fecha -> Periodo -> Bool
enElPeriodo fecha periodo = inicio periodo <= fecha && fecha <= fin periodo
-- Aprovechando el criterio de orden de las tuplas


-- 2) Acciones de gobierno

-- a) Si un determinado acto de gobierno fue bueno.

buenaAccion :: Accion -> Bool
buenaAccion accion = beneficiados accion > 10000

-- b) Si un presidente hizo algo bueno, es decir, si en alguno de sus periodos de gobierno hizo alguna accion de gobierno que se considere buena.

hizoAlgoBueno::[Periodo] ->[Accion] -> Presidente -> Bool
hizoAlgoBueno periodos acciones presidente = hizoAlgoQueEs buenaAccion periodos acciones presidente
-- Generalizacion con orden superior para el punto 3.
-- Para el punto 2 basta con 
-- hizoAlgoBueno periodos acciones presidente = any buenaAccion (accionesDel presidente periodos acciones)

hizoAlgoQueEs :: (Accion->Bool) -> [Periodo] ->[Accion] -> Presidente -> Bool
hizoAlgoQueEs comoEsLaAccion periodos acciones presidente = any comoEsLaAccion (accionesDel presidente periodos acciones)

accionesDel:: Presidente -> [Periodo] -> [Accion] -> [Accion]
accionesDel presidente  periodos acciones = filter ((presidente ==).presidenteEnFecha periodos.fecha) acciones 

-- 3) Calificacion Funcional de presidentes 
-- Aparecen los periodistas ( tambíen politólogos, columnistas y otros formadores de opinión pública) que califican a los presidentes según sus propias perspectivas políticas.
-- Se busca encontrar los nombres de todos los presidentes que sean del agrado de un determinado periodista .

--Conformista: Le agradan los presidentes que alguna vez hicieron algo bueno.

presidentesDelAgradoDe periodista periodos acciones = filter (esDelAgradoDe periodista periodos acciones) (todosLosPresidentes periodos)

esDelAgradoDe periodista periodos acciones presidente = hizoAlgoQueEs (perspectiva periodista) periodos acciones presidente

conformista :: Perspectiva
conformista = buenaAccion

-- Complice: Le agrada un presidente si hizo algo malo, alguna vez
complice:: Perspectiva
complice = not.buenaAccion

-- Oriundo de un lugar: Le agrada un presidente cuando hizo algo en el lugar indicado.
oriundo :: String -> Perspectiva
oriundo origen  = (origen==).lugar
