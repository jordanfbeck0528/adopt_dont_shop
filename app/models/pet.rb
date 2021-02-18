class Pet < ApplicationRecord
  # require "pry"; binding.pry
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets
  validates_presence_of :name, :description, :approximate_age, :sex

  validates :approximate_age, numericality: {
              greater_than_or_equal_to: 0
            }

  enum sex: [:female, :male]

  def self.search(input)
    # where(name: input)
    where("name LIKE ?", "%#{input}%")
  end
end
