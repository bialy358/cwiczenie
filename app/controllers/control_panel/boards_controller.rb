class ControlPanel::BoardsController < ControlPanel::ControlPanelController

  def index
    @boards = current_user.boards
  end

  def show
    @board = Board.find(params[:id])
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
    @board = Board.find(params[:id])
  end

  def update
    @board = Board.find(params[:id])
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

  def board_params
    params.require(:board).permit(:name)
  end
end