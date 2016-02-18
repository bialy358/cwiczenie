class ControlPanel::StoriesController < ControlPanel::ControlPanelController

  def index
    board = find_board
    @stories = board.stories
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    @board = find_board
    @story = @board.stories.new
  end

  def create
    @board = find_board
    @story = @board.stories.new(story_params)
    if @story.save
      redirect_to control_panel_board_path(@board), notice: t('shared.created')
    else
      render :new
    end
  end

  def edit
    @board = find_board
    @story = @board.stories.find(params[:id])
  end

  def update
    @board = find_board
    @story = Story.find(params[:id])
    if @story.update(story_params)
      redirect_to control_panel_board_path(@board), notice: t('shared.updated')
    else
      render :edit
    end
  end

  def destroy
    @story = Story.find(params[:id])
    @story.destroy
    redirect_to control_panel_root_path, notice: t('shared.destroyed')
  end

  private

  def story_params
    params.require(:story).permit(:title, :description, :status, :estimate)
  end

  def find_board
    Board.find(params[:board_id])
  end
end