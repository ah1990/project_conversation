module Comments
  class CreateService < ApplicationService
    attr_reader :comment, :params, :user, :project

    def initialize(user:, project:, params:)
      @user = user
      @project = project
      @params = params
      @comment = nil
    end

    def call
      build_comment
      return comment unless comment.valid?

      ActiveRecord::Base.transaction do
        save_comment!
        create_conversation_entry!
      end

      comment
    end

    private

    def build_comment
      @comment = project.comments.build(params)
      @comment.user = user
    end

    def save_comment!
      comment.save!
    end

    def create_conversation_entry!
      ConversationEntry.create!(
        project: project,
        user: user,
        entryable: comment,
        created_at: comment.created_at
      )
    end
  end
end
