require 'rails_helper'

RSpec.describe ControlPanel::StaticPagesController do
  let(:user) { create :user }
  describe "get index" do
    it "don't let you pass if you are not logged in"  do
      get :index
      expect(response).to redirect_to(root_path)
    end
    context "after sign in" do
      before do
        sign_in(user)
      end
      it "let you pass if you are logged in" do
        get :index
        expect(response).to render_template(:index)
        end
    end
  end
end