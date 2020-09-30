class Team
  attr_accessor :name, :players

  def initialize(name:)
    @name = name
    @players = []
  end
end