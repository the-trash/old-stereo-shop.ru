require 'rails_helper'

RSpec.describe Setting, type: :model do
  let(:settings) { create_list :setting, 10 }
  let(:setting)  { create :setting }
  let(:hash)     { settings; Setting.make_hash }

  context 'validates' do
    it { should validate_presence_of :key }
    it { should validate_presence_of :group }

    it { should validate_uniqueness_of :key }
  end

  describe '.make_hash' do
    it 'return hash' do
      expect(hash).to be_a(Hash)
    end

    it 'should be HashWithIndifferentAccess' do
      key = hash.keys.sample
      expect(hash[key]).to eq hash[key.to_sym]
      expect(hash[key.to_sym]).to eq hash[key.to_s]
    end

    it 'return all keys' do
      expect(hash.keys.sort).to eq settings.map(&:key).sort
    end
  end

  describe '#set_global_variable' do
    it 'update global variable' do
      $settings   = hash
      new_setting = setting

      expect($settings[new_setting.key]).to eq setting.value
    end
  end
end
