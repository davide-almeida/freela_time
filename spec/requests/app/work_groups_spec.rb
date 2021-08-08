require 'rails_helper'

RSpec.describe "App::WorkGroups", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/app/work_groups/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/app/work_groups/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/app/work_groups/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/app/work_groups/show"
      expect(response).to have_http_status(:success)
    end
  end

end
