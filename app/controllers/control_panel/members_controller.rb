class ControlPanel::MembersController < ControlPanel::ControlPanelController
before_action :require_owner, except: :index

  def index
    @board = find_board
    @members = @board.members.all.decorate
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @board = find_board
    @member_form = MemberForm.new
  end

  def create
    @board = find_board
    @member_form = MemberForm.new(member_form_params)
    if @member_form.save
      redirect_to control_panel_board_path(find_board)
    else
      render :new
    end
  end

  def destroy
    @board =find_board
    @members = @board.members.all.decorate
    @member = Member.find(params[:id])
    if @board.owner_id == @member.user_id

      render :index
    else
      @member.destroy
      redirect_to control_panel_board_path(find_board)
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