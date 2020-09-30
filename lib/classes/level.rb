class Level
  attr_accessor :name, :goals_by_month

  def initialize(name:, goals_by_month:)
    @name = name
    @goals_by_month = goals_by_month
  end

  def self.create(name:, goals_by_month:)
  end

  def self.find_by_name(name)
  end

  def save
  end
end