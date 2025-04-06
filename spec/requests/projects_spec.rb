require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  
  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end
  
  describe "GET /projects" do
    it "returns http success" do
      get projects_path
      expect(response).to have_http_status(:success)
    end
    
    it "displays all projects" do
      projects = create_list(:project, 3)
      get projects_path
      expect(response.body).to include(projects.first.title)
      expect(response.body).to include(projects.last.title)
    end
  end

  describe "GET /projects/:id" do
    it "returns http success" do
      get project_path(project)
      expect(response).to have_http_status(:success)
    end
    
    it "displays project details" do
      get project_path(project)
      expect(response.body).to include(project.title)
      expect(response.body).to include(project.description)
      expect(response.body).to include(project.status)
    end
    
    it "displays conversation history" do
      comment = Comments::CreateService.call(
        user: user,
        project: project,
        params: { content: "This is a test comment" }
      )
      
      status_change = StatusChanges::CreateService.call(
        user: user,
        project: project,
        params: { from_status: "created", to_status: "in_progress", reason: "Starting work" }
      )
      
      get project_path(project)
      expect(response.body).to include("This is a test comment")
      expect(response.body).to include("in_progress")
    end
  end

  describe "GET /projects/new" do
    it "returns http success" do
      get new_project_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /projects" do
    let(:valid_attributes) { { project: { title: "New Project", description: "Project description", status: "created" } } }
    let(:invalid_attributes) { { project: { title: "", description: "Project description" } } }
    
    context "with valid parameters" do
      it "creates a new project" do
        expect {
          post projects_path, params: valid_attributes
        }.to change(Project, :count).by(1)
      end

      it "redirects to the created project" do
        post projects_path, params: valid_attributes
        expect(response).to redirect_to(project_path(Project.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new project" do
        expect {
          post projects_path, params: invalid_attributes
        }.to change(Project, :count).by(0)
      end

      it "renders the new template" do
        post projects_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  describe "GET /projects/:id/edit" do
    it "returns http success" do
      get edit_project_path(project)
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "PATCH /projects/:id" do
    let(:new_attributes) { { project: { title: "Updated Project", description: "Updated description" } } }
    
    it "updates the requested project" do
      patch project_path(project), params: new_attributes
      project.reload
      expect(project.title).to eq("Updated Project")
      expect(project.description).to eq("Updated description")
    end
    
    it "redirects to the project" do
      patch project_path(project), params: new_attributes
      expect(response).to redirect_to(project_path(project))
    end
  end
  
  describe "DELETE /projects/:id" do
    it "destroys the requested project" do
      project_to_delete = create(:project)
      expect {
        delete project_path(project_to_delete)
      }.to change(Project, :count).by(-1)
    end
    
    it "redirects to the projects list" do
      delete project_path(project)
      expect(response).to redirect_to(projects_path)
    end
  end
end
