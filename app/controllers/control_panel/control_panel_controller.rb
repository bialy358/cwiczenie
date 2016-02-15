class ControlPanel::ControlPanelController < ApplicationController
  before_action :require_user
  layout 'control_panel'

  private

  def require_user
    return if current_user
    redirect_to root_path, alert: t('user.auth.failure')
  end

end