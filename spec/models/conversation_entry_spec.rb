require 'rails_helper'

RSpec.describe ConversationEntry, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should belong_to(:entryable) }
  end

  describe 'delegations' do
    it 'delegates content to entryable' do
      comment = create(:comment, content: 'Test content')
      entry = create(:conversation_entry, entryable: comment)
      expect(entry.content).to eq('Test content')
    end
  end

  describe '#comment?' do
    it 'returns true when entryable is a Comment' do
      comment = create(:comment)
      entry = create(:conversation_entry, entryable: comment)
      expect(entry.comment?).to be true
    end

    it 'returns false when entryable is not a Comment' do
      status_change = create(:status_change)
      entry = create(:conversation_entry, entryable: status_change)
      expect(entry.comment?).to be false
    end
  end

  describe '#status_change?' do
    it 'returns true when entryable is a StatusChange' do
      status_change = create(:status_change)
      entry = create(:conversation_entry, entryable: status_change)
      expect(entry.status_change?).to be true
    end

    it 'returns false when entryable is not a StatusChange' do
      comment = create(:comment)
      entry = create(:conversation_entry, entryable: comment)
      expect(entry.status_change?).to be false
    end
  end

  describe 'factory' do
    it 'has a valid factory with comment trait' do
      expect(build(:conversation_entry, :for_comment)).to be_valid
    end
    
    it 'has a valid factory with status change trait' do
      expect(build(:conversation_entry, :for_status_change)).to be_valid
    end
  end
end
