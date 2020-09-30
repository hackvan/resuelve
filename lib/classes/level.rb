class Level
  attr_accessor :name, :goals_by_month
  @@all = []

  def initialize(name:, goals_by_month:)
    @name = name
    @goals_by_month = goals_by_month
  end

  def self.create(name:, goals_by_month:)
    new(name: name, goals_by_month: goals_by_month).tap { |s| s.save }
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def self.find_by_name(name)
    self.all.detect{ |a| a.name == name }
  end

  def save
    @@all << self unless @@all.include?(self)
  end
end