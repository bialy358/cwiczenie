class ControlPanel::BoardsController < ControlPanel::ControlPanelController

  def index
    @boards = Board.where(owner_id: current_user.id)
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
      redirect_to control_panel_root_path
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
    redirect_to control_panel_root_path
    else
      render :edit
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    redirect_to control_panel_root_path
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end
end