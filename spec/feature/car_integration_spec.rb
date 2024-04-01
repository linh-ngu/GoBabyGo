require 'rails_helper'
RSpec.describe 'Officer Car management', type: :feature do
  let!(:car_type) { CarType.create(name: "SUV", max_height: 200, max_weight: 180, price: 30000) }
  include Devise::Test::IntegrationHelpers

  before do
    @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    sign_in @admin
    @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
  end


  scenario 'SUNNY: create a car with all fields filled' do
    visit new_car_path
  
    expect(page).to have_text('New Car')
  
    select 'SUV', from: 'car_car_type_id'
    fill_in 'car_modification_details', with: 'Some modification details'
    check 'car_complete'
  
    click_on 'Create Car'
  
    expect(page).to have_content("car was successfully created.")
  
    car = Car.last
    expect(car.car_type.name).to eq('SUV')
    expect(car.modification_details).to eq('Some modification details')
    expect(car.complete).to eq(true)
  end
  scenario 'SUNNY: create a car without optional fields filled' do
    visit new_car_path
  
    expect(page).to have_text('New Car')
  
    select 'SUV', from: 'car_car_type_id'
  
    click_on 'Create Car'
  
    expect(page).to have_content("car was successfully created.")
  
    car = Car.last
    expect(car.car_type.name).to eq('SUV')
    expect(car.complete).to eq(false)
  end
  scenario 'RAINY: create a car without fields filled' do
    visit new_car_path
  
    expect(page).to have_text('New Car')
  
    click_on 'Create Car'
    
    expect(page).to have_content("Car type must exist")
  end
  before do
    @accepted_user_application = UserApplication.create(
            user_id: @user.id, 
            child_first_name: "test",
            child_last_name: "child", 
            child_birthdate: "2024-02-08", 
            primary_diagnosis: "Can't walk", 
            secondary_diagnosis: "N/A", 
            child_height: 20, 
            child_weight: 10, 
            caregiver_first_name: "test",
            caregiver_last_name: "caregiver",
            caregiver_email: "test@gmail.com", 
            caregiver_phone: 1234567890,
            can_transport: true,
            can_store: true,
            notes: "N/A",
            accepted: true
        )
  end
  scenario 'SUNNY: update a car to add an application' do
    @car = Car.create!(car_type_id: car_type.id, complete: true, modification_details: 'Some modification details')
    visit edit_car_path(@car)
    expect(page).to have_text('Editing Car')
    select 'child', from: 'car_user_application_id'
    click_on 'Update Car'
    expect(page).to have_content("car was successfully updated.")
    car = Car.last
    expect(car.user_application.child_last_name).to eq('child')
  end
  scenario 'Create a car with a part and destroy the car (part should be destroyed too)' do
    car = Car.create!(car_type_id: car_type.id, complete: true, modification_details: 'Some modification details')
    visit new_part_car_path(car)
    fill_in 'part_part_name', with: 'Engine'
    fill_in 'part_part_price', with: 25
    fill_in 'part_quantity_purchased', with: 12
    fill_in 'part_purchase_source', with: "http://example.com/purchase"
    click_on 'Create Part'
    part = Part.last
    expect(car.parts).to include(part)
    click_on 'Delete this Car', match: :first
    expect(page).to have_content("car was successfully destroyed.")

    # Verify that the car and the part are destroyed
    expect(Car.find_by(id: car.id)).to be_nil
    expect(Part.find_by(id: part.id)).to be_nil
  end
end

RSpec.describe 'Applicant Car management', type: :feature do
  let!(:car_type) { CarType.create(name: "SUV", max_height: 200, max_weight: 180, price: 30000) }
  include Devise::Test::IntegrationHelpers

  before do
    @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    sign_in @admin
    @user = User.create!(first_name: "test", last_name: "name", email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :staff_member)
    @accepted_user_application = UserApplication.create(
            user_id: @user.id, 
            child_first_name: "test name",
            child_last_name: "accepted child", 
            child_birthdate: "2024-02-08", 
            primary_diagnosis: "Can't walk", 
            secondary_diagnosis: "N/A", 
            child_height: 20, 
            child_weight: 10, 
            caregiver_first_name: "test",
            caregiver_last_name: "caregiver",
            caregiver_email: "test@gmail.com", 
            caregiver_phone: 1234567890,
            can_transport: true,
            can_store: true,
            notes: "N/A",
            accepted: true
        )
  end
  scenario 'SUNNY: view a car assigned to you' do
    @car = Car.create!(car_type_id: car_type.id, complete: true, modification_details: 'Some modification details', user_application_id: @accepted_user_application.id)
    visit cars_path
    expect(page).to have_content("accepted child")
  end
  scenario 'RAINY: view a car not assigned to you' do
    @car = Car.create!(car_type_id: car_type.id, complete: true, modification_details: 'Some modification details')
    visit cars_path
    expect(page).to have_no_content("accepted child")
  end
  scenario 'RAINY: try CRUD operations as non admin' do
    visit new_car_path
    expect(page).to have_content("You do not have permission to view that page!")
    @car = Car.create!(car_type_id: car_type.id, complete: true, modification_details: 'Some modification details')
    visit edit_car_path(@car)
    expect(page).to have_content("You do not have permission to view that page!")
    visit car_path(@car)
    expect(page).to have_content("You do not have permission to view that page!")
  end
end
