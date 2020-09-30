require_relative '../lib/classes/team'

PlayerStub = Struct.new(:name, :goals_by_month, :goals_by_level)

RSpec.describe Team do
  before(:all) do
    @team = Team.new(name: 'Rojo')
  end

  describe 'class methods' do
    it '.create' do
      team2 = Team.create(name: 'Azul')
      expect(Team.all).to include(team2)
    end
  end

  describe "instance methods" do
    it '#name' do
      expect(@team.name).to eq 'Rojo'
    end

    it '#save' do
      @team.save
      expect(Team.all).to include(@team)
    end

    it '#add_player' do
      player1 = PlayerStub.new('Pepe', 10, 10)
      player2 = PlayerStub.new('Pepe', 5, 10)
      player3 = PlayerStub.new('Pepe', 0, 10)
      @team.add_player(player1)
      @team.add_player(player2)
      @team.add_player(player3)
      expect(@team.players.size).to eq(3)
    end
  end

  describe 'stats' do
    before(:all) do
      @player1 = PlayerStub.new('Pepe', 10, 10)
      @player2 = PlayerStub.new('Pepe', 5, 10)
      @player3 = PlayerStub.new('Pepe', 0, 10)

      @team.add_player(@player1)
      @team.add_player(@player2)
      @team.add_player(@player3)
    end

    it '#goals_by_month' do
      expect(@team.goals_by_month).to eq(15)
    end

    it '#goals_by_levels' do
      expect(@team.goals_by_levels).to eq(30)
    end

    it '#average' do
      expect(@team.average).to eq(0.5)
    end
  end
end