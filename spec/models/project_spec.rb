require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:status_changes).dependent(:destroy) }
    it { should have_many(:conversation_entries).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'enums' do
    it 'defines the correct status enum' do
      expected_statuses = {
        'created' => 'created',
        'in_progress' => 'in_progress',
        'on_hold' => 'on_hold',
        'completed' => 'completed'
      }
      expect(Project.statuses).to eq(expected_statuses)
    end
  end

  describe 'constants' do
    it 'defines the correct STATUSES constant' do
      expected_statuses = {
        created: 'Created',
        in_progress: 'In Progress',
        on_hold: 'On Hold',
        completed: 'Completed'
      }
      expect(Project::STATUSES).to eq(expected_statuses)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:project)).to be_valid
    end
  end
end
