class Application < ApplicationRecord
  after_initialize :default, unless: :persisted?

  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zip_code,
                        :description_of_applicant,
                        :application_status

  has_many :application_pets
  has_many :pets, through: :application_pets

  def default
    self.application_status = "In Progress"
    self.description_of_applicant = "_"
  end

  def add_pet(input)
    matching_pet = Pet.find_by_sql "select name,id from pets where(id = id)"
    ApplicationPet.new(
      pet_id: input,
      application_id: self.id
    )
    # require "pry"; binding.pry
    # pets << matching_pet.first
    pets << matching_pet
  end
end
