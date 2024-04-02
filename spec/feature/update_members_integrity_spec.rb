require 'rails_helper'
# before adding this test
# 1272 / 1391 LOC (91.45%) covered
# after adding this test
#

RSpec.describe 'NO ACCOUNT: Attempt to access Members Table', type: :feature do
    include Devise::Test::IntegrationHelpers

    scenario 'attempts to render show_user view except redirected to home page' do
        visit table_users_view_path
        expect(page).to have_content("You do not have permission to view that page!")
    end

end

RSpec.describe 'VISITOR: Attempt to access Members Table that that do not belong to the user', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(id: 1, first_name: 'Test', last_name: 'User', email: 'test@gmail.com', phone: '1234567890', admin_id: @admin.id, level: :visitor)
    end

    scenario ' - renders show_user view with visitor level instead of users_table' do
      visit table_users_view_path

      expect(page).to have_content('Welcome to the User Dashboard!')
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.phone)
    end

end

RSpec.describe 'APPLICANT: Attempt to access Members Table that do not belong to the user.', type: :feature do
    include Devise::Test::IntegrationHelpers
    before do
        @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
        sign_in @admin
        @user = User.create!(id: 1, email: 'test@gmail.com', first_name: 'Test', last_name: 'User', phone: '1234567890', admin_id: @admin.id, level: :applicant)
    end

    scenario ' - renders show_user view with applicant level instead of users_table' do
      visit table_users_view_path

      expect(page).to have_content('Welcome to the User Dashboard!')
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.phone)
    end

end

RSpec.describe 'Authorized User: Attempt to access Members Table is permitted based on Officer Role', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
      @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
      sign_in @admin
      @user = User.create!(id: 1, email: 'test@gmail.com', first_name: 'Test', last_name: 'User', phone: '1234567890', admin_id: @admin.id, level: :officer_member)
  end

  scenario ' - Members Table renders instead of user dashbaord' do
    visit table_users_view_path

    expect(page).to have_content('Members of GoBabyGo')
    expect(page).to have_content(@user.email)
    expect(page).to have_content("Officer")

  end

  scenario ' - Members Table renders instead of user dashbaord' do
    visit table_users_view_path

    expect(page).to have_content('Members of GoBabyGo')
    expect(page).to have_content(@user.email)


  end

end

RSpec.describe 'Authorized User: Attempt to access Members Table is permitted based on Admin Role', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
      @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
      @admin_toBeUpdated = Admin.create!(user_account_created: true, email: 'update_me@gmail.com', full_name: 'Update Admin', uid: '223456', avatar_url: 'http://example.com/avatar1')
      sign_in @admin
      @user = User.create!(id: 1, email: 'test@gmail.com', phone: '1234567890', first_name: 'Test', last_name: 'User', admin_id: @admin.id, level: :admin)
      @visitor_user = User.create!(id: 2, email: 'update_me@gmail.com', first_name: 'Test', last_name: 'User', phone: '1234567891', admin_id: @admin.id, level: :visitor)
  end

  scenario ' - Members Table renders instead of user dashbaord' do
    visit table_users_view_path

    expect(page).to have_content('Members of GoBabyGo')
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.level.capitalize)
  end

end

RSpec.describe 'Authorized User: Attempt to access Members Table is permitted based on Member Role', type: :feature do
  include Devise::Test::IntegrationHelpers
  before do
      @admin = Admin.create!(user_account_created: true, email: 'test@gmail.com', full_name: 'Test Admin', uid: '123456', avatar_url: 'http://example.com/avatar')
      sign_in @admin
      @user = User.create!(id: 1, email: 'test@gmail.com', first_name: 'Test', last_name: 'User', phone: '1234567890', admin_id: @admin.id, level: :staff_member)
  end

  scenario ' - Members Table renders instead of user dashbaord' do
    visit table_users_view_path

    expect(page).to have_content('Members of GoBabyGo')
    expect(page).to have_content(@user.email)
    expect(page).to have_content("Staff Member")

  end

end
