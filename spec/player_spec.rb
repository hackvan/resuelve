require_relative '../lib/classes/team'
require_relative '../lib/classes/level'
require_relative '../lib/classes/player'

RSpec.describe Player do
  before(:all) do
    Level.load_levels(nil)
    @a_level = Level.find_by_name('A')
    @b_level = Level.find_by_name('B')
    @red_team = Team.create(name: 'Rojo')
    @blue_team = Team.create(name: 'Azul')
    @green_team = Team.create(name: 'Verde')
    @purple_team = Team.create(name: 'Morado')
  end

  describe 'class methods' do
    it '.create' do
      player1 = Player.create(
        name: 'Tito', 
        level: 'B', 
        goals_by_month: 5, 
        salary: 50_000, 
        base_bonus: 10_000,
        team: nil
      )

      expect(Player.all).to include(player1)
    end
  end

  describe 'instance methods' do
    before(:all) do
      @player = Player.new(
        name: 'Pepe', 
        level: @a_level, 
        goals_by_month: 10, 
        salary: 100_000, 
        base_bonus: 20_000,
        team: @red_team
      )
    end

    it '#name' do
      expect(@player.name).to eq 'Pepe'
    end

    it '#save' do
      @player.save
      expect(Player.all).to include(@player)
    end

    it '#team=' do
      @player.team = @red_team
      expect(@player.team).to eq(@red_team)
      expect(@red_team.players).to include(@player)
    end

    it '#team_name' do
      expect(@player.team_name).to eq(@red_team.name)
    end

    it '#level_name' do
      expect(@player.level_name).to eq(@a_level.name)
    end

    it '#level_goals' do
      expect(@player.level_goals).to eq(@a_level.goals_by_month)
    end
    
  end

  describe 'stats' do
    context "with expected performance" do
      before(:all) do
        @player1_stats = Player.create(
          name: 'Pepe',
          level: @b_level,
          goals_by_month: 10,
          salary: 100_000,
          base_bonus: 20_000,
          team: @blue_team
        )
      end

      it '#goals_by_level' do
        expect(@player1_stats.goals_by_level).to eq(10)
      end

      it '#average' do
        expect(@player1_stats.average).to eq(1.00)
      end

      it '#total_bonus' do
        expect(@player1_stats.total_bonus).to eq(20_000)
      end

      it '#total_payment' do
        expect(@player1_stats.total_payment).to eq(120_000)
      end
    end

    context "with lower performance" do
      before(:all) do
        @player2_stats = Player.create(
          name: 'Pepe',
          level: @b_level,
          goals_by_month: 5,
          salary: 100_000,
          base_bonus: 20_000,
          team: @green_team
        )
      end

      it '#goals_by_level' do
        expect(@player2_stats.goals_by_level).to eq(10)
      end

      it '#average' do
        expect(@player2_stats.average).to eq(0.50)
      end

      it '#total_bonus' do
        expect(@player2_stats.total_bonus).to eq(10_000)
      end

      it '#total_payment' do
        expect(@player2_stats.total_payment).to eq(110_000)
      end
    end

    context "with higher performance" do
      before(:all) do
        @player2_stats = Player.create(
          name: 'Pepe',
          level: @b_level,
          goals_by_month: 15,
          salary: 100_000,
          base_bonus: 20_000,
          team: @purple_team
        )
      end

      it '#goals_by_level' do
        expect(@player2_stats.goals_by_level).to eq(10)
      end

      it '#average' do
        expect(@player2_stats.average).to eq(1.50)
      end

      it '#total_bonus' do
        expect(@player2_stats.total_bonus).to eq(20_000)
      end

      it '#total_payment' do
        expect(@player2_stats.total_payment).to eq(120_000)
      end
    end
  end
end