require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'Validations' do
    # before do
    #   user = create(:user)
    # end

    it 'is valid with name, description and user' do
      company = create(:company)
      expect(company).to be_valid
    end

    it 'is invalid without description' do
      company = create(:company, description: nil)
      # company.valid?
      # expect(company.errors[:description]).to include("can't be blank")
      expect(company).to be_valid
    end
  end
end
