class ControlPanel::BoardsController < ControlPanel::ControlPanelController
  before_action :require_member, except: [:index, :new, :create]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @boards = current_user.boards
  end

  def show
    @board = find_board
  end

  def new
    @board = current_user.boards.new
  end
  
  def create
    @board = current_user.boards.new(board_params)
    @board.owner = current_user
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
    @board = find_board
    @board.destroy
    redirect_to control_panel_root_path, notice: t('shared.destroyed')
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

  def find_board
    Board.find(params[:id])
  end
end