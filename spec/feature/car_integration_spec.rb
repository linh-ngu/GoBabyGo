# location: spec/features/car_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Creating a car', type: :feature do
  scenario 'valid inputs' do
    visit new_car_path
    click_on 'Create Car'
    expect(page).to have_current_path(cars_path)
    expect(page).to have_text('Car successfully created')
  end
end
