require 'rails_helper'

RSpec.describe ControlPanel::StaticPagesController do
  let(:user) { create :user }
  describe "get index" do
    it "don't let you pass if you are not logged in"  do
      get :index
      expect(response).to redirect_to(root_path)
    end
    it "let you pass if you are logged in" do
      allow(controller).to receive(:current_user).and_return(user)
      get :index
      expect(response).to render_template(:index)
    end
  end


end