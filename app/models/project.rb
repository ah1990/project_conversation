class Project < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy
  has_many :conversation_entries, dependent: :destroy
  
  validates :title, presence: true

  STATUSES = {
    created: 'Created',
    in_progress: 'In Progress',
    on_hold: 'On Hold',
    completed: 'Completed'
  }

  enum :status, {
    created: 'created',
    in_progress: 'in_progress',
    on_hold: 'on_hold',
    completed: 'completed'
  }

  def display_status
    status_key = status.is_a?(Symbol) ? status : status.to_sym
    STATUSES[status_key] || status.to_s.humanize
  end
  
  validates :status, presence: true
  
  # Default status for new projects
  after_initialize :set_default_status, if: :new_record?
  
  # Get all conversation entries (comments and status changes) in chronological order
  def conversation_history
    conversation_entries.includes(:entryable, :user).order(created_at: :desc)
  end
  
  private
  
  def set_default_status
    self.status ||= :created
  end
end
