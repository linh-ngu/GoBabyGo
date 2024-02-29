# location: spec/features/car_type_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Creating a car type', type: :feature do
  scenario 'valid inputs' do
    visit new_car_type_path
    fill_in 'Name', with: 'SUV'
    fill_in 'Max height', with: 200
    fill_in 'Min height', with: 150
    fill_in 'Price', with: 25000
    click_on 'Create Car type'
  end
  scenario 'invalid inputs' do
    # Visit the new car page
    visit new_car_type_path
    
    # Fill in the details
    fill_in 'Max height', with: 200
    fill_in 'Min height', with: 150
    fill_in 'Price', with: 25000
    click_on 'Create Car type'
    expect(page).to have_text('Name can\'t be blank')
    
  end
end
