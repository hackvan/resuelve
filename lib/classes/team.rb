class Team
  attr_accessor :name, :players
  @@all = []

  def initialize(name:)
    @name = name
    @players = []
  end

  def self.create(name:)
    new(name: name).tap { |s| s.save }
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def self.print_stats
    self.all.each do |team|
      long = 80
      puts "*" * long
      puts "Equipo: #{team.name}"
      puts "Total Goles: #{team.goals_by_month}"
      puts "Total Minimos: #{team.goals_by_levels}"
      puts "Alcance: #{'%.2f' % (team.average * 100)}%"
      puts "Total Jugadores: #{team.players.size}"
      puts "-" * long
      team.players.each do |jugador|
        puts ">> Nombre: #{jugador.name} - Alcance: #{'%.2f' % (jugador.average * 100)}% - Sueldo Completo: #{'%.2f' % jugador.total_payment}"
      end
    end
  end

  def save
    @@all << self unless @@all.include?(self)
  end

  def add_player(player)
    self.players << player unless self.players.include?(player)
  end

  def goals_by_month
    self.players
      .map{ |player| player.goals_by_month }
      .reduce(0) { |acum, goals| acum + goals }
  end

  def goals_by_levels
    self.players
      .map{ |player| player.goals_by_level }
      .reduce(:+)
  end

  def average
    self.goals_by_month.to_f / self.goals_by_levels.to_f
  end
end