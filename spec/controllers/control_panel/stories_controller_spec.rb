require 'rails_helper'

RSpec.describe ControlPanel::StoriesController do
  context "user logged in" do
    let(:user)  { create :user }
    let(:board) { create :board, owner_id: user.id }
    let(:story) { create :story, board_id: board.id}

    context "User signed in" do
      before { sign_in(user) }

      describe " GET #index" do
        it "renders stories#index" do
          get :index, board_id: board.id
          expect(response).to render_template :index
        end
      end

      describe "GET #new" do
        it "renders stories#new" do
          get :new, board_id: board.id
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        let(:request) { post :create, board_id: board.id, story: { title: 'cokolwiek', estimate: 1} }

        context "success" do
          it "changes count of Stories" do
            expect { request }.to change { Story.count }.by(1)
          end

          it "redirects properly" do
            request
            expect(response).to redirect_to control_panel_board_path(story.board_id)
          end

          it "gives 302 http code" do
            request
            expect(response).to have_http_status(302)
          end

          it "flashes message" do
            request
            expect(flash[:notice]).presence
          end
        end #context 'success'

        context "failure" do
          let(:request) { post :create, board_id: board.id, story: { title: 'cokolwiek', estimate: 10} }

          it "renders stories#new" do
            request
            expect(response).to render_template :new
          end

          it "doesn't change Story count" do
            expect { request }.to_not change { Story.count }
          end
        end #context 'failure'
      end

      describe "GET #show" do
        it "renders stories#show" do
          get :show, board_id: story.board_id,id: story.id
          expect(response).to render_template :show
        end
      end

      describe "GET #edit" do
        it "renders stories#edit" do
          get :edit, board_id: story.board_id,id: story.id
          expect(response).to render_template :edit
        end
      end
      describe "PUT #update" do
        let!(:story) {create :story, board_id: board.id}
        let!(:params) do
          { board_id: story.board_id, id: story.id, story: { title: 'abc'} }
        end
        let(:request) { put :update, params }

        context "success" do
          it "changes story title" do
            expect { request }.to change{ story.reload.title }.to('abc')
          end

          it "redirects properly" do
            request
            expect(response).to redirect_to control_panel_board_path(story.board_id)
          end

          it "gives 302 http code" do
            request
            expect(response).to have_http_status(302)
          end

          it "flashes message" do
            request
            expect(flash[:notice]).presence
          end
        end #context 'success'

        context "failure" do
          let!(:params) do
            { board_id: story.board_id, id: story.id, story: { title: 'abc', estimate: 10} }
          end
          let(:request) { put :update, params }

          it "renders stories#edit" do
            request
            expect(response).to render_template :edit
          end

          it "doesn't change Story title" do
            expect { request }.to_not change{ story.reload.title }
          end
        end #context 'failure'
      end

      describe "DELETE #destroy" do
        let!(:story) { create :story, board_id: board.id }
        let(:request) { delete :destroy, board_id: story.board_id, id: story.id }

        it "change count of Board by -1" do
          expect{ request }.to change{ Story.count }.by(-1)
        end

        it "redirects to root" do
          request
          expect(response).to redirect_to control_panel_board_path(story.board_id)
        end

        it "flashes message" do
          request
          expect(flash[:notice]).presence
        end
      end
    end # context 'User logged in'

    context "User not logged in" do
      describe "GET #index" do
        it "renders root"  do
          get :index, board_id: board.id
          expect(response).to redirect_to(root_path)
        end

        it "flashes user auth warning message" do
          get :index, board_id: board.id
          expect(flash[:alert]).presence
        end
      end

      describe "GET #new" do
        it "renders root"  do
          get :new, board_id: board.id
          expect(response).to redirect_to(root_path)
        end

        it "flashes user auth warning message" do
          get :new, board_id: board.id
          expect(flash[:alert]).presence
        end
      end

      describe "POST #create" do
        let(:request) { post :create, board_id: board.id, story: { title: 'cokolwiek', estimate: 1} }

        it "doesn't change Story count" do
          expect { request }.to_not change {Story.count}
        end

        it "flashes user auth warning message" do
          request
          expect(flash[:alert]).presence
        end

        it "redirects to root" do
          request
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #show" do
        it "redirects to root" do
          get :show, board_id: story.board_id, id: story.id
          expect(response).to redirect_to root_path
        end

        it "flashes user auth warning message" do
          get :show, board_id: story.board_id, id: story.id
          expect(flash[:alert]).presence
        end
      end

      describe "GET #edit" do
        it "redirects to root" do
          get :edit, board_id: story.board_id, id: story.id
          expect(response).to redirect_to root_path
        end

        it "flashes user auth warning message" do
          get :edit, board_id: story.board_id, id: story.id
          expect(flash[:alert]).presence
        end
      end

      describe "PUT #update" do
        let!(:story) {create :story, board_id: board.id}
        let!(:params) do
          { board_id: story.board_id, id: story.id, story: { title: 'abc'} }
        end
        let(:request) { put :update, params }

        it "doesn't change Story title" do
          expect { request }.to_not change{ story.reload.title }
        end

        it "flashes user auth warning message" do
          request
          expect(flash[:alert]).presence
        end

        it "redirects to root" do
          request
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        let!(:story) { create :story, board_id: board.id }
        let(:request) { delete :destroy, board_id: story.board_id, id: story.id }

        it "redirects to root" do
          request
          expect(response).to redirect_to root_url
        end

        it "doesn't change count of Story" do
          expect{ request }.to_not change{ Story.count }
        end

        it "flashes user auth warning message" do
          request
          expect(flash[:alert]).presence
        end
      end
    end # context 'User not looged in'
  end
end