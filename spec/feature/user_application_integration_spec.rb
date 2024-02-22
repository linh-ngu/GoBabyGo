# location: spec/features/user_application_integration_spec.rb
require 'rails_helper'

RSpec.describe 'APPLICANT: Creation of a user application', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id)
    end

    scenario 'VALID: visit user application path, create application with all fields filled' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'user_application_child_name', with: 'John Doe'
        fill_in 'user_application_child_birthdate', with: '2022-01-01'
        fill_in 'user_application_primary_diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'user_application_secondary_diagnosis', with: 'Secondary Diagnosis Test'
        fill_in 'user_application_adaptive_equipment', with: 'Adaptive Equipment Test'
        fill_in 'user_application_child_height', with: '100'
        fill_in 'user_application_child_weight', with: '50'
        fill_in 'user_application_caregiver_name', with: 'Jane Doe'
        fill_in 'user_application_caregiver_email', with: 'jane@example.com'
        fill_in 'user_application_caregiver_phone', with: '1234567890'
        choose 'user_application_can_transport_true' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'user_application_can_store_true' # Selects radio button for 'Do you have the ability to store the car?'
        fill_in 'user_application_notes', with: 'Additional Notes Test'
        click_on 'Submit Application'
        expect(page).to have_content("Application submitted successfully. We will reach out to you soon with our response.")
        user_application = UserApplication.last
        expect(user_application.child_name).to eq('John Doe')
        expect(user_application.child_birthdate).to eq(Date.parse('2022-01-01'))
        expect(user_application.primary_diagnosis).to eq('Primary Diagnosis Test')
    end

    scenario 'VALID: visit user application path, create application with optional fields empty' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'user_application_child_name', with: 'John Doe'
        fill_in 'user_application_child_birthdate', with: '2022-01-01'
        fill_in 'user_application_primary_diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'user_application_child_height', with: '100'
        fill_in 'user_application_child_weight', with: '50'
        fill_in 'user_application_caregiver_name', with: 'Jane Doe'
        fill_in 'user_application_caregiver_email', with: 'jane@example.com'
        fill_in 'user_application_caregiver_phone', with: '1234567890'
        choose 'user_application_can_transport_true' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'user_application_can_store_true' # Selects radio button for 'Do you have the ability to store the car?'
        click_on 'Submit Application'
        expect(page).to have_content("Application submitted successfully. We will reach out to you soon with our response.")
        user_application = UserApplication.last
        expect(user_application.child_name).to eq('John Doe')
        expect(user_application.child_birthdate).to eq(Date.parse('2022-01-01'))
        expect(user_application.primary_diagnosis).to eq('Primary Diagnosis Test')
    end

    scenario 'INVALID: visit user application path, create application with phone empty' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'user_application_child_name', with: 'John Doe'
        fill_in 'user_application_child_birthdate', with: '2022-01-01'
        fill_in 'user_application_primary_diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'user_application_child_height', with: '100'
        fill_in 'user_application_child_weight', with: '50'
        fill_in 'user_application_caregiver_name', with: 'Jane Doe'
        fill_in 'user_application_caregiver_email', with: 'jane@example.com'
        choose 'user_application_can_transport_true' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'user_application_can_store_true' # Selects radio button for 'Do you have the ability to store the car?'
        click_on 'Submit Application'
        expect(page).to have_content("Caregiver phone can't be blank")
    end

    scenario 'INVALID: visit user application path, create application with all fields empty' do
        # login_with_oauth here
        visit user_applications_path(@user)
        click_on 'New Application'
        expect(page).to have_text('New Application')
        click_on 'Submit Application'
        expect(page).to have_content("Child name can't be blank, Child birthdate can't be blank, Primary diagnosis can't be blank, Child height can't be blank, Child weight can't be blank, Caregiver name can't be blank, Caregiver email can't be blank, Caregiver phone can't be blank, Can transport is not included in the list, Can store is not included in the list")
    end
end

RSpec.describe 'OFFICER: Creation of a user application', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: 3)
    end
    
    scenario 'VALID: visit user application path, create application with all fields filled' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'user_application_child_name', with: 'John Doe'
        fill_in 'user_application_child_birthdate', with: '2022-01-01'
        fill_in 'user_application_primary_diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'user_application_secondary_diagnosis', with: 'Secondary Diagnosis Test'
        fill_in 'user_application_adaptive_equipment', with: 'Adaptive Equipment Test'
        fill_in 'user_application_child_height', with: '100'
        fill_in 'user_application_child_weight', with: '50'
        fill_in 'user_application_caregiver_name', with: 'Jane Doe'
        fill_in 'user_application_caregiver_email', with: 'jane@example.com'
        fill_in 'user_application_caregiver_phone', with: '1234567890'
        choose 'user_application_can_transport_true' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'user_application_can_store_true' # Selects radio button for 'Do you have the ability to store the car?'
        fill_in 'user_application_notes', with: 'Additional Notes Test'
        click_on 'Submit Application'
        expect(page).to have_content("Application submitted successfully.")
        user_application = UserApplication.last
        expect(user_application.child_name).to eq('John Doe')
        expect(user_application.child_birthdate).to eq(Date.parse('2022-01-01'))
        expect(user_application.primary_diagnosis).to eq('Primary Diagnosis Test')
    end

    scenario 'VALID: visit user application path, create application with optional fields empty' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'user_application_child_name', with: 'John Doe'
        fill_in 'user_application_child_birthdate', with: '2022-01-01'
        fill_in 'user_application_primary_diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'user_application_child_height', with: '100'
        fill_in 'user_application_child_weight', with: '50'
        fill_in 'user_application_caregiver_name', with: 'Jane Doe'
        fill_in 'user_application_caregiver_email', with: 'jane@example.com'
        fill_in 'user_application_caregiver_phone', with: '1234567890'
        choose 'user_application_can_transport_true' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'user_application_can_store_true' # Selects radio button for 'Do you have the ability to store the car?'
        click_on 'Submit Application'
        expect(page).to have_content("Application submitted successfully.")
        user_application = UserApplication.last
        expect(user_application.child_name).to eq('John Doe')
        expect(user_application.child_birthdate).to eq(Date.parse('2022-01-01'))
        expect(user_application.primary_diagnosis).to eq('Primary Diagnosis Test')
    end

    scenario 'INVALID: visit user application path, create application with phone empty' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'user_application_child_name', with: 'John Doe'
        fill_in 'user_application_child_birthdate', with: '2022-01-01'
        fill_in 'user_application_primary_diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'user_application_child_height', with: '100'
        fill_in 'user_application_child_weight', with: '50'
        fill_in 'user_application_caregiver_name', with: 'Jane Doe'
        fill_in 'user_application_caregiver_email', with: 'jane@example.com'
        choose 'user_application_can_transport_true' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'user_application_can_store_true' # Selects radio button for 'Do you have the ability to store the car?'
        click_on 'Submit Application'
        expect(page).to have_content("Caregiver phone can't be blank")
    end

    scenario 'INVALID: visit user application path, create application with all fields empty' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        click_on 'Submit Application'
        expect(page).to have_content("Child name can't be blank, Child birthdate can't be blank, Primary diagnosis can't be blank, Child height can't be blank, Child weight can't be blank, Caregiver name can't be blank, Caregiver email can't be blank, Caregiver phone can't be blank, Can transport is not included in the list, Can store is not included in the list")
    end
end