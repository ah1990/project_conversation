class ConversationEntry < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :entryable, polymorphic: true
  
  delegate :content, to: :entryable, allow_nil: true
  
  # Helper method to determine the type of entry
  def comment?
    entryable_type == 'Comment'
  end
  
  def status_change?
    entryable_type == 'StatusChange'
  end
end
