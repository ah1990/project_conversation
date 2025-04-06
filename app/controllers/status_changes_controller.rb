class StatusChangesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  
  def create
    @status_change = ::StatusChanges::CreateService.call(
      user: current_user,
      project: @project,
      params: status_change_params
    )
    
    respond_to do |format|
      if @status_change.persisted?
        # Reload the project to ensure we have the latest status
        @project.reload
        @conversation_entries = @project.conversation_history.includes(:user, :entryable)
        format.html { redirect_to project_path(@project), notice: 'Project status was successfully updated.' }
        format.turbo_stream
      else
        @conversation_entries = @project.conversation_history.includes(:user, :entryable)
        @comment = Comment.new
        format.html { render 'projects/show', status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('status_change_form', partial: 'projects/status_change_form', locals: { project: @project, status_change: @status_change }) }
      end
    end
  end
  
  private
  
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  def status_change_params
    params.require(:status_change).permit(:from_status, :to_status, :reason)
  end
end
