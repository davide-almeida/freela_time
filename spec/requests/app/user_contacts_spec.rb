require 'rails_helper'

RSpec.describe "App::UserContacts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/app/user_contacts/index"
      expect(response).to have_http_status(:success)
    end
  end

end
