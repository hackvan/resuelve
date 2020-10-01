#!/usr/bin/env ruby
require 'optparse'
require 'json'

require_relative 'classes/level'
require_relative 'classes/team'
require_relative 'classes/player'

DEFAULT_INPUT  = '../data/input.json'.freeze
DEFAULT_OUTPUT = '../data/output.json'.freeze

class App
  @@input_path =  File.expand_path(DEFAULT_INPUT,  File.dirname(__FILE__))
  @@output_path = File.expand_path(DEFAULT_OUTPUT, File.dirname(__FILE__))

  # Metodo para llamar desde CLI:
  def self.call
    # Definir opciones de entrada para el usuario:
    options = {}
    options[:show] = false

    OptionParser.new do |parser|
      parser.banner = "Usage: app.rb [options]"
      parser.separator ""
      parser.separator "Specific options:"

      parser.on("-h", "--help", "Show this help message") do
        puts parser
        exit 0
      end

      parser.on("-i", "--input INPUT", "Specify the input file path") do |value|
        options[:input] = value
      end

      parser.on("-o", "--output OUTPUT", "Specify the output file path") do |value|
        options[:output] = value
      end

      parser.on("-s", "--show", "Show stats output in console") do
        options[:show] = true
      end
    end.parse!

    # Definir las rutas de entrada y salida a utilizar:
    input_path =  options[:input]  || @@input_path
    output_path = options[:output] || @@output_path

    self.run(input_file: input_path, output_file: output_path, show: options[:show])

    puts "✅ Archivo con estadisticas generado exitosamente en \"#{output_path}\"" unless options[:show]
  end

  def self.run(input_file: @@input_path, output_file: @@output_path, show: false)
    # Cargar datos y generar información con estadisticas:
    self.load_data(input_file: input_file)
    self.export_output(output_file: output_file, show_stats: show)
  end

  def self.load_data(input_file:)
    # Cargar archivo con la informacion a procesar:
    begin
      data = File.read(input_file)
    rescue Errno::ENOENT => e
      raise $!, "🚫 Error: El archivo \"#{File.basename(input_file)}\" no fue encontrado en la ruta: \"#{File.dirname(input_file)}\"."
    end

    # Parsear datos de entrada:
    begin
      input = JSON.parse(data, symbolize_names: true)
    rescue JSON::ParserError => e
      raise $!, "🚫 Error: El archivo \"#{File.basename(input_file)}\" no posee información para procesar."
    end

    # Validar estructura de entrada:
    raise ArgumentError, '🚫 Error: No se encontro la llave "jugadores" en la estructura del archivo a procesar.' unless input[:jugadores]
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
  end

  def self.export_output(output_file:, show_stats: false)
    # Generar estructura del output:
    data = { jugadores: [] }
    Team.all.each do |team|
      team.players.each do |player|
        data[:jugadores] << { 
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

    if show_stats
      Team.print_stats
    else
      # Exportar la información del data:
      begin
        path = File.expand_path(output_file, File.dirname(__FILE__))
        File.write(path, JSON.dump(data))
      rescue Errno::ENOENT => e
        raise $!, "🚫 Error: El archivo \"#{File.basename(output_file)}\" no pudo ser generado en la ruta: \"#{File.dirname(output_file)}\"."
      end
    end

    # Retornar el output en formato JSON:
    data = JSON.generate(data)
  end
end

if __FILE__ == $0
  begin
    App.call()
  rescue StandardError => e
    $stderr.puts e.message #, e.backtrace
    exit -1
  end
end