class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one :conversation_entry, as: :entryable, dependent: :destroy
  
  validates :content, presence: true
end
