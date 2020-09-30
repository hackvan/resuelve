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

equipos = {}

# Verificar y agrupar jugadores por equipos:
input[:jugadores].each do |j|
  jugador = {}
  nombre_equipo = j[:equipo]
  unless equipos[nombre_equipo]
    equipos[nombre_equipo] = Hash.new
    equipos[nombre_equipo][:goles] = 0
    equipos[nombre_equipo][:minimos] = 0
    equipos[nombre_equipo][:alcance] = 0.0
  end
  jugador[:nivel] = j[:nivel]
  jugador[:bono] = j[:bono]
  # Calculos por jugador:
  jugador[:alcance] = jugador[:goles].to_f / NIVELES[j[:nivel].capitalize]
  jugador[:bono_individual] = jugador[:bono].to_f * 0.5 * jugador[:alcance]
end

p equipos