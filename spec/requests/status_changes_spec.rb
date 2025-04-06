require 'rails_helper'

RSpec.describe "StatusChanges", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, status: :created) }
  
  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe "POST /projects/:project_id/status_changes" do
    let(:valid_attributes) { { status_change: { from_status: "created", to_status: "in_progress" } } }
    let(:invalid_attributes) { { status_change: { from_status: "created", to_status: "" } } }
    
    context "with valid parameters" do
      it "creates a new status change" do
        expect {
          post project_status_changes_path(project), params: valid_attributes
        }.to change(StatusChange, :count).by(1)
      end

      it "creates a new conversation entry" do
        expect {
          post project_status_changes_path(project), params: valid_attributes
        }.to change(ConversationEntry, :count).by(1)
      end
      
      it "updates the project status" do
        post project_status_changes_path(project), params: valid_attributes
        project.reload
        expect(project.status).to eq("in_progress")
      end
      
      it "redirects to the project page" do
        post project_status_changes_path(project), params: valid_attributes
        expect(response).to redirect_to(project_path(project))
      end
      
      it "uses the StatusChanges::CreateService" do
        service_double = instance_double(StatusChanges::CreateService, call: StatusChange.new)
        expect(StatusChanges::CreateService).to receive(:call).with(
          user: user,
          project: project,
          params: ActionController::Parameters.new(valid_attributes[:status_change]).permit(:from_status, :to_status)
        ).and_return(service_double.call)
        
        post project_status_changes_path(project), params: valid_attributes
      end
    end

    context "with invalid parameters" do
      it "does not create a new status change" do
        expect {
          post project_status_changes_path(project), params: invalid_attributes
        }.not_to change(StatusChange, :count)
      end

      it "does not create a new conversation entry" do
        expect {
          post project_status_changes_path(project), params: invalid_attributes
        }.not_to change(ConversationEntry, :count)
      end
      
      it "does not update the project status" do
        original_status = project.status
        post project_status_changes_path(project), params: invalid_attributes
        project.reload
        expect(project.status).to eq(original_status)
      end

      it "returns unprocessable entity status" do
        post project_status_changes_path(project), params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  context "with turbo_stream format" do
    it "responds with turbo_stream format when requested" do
      post project_status_changes_path(project), 
           params: { status_change: { from_status: "created", to_status: "in_progress" } }, 
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
           
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
    
    it "renders the correct turbo_stream template" do
      post project_status_changes_path(project), 
           params: { status_change: { from_status: "created", to_status: "in_progress" } }, 
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
           
      expect(response.body).to include('turbo-stream')
      expect(response.body).to include('conversation_entries')
    end
    
    it "updates the project status display" do
      post project_status_changes_path(project), 
           params: { status_change: { from_status: "created", to_status: "in_progress" } }, 
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
           
      expect(response.body).to include('project_status')
      expect(response.body).to include('in_progress')
    end
  end
end
