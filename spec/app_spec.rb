require_relative '../lib/app'

RSpec.describe App do
  def expand_path(test_file)
    File.expand_path(test_file, File.dirname(__FILE__))
  end

  describe '.run' do
    context 'with' do
      subject { App.run(input_file: expand_path(input_file)) }

      context 'a valid json file' do
        let(:input_file) { 'test_data/input.json' }
        it { expect{ subject }.not_to raise_error }
        it { expect(subject).to be_a(String)}
      end

      context 'a non-existent file' do
        let(:input_file) { 'test_data/non-existent-file.json' }
        it { expect{ subject }.to raise_error(Errno::ENOENT) }
      end

      context 'an existent file with no data' do
        let(:input_file) { 'test_data/no-data.json' }
        it { expect{ subject }.to raise_error(JSON::ParserError) }
      end

      context 'an existent file with no players key' do
        let(:input_file) { 'test_data/no-players.json' }
        it { expect{ subject }.to raise_error(ArgumentError) }
      end
    end
  end
end

