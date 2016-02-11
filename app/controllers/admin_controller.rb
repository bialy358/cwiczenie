class AdminController < ApplicationController

  before_action :require_admin

  def index
  end

  private

  def require_admin
    if current_user.nil? || !current_user.admin?
      flash[:error] = 'Entrance permited. Admin require'
      redirect_to root_path
    end
  end

end
