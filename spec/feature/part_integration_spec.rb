# location: spec/features/car_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Part management as admin', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
    @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    sign_in @admin
    @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :admin)
    @car_type = CarType.create!(name: 'SUV', max_height: 200, max_weight: 150, price: 25000)
    @car = Car.create!(car_type_id: @car_type.id)
  end
  scenario 'SUNNY: create with valid inputs' do
    visit edit_car_path(@car)
    fill_in 'part_part_name', with: 'Engine'
    fill_in 'part_part_price', with: 25
    fill_in 'part_quantity_purchased', with: 12
    fill_in 'part_purchase_source', with: "http://example.com/purchase"
    click_on 'Create Part'
    expect(page).to have_content('part was successfully created.')
  end
  scenario 'RAINY: create with invalid inputs' do
    visit edit_car_path(@car)
    fill_in 'part_part_price', with: 25
    fill_in 'part_quantity_purchased', with: 12
    fill_in 'part_purchase_source', with: "http://example.com/purchase"
    click_on 'Create Part'
    expect(page).to have_text('Part name can\'t be blank')
  end
  scenario 'RAINY: create with no inputs' do
    visit edit_car_path(@car)
    click_on 'Create Part'
    expect(page).to have_text('Part name can\'t be blank')
    expect(page).to have_text('Part price can\'t be blank')
    expect(page).to have_text('Quantity purchased can\'t be blank')
  end
  scenario 'SUNNY: update with valid inputs' do
    part = Part.create(part_name: "Engine", part_price: 25, quantity_purchased: 12, purchase_source: "http://example.com/purchase", car_id: @car.id)
    visit edit_part_path(part)
    fill_in 'part_part_name', with: 'Engine'
    fill_in 'part_part_price', with: 25
    fill_in 'part_quantity_purchased', with: 12
    fill_in 'part_purchase_source', with: "http://example.com/purchase"
    click_on 'Update Part'
    expect(page).to have_content('part was successfully updated.')
  end
  scenario 'RAINY: update with invalid inputs' do
    part = Part.create(part_name: "Engine", part_price: 25, quantity_purchased: 12, purchase_source: "http://example.com/purchase", car_id: @car.id)
    visit edit_part_path(part)
    fill_in 'part_part_name', with: ''
    fill_in 'part_part_price', with: 25
    fill_in 'part_quantity_purchased', with: 12
    fill_in 'part_purchase_source', with: "http://example.com/purchase"
    click_on 'Update Part'
    expect(page).to have_text('Part name can\'t be blank')
  end
  scenario 'RAINY: update with no inputs' do
    part = Part.create(part_name: "Engine", part_price: 25, quantity_purchased: 12, purchase_source: "http://example.com/purchase", car_id: @car.id)
    visit edit_part_path(part)
    fill_in 'part_part_name', with: ''
    fill_in 'part_part_price', with: ''
    fill_in 'part_quantity_purchased', with: ''
    fill_in 'part_purchase_source', with: ''
    click_on 'Update Part'
    expect(page).to have_text('Part name can\'t be blank')
    expect(page).to have_text('Part price can\'t be blank')
    expect(page).to have_text('Quantity purchased can\'t be blank')
  end
  scenario 'SUNNY: delete' do
    part = Part.create(part_name: "Engine", part_price: 25, quantity_purchased: 12, purchase_source: "http://example.com/purchase", car_id: @car.id)
    visit part_path(part)
    click_on 'Destroy'
    expect(page).to have_content('part was successfully destroyed.')
  end
end
RSpec.describe 'Part management Integrity', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
    @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    sign_in @admin
    @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :visitor)
    @car_type = CarType.create!(name: 'SUV', max_height: 200, max_weight: 150, price: 25000)
    @car = Car.create!(car_type_id: @car_type.id)
  end
  scenario 'RAINY: try to do CRUD operations as non admin' do
    visit new_part_path
    expect(page).to have_content('You do not have permission to view that page!')
    part = Part.create(part_name: "Engine", part_price: 25, quantity_purchased: 12, purchase_source: "http://example.com/purchase", car_id: @car.id)
    visit edit_part_path(part)
    expect(page).to have_content('You do not have permission to view that page!')
    visit part_path(part)
    expect(page).to have_content('You do not have permission to view that page!')
  end
end