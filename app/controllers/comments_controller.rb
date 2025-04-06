class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  
  def create
    @comment = ::Comments::CreateService.call(
      user: current_user,
      project: @project,
      params: comment_params
    )
    
    respond_to do |format|
      if @comment.valid? && @comment.persisted?
        @conversation_entries = @project.conversation_history.includes(:user, :entryable)
        format.html { redirect_to project_path(@project), notice: 'Comment was successfully added.' }
        format.turbo_stream
      else
        @conversation_entries = @project.conversation_history.includes(:user, :entryable)
        @status_change = StatusChange.new(from_status: @project.status)
        format.html { render 'projects/show', status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('comment_form', partial: 'projects/comment_form', locals: { project: @project, comment: @comment }) }
      end
    end
  end
  
  private
  
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end
