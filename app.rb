require 'json'
require 'pry'

data = '{ "jugadores":
  [
    {
      "nombre":"Juan Perez",
      "nivel":"C",
      "goles":10,
      "sueldo":50000,
      "bono":25000,
      "sueldo_completo":null,
      "equipo":"rojo"
    },
    {
      "nombre":"EL Cuauh",
      "nivel":"Cuauh",
      "goles":30,
      "sueldo":100000,
      "bono":30000,
      "sueldo_completo":null,
      "equipo":"azul"
    },
    {
      "nombre":"Cosme Fulanito",
      "nivel":"A",
      "goles":7,
      "sueldo":20000,
      "bono":10000,
      "sueldo_completo":null,
      "equipo":"azul"
    },
    {
      "nombre":"El Rulo",
      "nivel":"B",
      "goles":9,
      "sueldo":30000,
      "bono":15000,
      "sueldo_completo":null,
      "equipo":"rojo"
    }
  ]
}'

# Parsear datos de entrada:
input = JSON.parse(data, symbolize_names: true)

NIVELES = {
  "A" => 5,
  "B" => 10,
  "C" => 15,
  "Cuauh" => 20
}

DISTRIBUCION_BONO = {
  individual: 0.5,
  equipo: 0.5
}

equipos = {}
calculos_jugador = {
  alcance: 0.0, 
  bono_individual: 0.0, 
  bono_equipo: 0.0, 
  total_bono: 0.0
}

# Verificar y agrupar jugadores por equipos:
input[:jugadores].each do |j|
  jugador = {}
  nivel_minimo = 0
  nombre_equipo = j[:equipo]
  unless equipos[nombre_equipo]
    equipos[nombre_equipo] = Hash.new
    equipos[nombre_equipo][:goles] = 0
    equipos[nombre_equipo][:minimos] = 0
    equipos[nombre_equipo][:alcance] = 0.0
    equipos[nombre_equipo][:jugadores] = Array.new
  end
  # Calculos por jugador:
  nivel_minimo = NIVELES[j[:nivel].capitalize]
  jugador = j.merge(calculos_jugador)
  jugador[:alcance] = jugador[:goles].to_f / nivel_minimo
  jugador[:bono_individual] = jugador[:bono].to_f * DISTRIBUCION_BONO[:individual] * jugador[:alcance]
  # Calculos por equipo:
  equipos[nombre_equipo][:goles] += j[:goles]
  equipos[nombre_equipo][:minimos] += nivel_minimo
  equipos[nombre_equipo][:alcance] = equipos[nombre_equipo][:goles].to_f / equipos[nombre_equipo][:minimos].to_f
  equipos[nombre_equipo][:jugadores] << jugador
end

p equipos