class Player
  def initialize(name:, level: nil, goals_by_month: nil, salary: nil, base_bonus: nil, team: nil)
    @name = name
    @level = level
    @salary = salary
    @base_bonus = base_bonus
    @goals_by_month = goals_by_month
    @team = team
  end
end