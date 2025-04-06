require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:status_changes).dependent(:destroy) }
    it { should have_many(:conversation_entries).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe '#display_name' do
    it 'returns name when name is present' do
      user = build(:user, name: 'John Doe', email: 'john@example.com')
      expect(user.display_name).to eq('John Doe')
    end

    it 'returns email username when name is blank' do
      user = build(:user, name: '', email: 'john@example.com')
      expect(user.display_name).to eq('john')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end
end
