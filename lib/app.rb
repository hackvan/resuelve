require 'json'

require_relative 'classes/level'
require_relative 'classes/team'
require_relative 'classes/player'

DEFAULT_INPUT  = '../data/input.json'.freeze
DEFAULT_OUTPUT = '../data/output.json'.freeze

# Cargar archivos con la informacion a procesar:
path = File.expand_path(DEFAULT_INPUT, File.dirname(__FILE__))
data = File.read(path)

# Parsear datos de entrada:
raise StandardError.new "Debe especificar los datos de ingreso para los calculos" unless data
input = JSON.parse(data, symbolize_names: true)

# Validar estructuras de entrada:
raise StandardError.new "Es necesaria la lista de jugadores para los calculos" unless input[:jugadores]
jugadores = input[:jugadores]

# Cargar información de niveles:
Level.load_levels(input[:niveles])

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

# Exportar la información del output:
path = File.expand_path(DEFAULT_OUTPUT, File.dirname(__FILE__))
File.write(path, JSON.dump(output))
output = JSON.generate(output)

Team.print_stats