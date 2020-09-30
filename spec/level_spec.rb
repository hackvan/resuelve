require_relative '../lib/classes/level'

RSpec.describe Level do
  before(:all) do
    @level = Level.new(name: 'A', goals_by_month: 10)
  end

  describe 'class methods' do
    it '.create' do
      level = Level.create(name: 'B', goals_by_month: 15)
      expect(Level.all).to include(level)
    end

    describe '.find_by_name' do
      before(:all) do
        @level_find = Level.create(name: 'C', goals_by_month: 20)
      end

      it 'with a valid result' do
        search = Level.find_by_name('C')
        expect(search).to eq(@level_find)
      end

      it 'with a not valid result' do
        search = Level.find_by_name('X')
        expect(search).to be_nil
      end
    end

    describe '.load_levels' do
      before(:each) do
        Level.destroy_all
      end

      it 'with an input levels' do
        levels = {
          "A" => 5,
          "B" => 10,
        }.freeze
        load_levels = Level.load_levels(levels)
        expect(load_levels.size).to eq(levels.size)
      end

      it 'without an input levels' do
        load_levels = Level.load_levels(nil)
        expect(load_levels.size).to eq(LEVELS_DEFAULT.size)
      end
    end
  end

  describe 'instance methods' do
    it '#name' do
      expect(@level.name).to eq('A')
    end

    it '#save' do
      @level.save
      expect(Level.all).to include(@level)
    end
  end
end