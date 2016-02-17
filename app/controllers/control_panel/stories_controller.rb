class ControlPanel::StoriesController < ControlPanel::ControlPanelController

  def index
    board = Board.find(params[:board_id])
    @stories = board.stories
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    board = Board.find(params[:board_id])
    @story = board.stories.new
  end

  def create
    board = Board.find(params[:board_id])
    @story = board.stories.new(story_params)
    if @story.save
      redirect_to control_panel_root_path, notice: t('shared.created')
    else
      render :new
    end
  end

  def edit
    board = Board.find(params[:board_id])
    @story = board.stories.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])
    if @story.update(story_params)
      redirect_to control_panel_root_path, notice: t('shared.updated')
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
end