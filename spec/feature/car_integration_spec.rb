# location: spec/features/car_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Creating a car', type: :feature do
  scenario 'valid inputs' do
    visit new_car_path
    fill_in 'Modification details', with: 'Test modification details'
    select 'SUV', from: 'Car Type'
    check 'Complete?'
    click_on 'Create Car'
    expect(page).to have_text('car was successfully created.')
  end
  scenario 'invalid inputs' do
    # Visit the new car page
    visit new_car_path
    
    # Fill in the modification details and check the complete checkbox
    fill_in 'Modification details', with: 'Test modification details AAA'
    check 'Complete?'
    
    # Click on the 'Create Car' button
    expect {
      click_on 'Create Car'
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
