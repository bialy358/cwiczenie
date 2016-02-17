require 'rails_helper'

RSpec.describe ControlPanel::BoardsController do
  let(:user) { create :user }
  let(:board) {create :board, owner_id: user.id}
  describe "index" do

    context "before sign in" do
      it "don't let you pass if you are not logged in"  do
        get :index
        expect(response).to redirect_to(root_path)
      end
      it "flashes user auth warning message" do
        get :index
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end

    context "after sign in" do
      before { sign_in(user) }

      it "let you pass if you are logged in" do
        get :index
        expect(response).to render_template :index
        end
    end
  end

  describe "new" do
    it "go into right template" do
      sign_in(user)
      get :new
      expect(response).to render_template :new
    end
  end

  describe "create" do
    let(:request) {post :create, board: {name: 'cokolwiek'} }

    context "success" do
      before { sign_in(user) }

      it "change count of Boards" do
        expect { request }.to change {Board.count}.by(1)
      end

      it "redirects properly" do
        request
        expect(response).to redirect_to control_panel_root_path
      end

      it "give 302 http code" do
        request
        expect(response).to have_http_status(302)
      end
      it "flash message" do
        request
        expect(flash[:notice]).to eq I18n.t('shared.created')
      end
    end

    context "failure" do
      it "couse u are not logged in" do
        expect { request }.to change {Board.count}.by(0)
      end
      it "flashes user auth warning message" do
        request
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end

      it "does not create board" do
        sign_in(user)
        allow_any_instance_of(Board).to receive(:save) { false }
        request
        expect(response).to render_template :new
      end
    end
  end

  describe "show" do
    it "renders show" do
      sign_in(user)
      get :show, id: board.id
      expect(response).to render_template :show
    end

  end

  describe "edit" do
    it "renders edit" do
      sign_in(user)
      get :edit, id: board.id
      expect(response).to render_template :edit
    end
  end

  describe "update" do
    let!(:board) {create :board, owner_id: user.id}
    let!(:params) do
      { id: board.id, board: { name: 'cokolwiek'} }
      end
    let(:request) { put :update, params }

    context "success" do
      before { sign_in(user) }

      it "change name of boards" do
        expect { request }.to change{ board.reload.name }.to('cokolwiek')
      end

      it "redirects properly" do
        request
        expect(response).to redirect_to control_panel_root_path
      end

      it "give 302 http code" do
        request
        expect(response).to have_http_status(302)
      end
      it "flash message" do
        request
        expect(flash[:notice]).to eq I18n.t('shared.updated')
      end
    end

    context "failure" do
      it "does not update board" do
        sign_in(user)
        allow_any_instance_of(Board).to receive(:update) { false }
        request
        expect(response).to render_template :edit
      end
      it "flashes user auth warning message" do
        request
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end
  end

  describe "destroy" do
    let!(:board) { create :board }
    let(:request) { delete :destroy, id: board.id }

    context "user logged in" do
      before do
        sign_in(user)
      end
      it "change count of Board by -1" do
        expect{ request }.to change{ Board.count }.by(-1)
      end
      it "redirects to root" do
        request
        expect(response).to redirect_to control_panel_root_path
      end
      it "flash message" do
        request
        expect(flash[:notice]).to eq I18n.t('shared.destroyed')
      end
    end
    context "user not logged in" do
      it "redirects user to root" do
        request
        expect(response).to redirect_to root_url
      end
      it "don't change count of Board" do
        expect{ request }.to_not change{ Board.count }
      end
      it "flashes user auth warning message" do
        request
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end
  end
end