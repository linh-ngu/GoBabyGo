require 'rails_helper'
RSpec.describe 'Officer Car management', type: :feature do
  let!(:car_type) { CarType.create(name: "SUV", max_height: 200, min_height: 180, price: 30000) }
  include Devise::Test::IntegrationHelpers

  before do
    @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    sign_in @admin
    @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
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
    @accepted_user_application = UserApplication.create(user_id: @user.id, child_name: "accepted child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true, accepted: true, waitlist: false, created_at: "2024-01-01")
    @waitlisted_user_application = UserApplication.create(user_id: @user.id, child_name: "waitlisted child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true, accepted: false, waitlist: true, created_at: "2024-02-01")
    @not_accepted_user_application = UserApplication.create(user_id: @user.id, child_name: "not accepted child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true, accepted: false, waitlist: false, created_at: "2024-03-01") 
  end
  scenario 'SUNNY: update a car to add an application' do
    @car = Car.create!(car_type_id: car_type.id, complete: true, modification_details: 'Some modification details')
    visit edit_car_path(@car)
    expect(page).to have_text('Editing Car')
    select 'accepted child', from: 'car_user_application_id'
    click_on 'Update Car'
    expect(page).to have_content("car was successfully updated.")
    car = Car.last
    expect(car.user_application.child_name).to eq('accepted child')
  end
  scenario 'SUNNY: delete a car' do
    @car = Car.create!(car_type_id: car_type.id, complete: true, modification_details: 'Some modification details')
    visit car_path(@car)
    click_on 'Destroy', match: :first
    expect(page).to have_content("car was successfully destroyed.")
  end
end

RSpec.describe 'Applicant Car management', type: :feature do
  let!(:car_type) { CarType.create(name: "SUV", max_height: 200, min_height: 180, price: 30000) }
  include Devise::Test::IntegrationHelpers

  before do
    @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    sign_in @admin
    @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :visitor)
    @accepted_user_application = UserApplication.create(user_id: @user.id, child_name: "accepted child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true, accepted: true, waitlist: false, created_at: "2024-01-01")
    
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
end
    