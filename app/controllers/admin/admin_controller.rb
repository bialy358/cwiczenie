class Admin::AdminController < ApplicationController
  before_action :require_admin
  layout 'admin'

  private

  def require_admin
    return if current_user && current_user.admin
    redirect_to root_path, alert: t('admin.auth.failure')
  end

end