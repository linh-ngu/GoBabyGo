# location: spec/features/user_application_integration_spec.rb
require 'rails_helper'

RSpec.describe 'APPLICANT: Creation of a user application', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :visitor)
    end

    scenario 'SUNNY: visit user application path, create application with all fields filled' do
        visit user_applications_path(@user)
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

        # go to index and confirm the application is created
        click_on "Back to Applications"
        expect(page).to have_text('John Doe')
    end

    scenario 'SUNNY: visit user application path, create application with optional fields empty' do
        # login_with_oauth here
        visit user_applications_path(@user)
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
        
        # go to index and confirm the application is created
        click_on "Back to Applications"
        expect(page).to have_text('John Doe')
    end

    scenario 'RAINY: visit user application path, create application with phone empty' do
        # login_with_oauth here
        visit user_applications_path(@user)
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

    scenario 'RAINY: visit user application path, create application with all fields empty' do
        # login_with_oauth here
        visit user_applications_path(@user)
        click_on 'New Application'
        expect(page).to have_text('New Application')
        click_on 'Submit Application'
        expect(page).to have_content("Child name can't be blank, Child birthdate can't be blank, Primary diagnosis can't be blank, Child height can't be blank, Child weight can't be blank, Caregiver name can't be blank, Caregiver email can't be blank, Caregiver phone can't be blank, Can transport is not included in the list, Can store is not included in the list")
    end
end


RSpec.describe 'OFFICER: Changing status of a user application', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
        @user_application = UserApplication.create(child_name: "test child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
    end
    
    scenario 'SUNNY: View and waitlist an application.' do
        visit user_applications_path
        expect(page).to have_content("Pending")
        click_on "Change Status"
        expect(page).to have_content("Edit test child's Application")
        expect(page).to have_selector('.waitlist-slider')
        expect(page).to have_unchecked_field('user_application_waitlist')
        check('user_application_waitlist')
        expect(page).to have_checked_field('user_application_waitlist')
        click_on "Update Application"
        expect(page).to have_content("Application updated successfully.")
        click_on "Back to Applications"
        expect(page).to have_content("Waitlisted")
        expect(@user_application.accepted).to eq(nil)

    end

    scenario 'RAINY: Attempt to select both waitlist and accept.' do
        visit user_applications_path
        expect(page).to have_text('test child')

        visit user_applications_path
        expect(page).to have_content("Pending")
        click_on "Change Status"
        expect(page).to have_content("Edit test child's Application")
        expect(@user_application.accepted).to eq(nil)
        
        expect(page).to have_selector('.accept-slider')
        expect(page).to have_unchecked_field('user_application_accepted')
        expect(page).to have_unchecked_field('user_application_waitlist')
        check('user_application_waitlist')
        check('user_application_accepted')
        expect(page).to have_checked_field('user_application_accepted')
        click_on "Back to Applications"
    end
end


RSpec.describe 'OFFICER: Applying filters to user applications page', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
        @accepted_user_application = UserApplication.create(user_id: @user.id, child_name: "accepted child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true, accepted: true, waitlist: false, created_at: "2024-01-01")
        @waitlisted_user_application = UserApplication.create(user_id: @user.id, child_name: "waitlisted child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true, accepted: false, waitlist: true, created_at: "2024-02-01")
        @not_accepted_user_application = UserApplication.create(user_id: @user.id, child_name: "not acc child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true, accepted: false, waitlist: false, created_at: "2024-03-01") 
    end

    scenario 'SUNNY: Check all types of applicants are shown. Then, fliter by accepted applicants.' do
        visit user_applications_path
        expect(page).to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).to have_content("not acc child")

        click_on "Show Filters"
        check "Accepted"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")
        expect(page).to have_content("Clear Filters")
    end

    scenario 'SUNNY: Filter by waitlist applicants' do
        visit user_applications_path

        click_on "Show Filters"
        check "Waitlist"
        click_on "Apply Filters"
        expect(page).not_to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")
        expect(page).to have_content("Clear Filters")
    end

    scenario 'SUNNY: Filter by not accepted applicants' do
        visit user_applications_path

        click_on "Show Filters"
        check "Not Accepted"
        click_on "Apply Filters"
        expect(page).not_to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).to have_content("not acc child")
        expect(page).to have_content("Clear Filters")
    end

    scenario 'SUNNY: Filter applicants after a specific date' do
        visit user_applications_path

        click_on "Show Filters"
        fill_in "start_date", with: "2024-01-01"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).to have_content("not acc child")
        expect(page).to have_content("Clear Filters")


        click_on "Show Filters"
        fill_in "start_date", with: "2024-01-02"
        click_on "Apply Filters"
        expect(page).not_to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).to have_content("not acc child")

        click_on "Show Filters"
        fill_in "start_date", with: "2024-02-02"
        click_on "Apply Filters"
        expect(page).not_to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).to have_content("not acc child")

        click_on "Show Filters"
        fill_in "start_date", with: "2024-03-02"
        click_on "Apply Filters"
        expect(page).not_to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")
    end

    scenario 'SUNNY: Filter applicants before a specific date' do
        visit user_applications_path

        click_on "Show Filters"
        fill_in "end_date", with: "2024-03-01"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).to have_content("not acc child")
        expect(page).to have_content("Clear Filters")


        click_on "Show Filters"
        fill_in "end_date", with: "2024-02-01"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")

        click_on "Show Filters"
        fill_in "end_date", with: "2024-01-01"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")

        click_on "Show Filters"
        fill_in "end_date", with: "2023-12-30"
        click_on "Apply Filters"
        expect(page).not_to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")
    end

    scenario 'SUNNY: Filter applicants between a specific date range' do
        visit user_applications_path

        click_on "Show Filters"
        fill_in "start_date", with: "2024-01-01"
        fill_in "end_date", with: "2024-03-01"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).to have_content("not acc child")
        expect(page).to have_content("Clear Filters")


        click_on "Show Filters"
        fill_in "start_date", with: "2024-01-01"
        fill_in "end_date", with: "2024-02-01"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")

        click_on "Show Filters"
        fill_in "start_date", with: "2024-01-01"
        fill_in "end_date", with: "2024-01-01"
        click_on "Apply Filters"
        expect(page).to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")

        click_on "Show Filters"
        fill_in "start_date", with: "2023-01-01"
        fill_in "end_date", with: "2023-12-30"
        click_on "Apply Filters"
        expect(page).not_to have_content("accepted child")
        expect(page).not_to have_content("waitlisted child")
        expect(page).not_to have_content("not acc child")
    end

    scenario 'SUNNY: Check default is sort by newest to oldest applications' do
        visit user_applications_path
        expect(page).to have_content("Sort By:")
        expect(page).to have_content("Newest to oldest")
    end

    scenario 'RAINY: Attempt to filter in date range with invalid text.' do
        visit user_applications_path

        click_on "Show Filters"
        fill_in "start_date", with: "NOOOOOO"
        fill_in "end_date", with: "WHYYYYY"
        click_on "Apply Filters"
        expect(page).to have_content("Invalid date format (MM-DD-YYYY).")
    end
    
    scenario 'RAINY: Attempt to filter in date range with start > end' do
        visit user_applications_path

        click_on "Show Filters"
        fill_in "start_date", with: "2023-12-30"
        fill_in "end_date", with: "2023-01-01"
        click_on "Apply Filters"
        expect(page).to have_content("Start date cannot be later than end date.")
    end


    scenario 'RAINY: Attempt to filter in height range with negative number.' do
        visit user_applications_path

        click_on "Show Filters"
        fill_in "min_height", with: "-1"
        fill_in "max_height", with: "-2"
        click_on "Apply Filters"
        
        expect(page).to have_content("Height cannot be negative.")
    end

    scenario 'RAINY: Attempt to filter in height range with min > max height.' do
        visit user_applications_path

        click_on "Show Filters"
        fill_in "min_height", with: "10"
        fill_in "max_height", with: "2"
        click_on "Apply Filters"
        
        expect(page).to have_content("Minimum height cannot be greater than maximum height.")
    end
end

