module StatusChanges
  class CreateService < ApplicationService
    attr_reader :status_change, :params, :user, :project

    def initialize(user:, project:, params:)
      @user = user
      @project = project
      @params = params
      @status_change = nil
    end

    def call
      build_status_change
      return status_change unless status_change.valid?

      ActiveRecord::Base.transaction do
        save_status_change
        update_project_status
        create_conversation_entry
      end

      status_change
    end

    private

    def build_status_change
      @status_change = project.status_changes.build(params)
      @status_change.user = user
    end

    def save_status_change
      status_change.save!
    end

    def update_project_status
      project.update!(status: status_change.to_status.to_sym)
    end

    def create_conversation_entry
      ConversationEntry.create!(
        project: project,
        user: user,
        entryable: status_change,
        created_at: status_change.created_at
      )
    end
  end
end
