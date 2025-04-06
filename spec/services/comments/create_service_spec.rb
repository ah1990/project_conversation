require 'rails_helper'

RSpec.describe Comments::CreateService do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:valid_params) { { content: 'Test comment content' } }
  let(:invalid_params) { { content: '' } }

  describe '.call' do
    context 'with valid params' do
      it 'creates a new comment' do
        expect {
          described_class.call(user: user, project: project, params: valid_params)
        }.to change(Comment, :count).by(1)
      end

      it 'creates a new conversation entry' do
        expect {
          described_class.call(user: user, project: project, params: valid_params)
        }.to change(ConversationEntry, :count).by(1)
      end

      it 'associates the comment with the user and project' do
        comment = described_class.call(user: user, project: project, params: valid_params)
        expect(comment.user).to eq(user)
        expect(comment.project).to eq(project)
      end

      it 'sets the comment content' do
        comment = described_class.call(user: user, project: project, params: valid_params)
        expect(comment.content).to eq('Test comment content')
      end

      it 'associates the conversation entry with the comment' do
        comment = described_class.call(user: user, project: project, params: valid_params)
        entry = ConversationEntry.last
        expect(entry.entryable).to eq(comment)
        expect(entry.user).to eq(user)
        expect(entry.project).to eq(project)
      end
    end

    context 'with invalid params' do
      it 'does not create a comment' do
        expect {
          described_class.call(user: user, project: project, params: invalid_params)
        }.not_to change(Comment, :count)
      end

      it 'does not create a conversation entry' do
        expect {
          described_class.call(user: user, project: project, params: invalid_params)
        }.not_to change(ConversationEntry, :count)
      end

      it 'returns an invalid comment object' do
        comment = described_class.call(user: user, project: project, params: invalid_params)
        expect(comment).not_to be_valid
        expect(comment.errors[:content]).to include("can't be blank")
      end
    end
  end
end
