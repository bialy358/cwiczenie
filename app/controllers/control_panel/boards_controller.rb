class ControlPanel::BoardsController < ControlPanel::ControlPanelController
  before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @boards = current_user.boards + Board.of_members(current_user)
  end

  def show
    @board = find_board
  end

  def new
    @board = current_user.boards.new
  end
  
  def create
    @board = current_user.boards.new(board_params)
    if @board.save
      redirect_to control_panel_root_path, notice: t('shared.created')
    else
      render :new
    end
  end

  def edit
    @board = find_board
  end

  def update
    @board = find_board
    if @board.update(board_params)
      redirect_to control_panel_root_path, notice: t('shared.updated')
    else
      render :edit
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    redirect_to control_panel_root_path, notice: t('shared.destroyed')
  end

  private
  def find_board
    Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name)
  end

  def require_owner
    return if current_user.id == find_board.owner_id
    redirect_to control_panel_root_path, alert: t('owner.auth.failure')
  end
end