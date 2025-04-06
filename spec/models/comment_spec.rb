require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should have_one(:conversation_entry).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:comment)).to be_valid
    end
  end
end
