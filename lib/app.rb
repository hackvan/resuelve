require 'json'
require 'pry'

require_relative 'classes/level'
require_relative 'classes/team'
require_relative 'classes/player'

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
jugadores = input[:jugadores]

# Cargar información de niveles:
Level.load_levels(nil)

# Obtener los equipos de los jugadores:
equipos = jugadores.group_by { |j| j[:equipo] }

# Cargar la información de equipos y jugadores:
equipos.each do |equipo, jugadores|
  team = Team.create(name: equipo)
  jugadores.each do |jugador|
    level = Level.find_by_name(jugador[:nivel])
    player = Player.create(
      name: jugador[:nombre],
      salary: jugador[:sueldo], 
      base_bonus: jugador[:bono],
      goals_by_month: jugador[:goles],
      level: level, 
      team: team
    )
  end
end

# Generar estructura del output:
output = { jugadores: [] }
Team.all.each do |team|
  team.players.each do |player|
    output[:jugadores] << { 
      nombre: player.name, 
      goles_minimos: player.level_goals,
      goles: player.goals_by_month,
      sueldo: player.salary,
      bono: player.total_bonus,
      sueldo_completo: player.total_payment,
      equipo: player.team_name
    }
  end
end

output = JSON.generate(output)

Team.print_stats