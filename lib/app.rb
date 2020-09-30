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

output = { jugadores: [] }

# Complementar otros calculos por equipo:
equipos.each do |k1, v1|
  # Calculos por jugador:
  v1[:jugadores].each do |jugador|
    jugador[:bono_equipo] = (jugador[:bono] * DISTRIBUCION_BONO[:equipo]) * v1[:alcance]
    if jugador[:bono_individual] + jugador[:bono_equipo] <= jugador[:bono]
      jugador[:total_bono] = jugador[:bono_individual] + jugador[:bono_equipo]
    else
      jugador[:total_bono] = jugador[:bono]
    end
    jugador[:sueldo_completo] = jugador[:sueldo] + jugador[:total_bono]
    # Generar estructura del output:
    output[:jugadores] << { nombre: jugador[:nombre], 
      goles_minimos: NIVELES[jugador[:nivel].capitalize],
      goles: jugador[:goles],
      sueldo: jugador[:sueldo],
      bono: jugador[:bono],
      sueldo_completo: jugador[:sueldo_completo],
      equipo: jugador[:equipo]
    }
  end
end

# Mostrar informacion en consola:
equipos.each do |k, v|
  puts "*" * 50
  puts "Equipo: #{k.capitalize}"
  puts "Total Goles: #{v[:goles]}"
  puts "Total Minimos: #{v[:minimos]}"
  puts "Alcance: #{v[:alcance] * 100}%"
  puts "Total Jugadores: #{v[:jugadores].count}"
  puts "-" * 50
  v[:jugadores].each do |jugador|
    puts ">> Nombre: #{jugador[:nombre]} - Sueldo Completo: #{jugador[:sueldo_completo].round(2)}"
  end
end

# Generar JSON de respuesta:
puts
puts JSON.generate(output)