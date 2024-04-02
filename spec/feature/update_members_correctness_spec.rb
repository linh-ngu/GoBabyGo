require 'rails_helper'
# before adding this test
# 1272 / 1391 LOC (91.45%) covered
# after adding this test
#




RSpec.describe 'Staff Member User can view other members information (Email)', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
    @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    @admin_toBeUpdated = Admin.create!(user_account_created: true, email: 'update_me@gmail.com', full_name: 'Update Admin', uid: '223456', avatar_url: 'http://example.com/avatar1')
    sign_in @admin
    @user = User.create!(id: 1, email: 'test@gmail.com', first_name: 'Update', last_name: 'Admin', phone: '1234567890', admin_id: @admin.id, level: :admin)
    @visitor_user = User.create!(id: 2, first_name: 'Update', last_name: 'Visitor', email: 'update_me@gmail.com', phone: '1234567891', admin_id: @admin.id, level: :visitor)
  end

  scenario ' - Members table shows visitor_user information' do
    visit table_users_view_path

    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.level.capitalize)
    expect(page).to have_content(@user.level.capitalize)

    expect(page).to have_content(@visitor_user.email)
    expect(page).to have_content(@visitor_user.level.capitalize)

  end


end

RSpec.describe 'Admin Account updates User\'s level', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
      @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
      @admin_toBeUpdated = Admin.create!(user_account_created: true, email: 'update_me@gmail.com', full_name: 'Update Admin', uid: '223456', avatar_url: 'http://example.com/avatar1')
      sign_in @admin
      @user = User.create!(id: 1, first_name: 'Update', last_name: 'Admin', email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :admin)
      @visitor_user = User.create!(id: 2, first_name: 'Update', last_name: 'User', email: 'update_me@gmail.com', phone: '1234567891', admin_id: @admin_toBeUpdated.id, level: :visitor)

    end

  scenario ' - Visitor updated to Officer' do
    visit table_users_view_path

    expect(page).to have_content('Members of GoBabyGo')
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.level.capitalize)

    expect(page).to have_content(@visitor_user.email)
    expect(page).to have_content(@visitor_user.level.capitalize)

    # Find the row for @visitor_user and update the role
    within(:xpath, "//tr[td[contains(.,'#{@visitor_user.email}')]]") do
      select 'Officer member', from: 'user[level]' # Adjust if your dropdown has a different label or structure
      click_button 'Update Role'
    end

    # Verify the change was successful
    expect(page).to have_content("User role for update_me@gmail.com was successfully updated to officer_member") # Adjust this based on your app's success confirmation

  end

  scenario ' - Visitor updated to Staff Member' do
    visit table_users_view_path

    expect(page).to have_content('Members of GoBabyGo')
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.level.capitalize)
    expect(page).to have_content(@user.level.capitalize)

    expect(page).to have_content(@visitor_user.email)
    expect(page).to have_content(@visitor_user.level.capitalize)

    # Find the row for @visitor_user and update the role
    within(:xpath, "//tr[td[contains(.,'#{@visitor_user.email}')]]") do
      select 'Staff member', from: 'user[level]' # Adjust if your dropdown has a different label or structure
      click_button 'Update Role'
    end

    expect(page).to have_content("User role for update_me@gmail.com was successfully updated to staff_member") # Adjust this based on your app's success confirmation
  end

  scenario ' - Visitor updated to Admin' do
    visit table_users_view_path
    
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.level.capitalize)
    expect(page).to have_content(@user.level.capitalize)

    expect(page).to have_content(@visitor_user.email)
    expect(page).to have_content(@visitor_user.level.capitalize)

    # Find the row for @visitor_user and update the role
    within(:xpath, "//tr[td[contains(.,'#{@visitor_user.email}')]]") do
      select 'Admin', from: 'user[level]' # Adjust if your dropdown has a different label or structure
      click_button 'Update Role'
    end

    expect(page).to have_content("User role for update_me@gmail.com was successfully updated to admin") # Adjust this based on your app's success confirmation
  end

end

RSpec.describe 'Officer Member Account updates User\'s level', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
    @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
    @admin_toBeUpdated = Admin.create!(user_account_created: true, email: 'update_me@gmail.com', full_name: 'Update Admin', uid: '223456', avatar_url: 'http://example.com/avatar1')
    sign_in @admin
    @user = User.create!(id: 1, first_name: 'Update', last_name: 'Admin', email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
    @visitor_user = User.create!(id: 2, first_name: 'Update', last_name: 'User', email: 'update_me@gmail.com', phone: '1234567891', admin_id: @admin_toBeUpdated.id, level: :visitor)
    end

  scenario ' - Visitor updated to Officer' do
    visit table_users_view_path

    expect(page).to have_content(@visitor_user.email)
    expect(page).to have_content("Officer")

    expect(page).to have_content(@visitor_user.email)
    expect(page).to have_content(@visitor_user.level.capitalize)

    # Find the row for @visitor_user and update the role
    within(:xpath, "//tr[td[contains(.,'#{@visitor_user.email}')]]") do
      select 'Officer member', from: 'user[level]' # Adjust if your dropdown has a different label or structure
      click_button 'Update Role'
    end

    # Verify the change was successful
    expect(page).to have_content("User role for update_me@gmail.com was successfully updated to officer_member") # Adjust this based on your app's success confirmation

  end

  scenario ' - Visitor updated to Staff Member' do
    visit table_users_view_path

    expect(page).to have_content(@user.email)
    expect(page).to have_content("Officer")

    expect(page).to have_content(@visitor_user.email)
    expect(page).to have_content(@visitor_user.level.capitalize)

    # Find the row for @visitor_user and update the role
    within(:xpath, "//tr[td[contains(.,'#{@visitor_user.email}')]]") do
      select 'Staff member', from: 'user[level]' # Adjust if your dropdown has a different label or structure
      click_button 'Update Role'
    end

    expect(page).to have_content("User role for update_me@gmail.com was successfully updated to staff_member") # Adjust this based on your app's success confirmation
  end


end
