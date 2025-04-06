require 'rails_helper'

RSpec.describe StatusChanges::CreateService do
  let(:user) { create(:user) }
  let(:project) { create(:project, status: :created) }
  let(:valid_params) { { from_status: 'created', to_status: 'in_progress', reason: 'Starting work' } }
  let(:invalid_params) { { from_status: 'created', to_status: 'invalid_status', reason: 'Invalid status' } }

  describe '.call' do
    context 'with valid params' do
      it 'creates a new status change' do
        expect {
          described_class.call(user: user, project: project, params: valid_params)
        }.to change(StatusChange, :count).by(1)
      end

      it 'creates a new conversation entry' do
        expect {
          described_class.call(user: user, project: project, params: valid_params)
        }.to change(ConversationEntry, :count).by(1)
      end

      it 'updates the project status' do
        described_class.call(user: user, project: project, params: valid_params)
        expect(project.reload.status).to eq('in_progress')
      end

      it 'associates the status change with the user and project' do
        status_change = described_class.call(user: user, project: project, params: valid_params)
        expect(status_change.user).to eq(user)
        expect(status_change.project).to eq(project)
      end

      it 'sets the status change reason' do
        status_change = described_class.call(user: user, project: project, params: valid_params)
        expect(status_change.reason).to eq('Starting work')
      end

      it 'associates the conversation entry with the status change' do
        status_change = described_class.call(user: user, project: project, params: valid_params)
        entry = ConversationEntry.last
        expect(entry.entryable).to eq(status_change)
        expect(entry.user).to eq(user)
        expect(entry.project).to eq(project)
      end
    end

    context 'with invalid params' do
      it 'does not create a status change' do
        expect {
          described_class.call(user: user, project: project, params: invalid_params)
        }.not_to change(StatusChange, :count)
      end

      it 'does not create a conversation entry' do
        expect {
          described_class.call(user: user, project: project, params: invalid_params)
        }.not_to change(ConversationEntry, :count)
      end

      it 'does not update the project status' do
        original_status = project.status
        described_class.call(user: user, project: project, params: invalid_params)
        expect(project.reload.status).to eq(original_status)
      end

      it 'returns an invalid status change object' do
        status_change = described_class.call(user: user, project: project, params: invalid_params)
        expect(status_change).not_to be_valid
        expect(status_change.errors[:to_status]).to include('is not included in the list')
      end
    end
  end
end
