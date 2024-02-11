# location: spec/features/car_type_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Creating a car type', type: :feature do
  scenario 'valid inputs' do
    visit new_car_type_path
    fill_in 'Name', with: 'SUV'
    click_on 'Create Car type'
    expect(page).to have_current_path(car_types_path)
    expect(page).to have_text('Car type successfully created')
  end
end
