require 'rails_helper'

RSpec.describe 'Applications show page' do
  before :each do
    @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @pet1 = @shelter1.pets.create!(image:"", name: "Django", description: "dog", approximate_age: 2, sex: "male")
    @pet2 = @shelter1.pets.create!(image:"", name: "awesome pupper Django", description: "dog", approximate_age: 2, sex: "male")
    @pet3 = @shelter1.pets.create!(image:"", name: "django", description: "dog", approximate_age: 2, sex: "male")
    @application_1 = Application.create!(name:"Jordan Beck", street_address: "123 peanut street",
                                  city: "Denver", state: "CO", zip_code: 80209,
              description_of_applicant: "Nice person, dog lover, already owns a dog",
                               application_status: "In Progress")
  end
  describe 'As a visitor' do
    describe 'When I visit the applications show page' do
      it 'displays application w/ corresponding name' do
        visit "/applications/#{@application_1.id}"

        expect(page).to have_content("Name: #{@application_1.name}")
      end
      it 'displays application w/ full address' do
        visit "/applications/#{@application_1.id}"

        expect(page).to have_content("Street Address: #{@application_1.street_address}")
        expect(page).to have_content("City: #{@application_1.city}")
        expect(page).to have_content("State: #{@application_1.state}")
        expect(page).to have_content("Zip Code: #{@application_1.zip_code}")
      end
      it 'displays application w/ description' do
        visit "/applications/#{@application_1.id}"

        expect(page).to have_content("Applicant Description: #{@application_1.description_of_applicant}")
      end
      it 'displays application w/ application status' do
        visit "/applications/#{@application_1.id}"

        expect(page).to have_content("Application Status: #{@application_1.application_status}")
      end
      it "displays application w/ search field to add pets, if
      application has not been submitted" do
        visit "/applications/#{@application_1.id}"

        fill_in "search", :with => "Django"

        click_button "Search Pets"

        expect(current_path).to eq("/applications/#{@application_1.id}")
        expect(page).to have_content(@pet1.name)
      end
      it "adds pets to an application" do
        visit "/applications/#{@application_1.id}"
require "pry"; binding.pry
        expect(page).to have_content("Please search for a pet, and add it")

        fill_in "search", :with => "Django"

        click_button "Search Pets"

        expect(page).to have_button("Adopt this pet")
# save_and_open_page
        within("#pet-id-#{@pet1.id}") do
          click_button "Adopt this pet"
        end

        expect(current_path).to eq("/applications/#{@application_1.id}")
        expect(page).to have_content("All pets applied for: #{@pet1.name}")
        expect(page).to have_content("All pets applied for: #{@application_1.pet_name}")
      end
      it "adds Partial pets to an application" do
        visit "/applications/#{@application_1.id}"

        expect(page).to have_content("Please search for a pet, and add it")

        fill_in "search", :with => "Django"

        click_button "Search Pets"

        expect(page).to have_button("Adopt this pet")

        within("#pet-id-#{@pet1.id}") do
          click_button "Adopt this pet"
        end

        expect(current_path).to eq("/applications/#{@application_1.id}")
        expect(page).to have_content("All pets applied for: #{@pet1.name}")
        expect(page).to have_content("All pets applied for: #{@application_1.pet_name}")
      end
      it "adds Case Insensitive pets to an application" do
        visit "/applications/#{@application_1.id}"

        expect(page).to have_content("Please search for a pet, and add it")

        fill_in "search", :with => "Django"

        click_button "Search Pets"

        expect(page).to have_button("Adopt this pet")

        within("#pet-id-#{@pet1.id}") do
          click_button "Adopt this pet"
        end

        expect(current_path).to eq("/applications/#{@application_1.id}")
        expect(page).to have_content("All pets applied for: #{@pet1.name}")
        expect(page).to have_content("All pets applied for: #{@application_1.pet_name}")
      end
      it "has a section to input why id make a good owner, to complete the application" do
        visit "/applications/#{@application_1.id}"
        fill_in "search", :with => "Django"

        click_button "Search Pets"

        within("#pet-id-#{@pet1.id}") do
          click_button "Adopt this pet"
        end

        expect(current_path).to eq("/applications/#{@application_1.id}")

        fill_in :app, with: "Dog lover, big backyard, lots of treats"

        click_button "Submit Application"

        expect(current_path).to eq("/applications/#{@application_1.id}")
        expect(page).to have_content("Application Status: Pending")
        expect(page).to have_content(@pet1.name)
        expect(page).to have_content("All pets applied for: #{@application_1.pet_name}")
        expect(page).not_to have_content("Add a pet to this application:")
        expect(page).not_to have_content("Search for a pet")
      end
    end
  end
end
