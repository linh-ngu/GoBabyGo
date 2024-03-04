# location: spec/features/car_type_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Car Type Management', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
      @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
      sign_in @admin
      @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :admin)
  end
  scenario 'SUNNY: create with valid inputs' do
    visit new_car_type_path
    fill_in 'Name', with: 'SUV'
    fill_in 'Max height', with: 200
    fill_in 'Min height', with: 150
    fill_in 'Price', with: 25000
    click_on 'Create Car type'
    expect(page).to have_content('car_type was successfully created.')
  end
  scenario 'RAINY: create with invalid inputs' do
    # Visit the new car page
    visit new_car_type_path
    
    # Fill in the details
    fill_in 'Max height', with: 200
    fill_in 'Min height', with: 150
    fill_in 'Price', with: 25000
    click_on 'Create Car type'
    expect(page).to have_text('Name can\'t be blank')
  end
  scenario 'RAINY: create with no inputs' do
    # Visit the new car page
    visit new_car_type_path
    
    # Fill in the details
    click_on 'Create Car type'
    expect(page).to have_text('Name can\'t be blank')
    expect(page).to have_text('Max height can\'t be blank')
    expect(page).to have_text('Min height can\'t be blank')
    expect(page).to have_text('Price can\'t be blank')
  end
  scenario 'SUNNY: update with valid inputs' do
    car_type = CarType.create(name: "SUV", max_height: 200, min_height: 180, price: 30000)
    visit edit_car_type_path(car_type)
    fill_in 'Name', with: 'SUV'
    fill_in 'Max height', with: 200
    fill_in 'Min height', with: 150
    fill_in 'Price', with: 25000
    click_on 'Update Car type'
    expect(page).to have_content('car_type was successfully updated.')
  end
  scenario 'RAINY: update with invalid inputs' do
    car_type = CarType.create(name: "SUV", max_height: 200, min_height: 180, price: 30000)
    visit edit_car_type_path(car_type)
    fill_in 'Name', with: ''
    fill_in 'Max height', with: 200
    fill_in 'Min height', with: 150
    fill_in 'Price', with: 25000
    click_on 'Update Car type'
    expect(page).to have_text('Name can\'t be blank')
  end
  scenario 'RAINY: update with no inputs' do
    car_type = CarType.create(name: "SUV", max_height: 200, min_height: 180, price: 30000)
    visit edit_car_type_path(car_type)
    fill_in 'Name', with: ''
    fill_in 'Max height', with: ''
    fill_in 'Min height', with: ''
    fill_in 'Price', with: ''
    click_on 'Update Car type'
    expect(page).to have_text('Name can\'t be blank')
    expect(page).to have_text('Max height can\'t be blank')
    expect(page).to have_text('Min height can\'t be blank')
    expect(page).to have_text('Price can\'t be blank')
  end
  scenario 'SUNNY: delete car type' do
    car_type = CarType.create(name: "SUV", max_height: 200, min_height: 180, price: 30000)
    visit car_type_path(car_type)
    click_on 'Destroy'
    expect(page).to have_content('car_type was successfully destroyed.')
  end
end
RSpec.describe 'Car Type Integrity', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
      @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
      sign_in @admin
      @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :visitor)
  end
  scenario 'RAINY: try to do CRUD operations as non admin' do
    visit new_car_type_path
    expect(page).to have_content("You do not have permission to view that page!")
    car_type = CarType.create(name: "SUV", max_height: 200, min_height: 180, price: 30000)
    visit edit_car_type_path(car_type)
    expect(page).to have_content("You do not have permission to view that page!")
    visit car_type_path(car_type)
    expect(page).to have_content("You do not have permission to view that page!")
  end
end