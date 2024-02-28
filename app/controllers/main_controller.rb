class MainController < ApplicationController
  def index
    if admin_signed_in?
      @user = User.find_by(admin_id: current_admin.id)
    end
  end
end
