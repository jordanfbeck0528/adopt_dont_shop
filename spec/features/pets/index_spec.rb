require 'rails_helper'

RSpec.describe 'Pets index page' do
  before :each do
    @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
    @shelter3 = Shelter.create!(name: "Shell Shelter", address: "102 Shelter Dr.", city: "Commerce City", state: "CO", zip: 80022)
    @pet1 = @shelter1.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
    @pet2 = @shelter2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
    @pet3 = @shelter1.pets.create!(image:"", name: "Zeus", description: "dog", approximate_age: 4, sex: "male")
  end

  it "displays each pet in the system with attributes" do

    visit "/pets"

    expect(page).to have_content(@pet1.image)
    expect(page).to have_content(@pet1.name)
    expect(page).to have_content(@pet1.approximate_age)
    expect(page).to have_content(@pet1.sex)
    expect(page).to have_content(@shelter1.name)

    expect(page).to have_content(@pet2.image)
    expect(page).to have_content(@pet2.name)
    expect(page).to have_content(@pet2.approximate_age)
    expect(page).to have_content(@pet2.sex)
    expect(page).to have_content(@shelter2.name)

    expect(page).to_not have_content(@shelter3.name)
  end

  it "can delete a pet from pet index page" do
    visit "/pets"

    within "#pet-#{@pet1.id}" do
      expect(page).to have_content("Thor")
      click_link "Delete Pet"
    end

    expect(current_path).to eq("/pets")
    expect(page).to_not have_content("Thor")
  end

  it "can edit a pet from pets index page" do
    visit '/pets'

    within "#pet-#{@pet1.id}" do
      expect(page).to have_content("Thor")
      click_link "Update Pet"
    end

    fill_in "name", with: "Calvin"

    click_button "Update Pet"

    expect(current_path).to eq("/pets/#{@pet1.id}")

    expect(page).to have_content("Calvin")
    expect(page).to_not have_content("Thor")
  end
  it "can navigate to applications/new from pets index page" do
    visit '/pets'

    expect(page).to have_link("New Application")
    click_link "New Application"
  end
  it 'can create new application' do
    visit '/applications/new'

    fill_in "name", with: "John"
    fill_in "street_address", with:"123 funtown street"
    fill_in "city", with:"San Jose"
    fill_in "state", with:"CA"
    fill_in "zip_code", with:"95123"
    # fill_in "description_of_applicant", with:"Fun loving, outdoorsy person, in need of friend"

    click_button "Submit"

    expect(page).to have_content("John")
    expect(page).to have_content("123 funtown street")
    expect(page).to have_content("San Jose")
    expect(page).to have_content("CA")
    expect(page).to have_content("95123")
    # expect(page).to have_content("Fun loving, outdoorsy person, in need of friend")
    expect(page).to have_content("In Progress")
  end
  it 'wont create a new application if data is missing' do
    visit '/applications/new'

    fill_in "name", with: "John"
    fill_in "street_address", with:"123 funtown street"
    fill_in "city", with:"San Jose"
    fill_in "state", with:"CA"
    fill_in "zip_code", with:""
    # fill_in "description_of_applicant", with: nil

    click_button "Submit"
# save_and_open_page
    # expect(page).to have_content("Create New Application failed, Please complete all fields\nName Street address City State Zip code Description of applicant Application status")
    expect(page).to have_content("Create New Application failed, Please complete all fields")
  end
end
