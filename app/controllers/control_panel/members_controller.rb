class ControlPanel::MembersController < ControlPanel::ControlPanelController
before_action :require_owner, except: [:index]
  def index
    @board = find_board
    @members =  @board.members.decorate
  end

  def new
    @board = find_board
    @member = MemberForm.new
  end

  def create
    board = find_board
    @member = MemberForm.new(member_form_params)
    if @member.save
      redirect_to control_panel_board_members_path(board), notice: t('shared.created')
    else
      render :new
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to control_panel_board_members_path, notice: t('shared.destroyed')
  end

  private

  def find_board
    Board.find(params[:board_id])
  end

  def member_form_params
     params.require(:member_form).permit(:email).merge(params.permit(:board_id))
  end

  def require_owner
    return if current_user.id == find_board.owner_id
    redirect_to control_panel_root_path, alert: t('owner.auth.failure')
  end
end