require "rails_helper"

RSpec.describe 'APPLICANT: Routing from the dashboard to different user application pages.', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar', user_account_created: true)
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', first_name: "Test", last_name: "User", phone: '1234567890', admin_id: @admin.id, level: :applicant)
        @user_application = UserApplication.create(user_id: @user.id, child_first_name: "test", child_last_name: "child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_first_name:"test", caregiver_last_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
    end

    scenario 'SUNNY: Start at the dashboard. Route to the New Application page and back.' do
       visit dashboard_path
       expect(page).to have_content(@user.email)
       expect(page).to have_content(@user.phone)
       click_on "View Your Applications"
       click_on "New Application"
       click_on "Back to Applications"
       click_on "Back to Dashboard"
       expect(page).to have_content(@user.email)
       expect(page).to have_content(@user.phone)
    end

    scenario 'SUNNY: Start at the user applications page and start to delete an application, then cancel. Then, go back and delete it for sure.' do
        visit user_applications_path(@user)
        expect(page).to have_content("test child")
        click_on "Delete"
        expect(page).to have_content("Are you sure you want to permanently delete this application for test child?")
        click_on "Back to Application"
        
        expect(page).to have_content("test child")

        click_on "Delete"
        expect(page).to have_content("Are you sure you want to permanently delete this application for test child?")
        

        user_applications_count_before_deletion = UserApplication.count
  
        # Confirm deletion
        click_on "Delete Application"
  
        # Check if the user application no longer exists after deletion
        expect(UserApplication.count).to eq(user_applications_count_before_deletion - 1)
        expect(UserApplication.exists?(@user_application.id)).to be_falsey
    end

end

RSpec.describe 'OFFICER: Routing from the dashboard to different user application pages.', type: :feature do
    include Devise::Test::IntegrationHelpers

    before do
        @admin = Admin.create!(email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar', user_account_created: true)
        sign_in @admin
        @user = User.create!(email: 'test@gmail.com', first_name: "Test", last_name: "User", phone: '1234567890', admin_id: @admin.id, level: :officer_member)
        @user_application = UserApplication.create(child_first_name: "test", child_last_name: "child", child_birthdate: "2022-12-12", primary_diagnosis: "Can't walk", secondary_diagnosis: "N/A", child_height: 20, child_weight: 10, caregiver_email:"test@gmail.com", caregiver_first_name:"test", caregiver_last_name:"test", caregiver_phone:"1234567890",can_transport:true, can_store:true) 
    end

    scenario 'SUNNY: Start at the dashboard. Route to the user applications page and view an application. Then, go back to the dashboard.' do
       visit dashboard_path
       expect(page).to have_content("View Member Table")
       expect(page).to have_content("View User Applications")
       expect(page).to have_content("View Inventory")
       
       click_on "View User Applications"
       click_on "View"
       
       expect(page).to have_content("test child's Application")
       click_on "Back to Applications"
       click_on "Back to Dashboard"       
    end

    scenario 'SUNNY: Start at the user applications page and start to change the status to accepted on an application, then cancel. Then, go back and change the status to accepted for sure.' do
        visit user_applications_path
        expect(page).to have_content("Pending")
        click_on "Change Status"
        expect(page).to have_content("Edit test child's Application")
        expect(page).to have_selector('.accept-slider')
        expect(page).to have_unchecked_field('user_application_accepted')
        check('user_application_accepted')
        click_on "Back to Applications"
        
        expect(@user_application.accepted).to eq(nil)

        click_on "Change Status"
        
        expect(page).to have_selector('.accept-slider')
        expect(page).to have_unchecked_field('user_application_accepted')
        check('user_application_accepted')
        expect(page).to have_checked_field('user_application_accepted')
        
        click_on "Update Application"
        click_on "Back to Applications"
        expect(page).to have_content("Accepted")
    end

end
