BONUS_DISTRIBUTION = {
  individual: 0.5,
  team: 0.5
}.freeze

class Player
  attr_reader :team
  attr_accessor :name, :level, :salary, :base_bonus, :goals_by_month
  @@all = []

  def initialize(name:, level: nil, goals_by_month: nil, salary: nil, base_bonus: nil, team: nil)
    @name = name
    @level = level
    @salary = salary
    @base_bonus = base_bonus
    @goals_by_month = goals_by_month
    self.team = team if team
  end

  def self.create(name:, level:, goals_by_month:, salary:, base_bonus:, team:)
    new(
      name: name,
      level: level,
      goals_by_month: goals_by_month,
      salary: salary,
      base_bonus: base_bonus,
      team: team,
    ).tap { |s| s.save }
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

  def team=(team)
    team.add_player(self)
    @team = team
  end

  def goals_by_level
    level.goals_by_month
  end

  def average
    self.goals_by_month.to_f / self.goals_by_level.to_f
  end

  def individual_bonus
    (self.base_bonus * BONUS_DISTRIBUTION[:individual]) * self.average
  end

  def team_bonus
    (self.base_bonus * BONUS_DISTRIBUTION[:team]) * self.team.average
  end

  def total_bonus
    ((individual_bonus + team_bonus) <= self.base_bonus ? individual_bonus + team_bonus : self.base_bonus).round(2)
  end

  def total_payment
    self.salary + self.total_bonus
  end

  def team_name
    self.team.name
  end

  def level_name
    self.level.name
  end

  def level_goals
    self.level.goals_by_month
  end
end