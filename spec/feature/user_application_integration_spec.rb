# location: spec/features/user_application_integration_spec.rb
#require 'rails_helper'

=begin
##################################################
TODO: GET GOOGLE OAUTH INTEGRATION TESTING WORKING
@Daniel Querrey
##################################################

RSpec.describe 'APPLICANT: Creation of a user application', type: :feature do
    scenario 'VALID: visit user application path, create application with all fields filled' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'Child\'s Name', with: 'John Doe'
        fill_in 'Child\'s Birthdate', with: '2022-01-01'
        fill_in 'Child\'s Primary Diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'Child\'s Secondary Diagnosis (if applicable)', with: 'Secondary Diagnosis Test'
        fill_in 'What adaptive equipment does your child use?', with: 'Adaptive Equipment Test'
        fill_in 'Child\'s Height', with: '100'
        fill_in 'Child\'s Weight', with: '50'
        fill_in 'Caregiver\'s Name', with: 'Jane Doe'
        fill_in 'Caregiver\'s Email', with: 'jane@example.com'
        fill_in 'Caregiver\'s Phone', with: '1234567890'
        choose 'Yes' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'Yes' # Selects radio button for 'Do you have the ability to store the car?'
        fill_in 'Additional Notes', with: 'Additional Notes Test'
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
        fill_in 'Child\'s Name', with: 'John Doe'
        fill_in 'Child\'s Birthdate', with: '2022-01-01'
        fill_in 'Child\'s Primary Diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'What adaptive equipment does your child use?', with: 'Adaptive Equipment Test'
        fill_in 'Child\'s Height', with: '100'
        fill_in 'Child\'s Weight', with: '50'
        fill_in 'Caregiver\'s Name', with: 'Jane Doe'
        fill_in 'Caregiver\'s Email', with: 'jane@example.com'
        fill_in 'Caregiver\'s Phone', with: '123-456-7890'
        choose 'Yes' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'Yes' # Selects radio button for 'Do you have the ability to store the car?'
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
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'Child\'s Name', with: 'John Doe'
        fill_in 'Child\'s Birthdate', with: '2022-01-01'
        fill_in 'Child\'s Primary Diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'What adaptive equipment does your child use?', with: 'Adaptive Equipment Test'
        fill_in 'Child\'s Height', with: '100'
        fill_in 'Child\'s Weight', with: '50'
        fill_in 'Caregiver\'s Name', with: 'Jane Doe'
        fill_in 'Caregiver\'s Email', with: 'jane@example.com'
        choose 'Yes' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'Yes' # Selects radio button for 'Do you have the ability to store the car?'
        click_on 'Submit Application'
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



RSpec.describe 'OFFICER: Creation of a user application', type: :feature do
    scenario 'VALID: visit user application path, create application with all fields filled' do
        # login_with_oauth here
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'Child\'s Name', with: 'John Doe'
        fill_in 'Child\'s Birthdate', with: '2022-01-01'
        fill_in 'Child\'s Primary Diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'Child\'s Secondary Diagnosis (if applicable)', with: 'Secondary Diagnosis Test'
        fill_in 'What adaptive equipment does your child use?', with: 'Adaptive Equipment Test'
        fill_in 'Child\'s Height', with: '100'
        fill_in 'Child\'s Weight', with: '50'
        fill_in 'Caregiver\'s Name', with: 'Jane Doe'
        fill_in 'Caregiver\'s Email', with: 'jane@example.com'
        fill_in 'Caregiver\'s Phone', with: '1234567890'
        choose 'Yes' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'Yes' # Selects radio button for 'Do you have the ability to store the car?'
        fill_in 'Additional Notes', with: 'Additional Notes Test'
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
        fill_in 'Child\'s Name', with: 'John Doe'
        fill_in 'Child\'s Birthdate', with: '2022-01-01'
        fill_in 'Child\'s Primary Diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'What adaptive equipment does your child use?', with: 'Adaptive Equipment Test'
        fill_in 'Child\'s Height', with: '100'
        fill_in 'Child\'s Weight', with: '50'
        fill_in 'Caregiver\'s Name', with: 'Jane Doe'
        fill_in 'Caregiver\'s Email', with: 'jane@example.com'
        fill_in 'Caregiver\'s Phone', with: '123-456-7890'
        choose 'Yes' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'Yes' # Selects radio button for 'Do you have the ability to store the car?'
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
        visit user_applications_path
        click_on 'New Application'
        expect(page).to have_text('New Application')
        fill_in 'Child\'s Name', with: 'John Doe'
        fill_in 'Child\'s Birthdate', with: '2022-01-01'
        fill_in 'Child\'s Primary Diagnosis', with: 'Primary Diagnosis Test'
        fill_in 'What adaptive equipment does your child use?', with: 'Adaptive Equipment Test'
        fill_in 'Child\'s Height', with: '100'
        fill_in 'Child\'s Weight', with: '50'
        fill_in 'Caregiver\'s Name', with: 'Jane Doe'
        fill_in 'Caregiver\'s Email', with: 'jane@example.com'
        choose 'Yes' # Selects radio button for 'Do you have the ability to transport the car on Build Day?'
        choose 'Yes' # Selects radio button for 'Do you have the ability to store the car?'

        click_on 'Submit Application'
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
=end
