class ControlPanel::MembersController < ControlPanel::ControlPanelController
  before_action :require_member
  before_action :require_owner, except: :index

  def index
    @board = find_board
    @members = @board.members.decorate
  end


  def new
    @board = find_board
    @member_form = MemberForm.new
  end

  def create
    @board = find_board
    @member_form = MemberForm.new(member_form_params)
    if @member_form.save
      redirect_to control_panel_board_path(find_board), notice: t('shared.created')
    else
      render :new
    end
  end

  def destroy
    @board = find_board
    @member = Member.find(params[:id])
    if @board.owner_id == @member.user_id
      redirect_to control_panel_board_members_path(@board), notice: "You can't delete yourself"
    else
      @member.destroy
      redirect_to control_panel_board_path(@board), notice: t('shared.destroyed')
    end
  end

  private

  def find_board
    Board.find(params[:board_id])
  end

  def member_form_params
    params.require(:member_form).permit(:email, :board_id)
  end

end