class Application < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zip_code,
                        :description_of_applicant,
                        :application_status

  has_many :application_pets
  has_many :pets, through: :application_pets

  def add_pet(id)
    matching_pet = Pet.find_by_sql "select name,id from pets where(id = id)"
    pets << matching_pet.first
  end
end
