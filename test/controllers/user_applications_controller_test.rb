require "test_helper"

class UserApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_applications_show_url
    assert_response :success
  end

  test "should get new" do
    get user_applications_new_url
    assert_response :success
  end

  test "should get create" do
    get user_applications_create_url
    assert_response :success
  end

  test "should get edit" do
    get user_applications_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_applications_update_url
    assert_response :success
  end

  test "should get delete" do
    get user_applications_delete_url
    assert_response :success
  end

  test "should get destroy" do
    get user_applications_destroy_url
    assert_response :success
  end
end
