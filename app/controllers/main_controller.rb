class MainController < ApplicationController
  def index
    if admin_signed_in?
      @user = User.find_by(admin_id: current_admin.id)
    end
  end

  def help
    if admin_signed_in?
      @user = User.find_by(admin_id: current_admin.id) 
    else
      @user = User.new(level: :visitor)
    end
    
    render 'help', layout: 'help_page'
  end
end
