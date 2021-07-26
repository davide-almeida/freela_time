require 'rails_helper'

RSpec.describe App::CompaniesController, type: :controller do
    before do
        user = create(:user)
    end

    it 'with valid attributes' do
        company_params = attributes_for(:company)
        post :create, params: { company: company_params }
    end

end
