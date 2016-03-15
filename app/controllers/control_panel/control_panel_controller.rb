class ControlPanel::ControlPanelController < ApplicationController
  before_action :require_user
  layout 'control_panel'

  private

  def require_user
    return if current_user
    redirect_to root_path, alert: t('auth.failure.user')
  end

  def require_owner
    return if current_user.id == find_board.owner_id
    redirect_to control_panel_board_path(find_board), alert: t('auth.failure.owner')
  end

  def require_member
    return if current_user.boards.find_by(id: find_board.id)
    redirect_to control_panel_boards_path, alert: t('auth.failure.member')
  end
end