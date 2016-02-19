require 'rails_helper'

RSpec.describe ControlPanel::BoardsController do
  let(:user) { create :user }
  let(:board) {create :board, owner_id: user.id}

  context "User signed in" do
    before { sign_in(user) }

    describe " GET #index" do
      it "renders boards#index" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "GET #new" do
      it "renders boards#new" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      let(:request) { post :create, board: { name: 'cokolwiek' } }

      context "success" do
        it "changes count of Boards" do
          expect { request }.to change { Board.count }.by(1)
        end

        it "redirects properly" do
          request
          expect(response).to redirect_to control_panel_root_path
        end

        it "gives 302 http code" do
          request
          expect(response).to have_http_status(302)
        end

        it "flashes message" do
          request
          expect(flash[:notice]).to eq I18n.t('shared.created')
        end
      end #context 'success'

      context "failure" do
        before do
          allow_any_instance_of(Board).to receive(:save) { false }
          request
        end

        it "renders boards#new" do
          expect(response).to render_template :new
        end

        it "doesn't change Board count" do
          expect { request }.to_not change { Board.count }
        end
      end #context 'failure'
    end

    describe "GET #show" do
      it "renders boards#show" do
        get :show, id: board.id
        expect(response).to render_template :show
      end
    end

    describe "GET #edit" do
      it "renders boards#edit" do
        get :edit, id: board.id
        expect(response).to render_template :edit
      end
    end

    describe "PUT #update" do
      let!(:board) {create :board, owner_id: user.id}
      let!(:params) do
        { id: board.id, board: { name: 'cokolwiek'} }
      end
      let(:request) { put :update, params }

      context "success" do
        it "changes name of boards" do
          expect { request }.to change{ board.reload.name }.to('cokolwiek')
        end

        it "redirects properly" do
          request
          expect(response).to redirect_to control_panel_root_path
        end

        it "gives 302 http code" do
          request
          expect(response).to have_http_status(302)
        end

        it "flashes message" do
          request
          expect(flash[:notice]).to eq I18n.t('shared.updated')
        end
      end #context 'success'

      context "failure" do
        before do
          allow_any_instance_of(Board).to receive(:update) { false }
          request
        end

        it "renders boards#edit" do
          expect(response).to render_template :edit
        end

        it "doesn't change Board name" do
          expect { request }.to_not change{ board.reload.name }
        end
      end #context 'failure'
    end

    describe "DELETE #destroy" do
      let!(:board) { create :board, owner_id: user.id }
      let(:request) { delete :destroy, id: board.id }

      it "change count of Board by -1" do
        expect{ request }.to change{ Board.count }.by(-1)
      end

      it "redirects to root" do
        request
        expect(response).to redirect_to control_panel_root_path
      end

      it "flashes message" do
        request
        expect(flash[:notice]).to eq I18n.t('shared.destroyed')
      end
    end
  end # context 'User signed in'

  context "User not signed in" do
    describe "GET #index" do
      it "renders root"  do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it "flashes user auth warning message" do
        get :index
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end

    describe "GET #new" do
      it "renders root"  do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it "flashes user auth warning message" do
        get :new
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end

    describe "POST #create" do
      let(:request) {post :create, board: {name: 'cokolwiek'} }

      it "doesn't change Board count" do
        expect { request }.to_not change {Board.count}
      end

      it "flashes user auth warning message" do
        request
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end

      it "redirects to root" do
        request
        expect(response).to redirect_to root_path
      end
    end

    describe "GET #show" do
      it "redirects to root" do
        get :show, id: board.id
        expect(response).to redirect_to root_path
      end

      it "flashes user auth warning message" do
        get :show, id: board.id
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end

    describe "GET #edit" do
      it "redirects to root" do
        get :edit, id: board.id
        expect(response).to redirect_to root_path
      end

      it "flashes user auth warning message" do
        get :edit, id: board.id
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end

    describe "PUT #update" do
      let!(:board) {create :board, owner_id: user.id}
      let!(:params) do
        { id: board.id, board: { name: 'cokolwiek'} }
      end
      let(:request) { put :update, params }

      it "doesn't change Board name" do
          expect { request }.to_not change{ board.reload.name }
      end

      it "flashes user auth warning message" do
        request
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end

      it "redirects to root" do
        request
        expect(response).to redirect_to root_path
      end
    end

    describe "DELETE #destroy" do
      let!(:board) { create :board }
      let(:request) { delete :destroy, id: board.id }

      it "redirects to root" do
        request
        expect(response).to redirect_to root_url
      end

      it "doesn't change count of Board" do
        expect{ request }.to_not change{ Board.count }
      end

      it "flashes user auth warning message" do
        request
        expect(flash[:alert]).to eq I18n.t('user.auth.failure')
      end
    end
  end #context 'User not signed in'
end
