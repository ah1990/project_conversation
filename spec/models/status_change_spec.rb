require 'rails_helper'

RSpec.describe StatusChange, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should have_one(:conversation_entry).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:from_status) }
    it { should validate_presence_of(:to_status) }
    it { should validate_inclusion_of(:from_status).in_array(%w[created in_progress on_hold completed]) }
    it { should validate_inclusion_of(:to_status).in_array(%w[created in_progress on_hold completed]) }
  end

  describe '#status_change_description' do
    it 'returns formatted status change description' do
      status_change = build(:status_change, from_status: 'created', to_status: 'in_progress')
      expect(status_change.status_change_description).to eq('Created → In Progress')
    end

    it 'handles unknown statuses by humanizing them' do
      # This test is a bit artificial since validations would prevent this,
      # but it tests the fallback behavior of the method
      status_change = build(:status_change)
      allow(status_change).to receive(:from_status).and_return('unknown_status')
      allow(status_change).to receive(:to_status).and_return('another_unknown')
      expect(status_change.status_change_description).to eq('Unknown status → Another unknown')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:status_change)).to be_valid
    end
  end
end
