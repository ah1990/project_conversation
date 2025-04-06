class StatusChange < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one :conversation_entry, as: :entryable, dependent: :destroy
  
  validates :from_status, :to_status, presence: true

  validates :to_status, inclusion: { in: %w[created in_progress on_hold completed] }
  validates :from_status, inclusion: { in: %w[created in_progress on_hold completed] }

  def status_change_description
    from_display = Project::STATUSES[from_status.to_sym] || from_status.humanize
    to_display = Project::STATUSES[to_status.to_sym] || to_status.humanize
    "#{from_display} → #{to_display}"
  end
end
