# location: spec/features/car_type_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Notes Management', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
    @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    sign_in @admin
    @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
    @car_type = CarType.create!(name: 'SUV', max_height: 200, max_weight: 150, price: 25000)
    @car = Car.create!(car_type_id: @car_type.id)
  end
  scenario 'SUNNY: create with valid inputs' do
    visit car_path(@car)
    fill_in 'note_content', with: 'This is a note'
    click_on 'Create Note'
    expect(page).to have_content('Note was successfully created.')
  end
  scenario 'RAINY: create with invalid inputs' do
    visit car_path(@car)
    click_on 'Create Note'
    expect(page).to have_text('Content can\'t be blank')
  end
  scenario 'SUNNY: update with valid inputs' do
    note = Note.create!(content: 'This is a note', car_id: @car.id, user_id: @user.id)
    visit car_path(@car)
    click_on 'Edit', match: :first
    fill_in 'note_content', with: 'This is an updated note'
    click_on 'Update Note'
    expect(page).to have_content('Note was successfully updated.')
  end
  scenario 'RAINY: update with invalid inputs' do
    note = Note.create!(content: 'This is a note', car_id: @car.id, user_id: @user.id)
    visit car_path(@car)
    click_on 'Edit', match: :first
    fill_in 'note_content', with: ''
    click_on 'Update Note'
    expect(page).to have_text('Content can\'t be blank')
  end
  scenario 'SUNNY: delete' do
    note = Note.create!(content: 'This is a note', car_id: @car.id, user_id: @user.id)
    visit car_path(@car)
    click_on 'Delete', match: :first
    expect(page).to have_content('Note was successfully destroyed.')
  end
end