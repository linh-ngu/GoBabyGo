# location: spec/features/car_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Creating a car', type: :feature do
  scenario 'valid inputs' do
    visit new_car_path
    fill_in 'Modification details', with: 'Test modification details'
    puts "Available car type options:"
    page.all('select#car_type_id option').each do |option|
      puts option.text
    end
    select 'SUV', from: 'Car Type'
    check 'Complete?'
    click_on 'Create Car'
    expect(page).to have_text('car was successfully created.')
  end
end
