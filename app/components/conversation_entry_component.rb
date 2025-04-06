# frozen_string_literal: true

class ConversationEntryComponent < ViewComponent::Base
  def initialize(entry:)
    @entry = entry
  end
  
  def comment?
    @entry.comment?
  end
  
  def status_change?
    @entry.status_change?
  end
  
  def user_name
    @entry.user.display_name
  end
  
  def user_initial
    user_name.first.upcase
  end
  
  def time_ago
    time_ago_in_words(@entry.created_at) + " ago"
  end
  
  def content
    @entry.content
  end
  
  def from_status
    return unless status_change?
    status = @entry.entryable.from_status
    Project::STATUSES[status.to_sym] || status.humanize
  end
  
  def to_status
    return unless status_change?
    status = @entry.entryable.to_status
    Project::STATUSES[status.to_sym] || status.humanize
  end
  
  def reason
    return unless status_change?
    @entry.entryable.reason
  end
end
