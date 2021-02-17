require 'rails_helper'

describe Application, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street_address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip_code }
    # it { should validate_presence_of :description_of_applicant }
    it { should validate_presence_of :application_status }
  end

  describe 'relationships' do
    it { should have_many(:pets).through(:application_pets) }
  end
end
