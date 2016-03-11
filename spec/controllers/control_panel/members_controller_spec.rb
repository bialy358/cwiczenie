require 'rails_helper'

RSpec.describe ControlPanel::MembersController do
  let(:owner) { create :user}
  let(:user) { create :user }
  let(:board) { create :board, owner_id: owner.id }
  let(:owner_member) { create :member, user_id: owner.id, board_id: board.id}
  let(:member) { create :member, user_id: user.id, board_id: board.id}

  context "User signed in is not a member" do
    before  { sign_in(user) }

    describe "GET #index" do
      it "redirects to boards#index" do
        get :index, board_id: board.id
        expect(response).to redirect_to control_panel_boards_path
      end

      it "flashes alert" do
        get :index, board_id: board.id
        expect(flash[:alert]).presence
      end
    end

    describe "GET #new" do
      it "redirects to boards#index" do
        get :new, board_id: board.id
        expect(response).to redirect_to control_panel_boards_path
      end

      it "flashes alert" do
        get :new, board_id: board.id
        expect(flash[:alert]).presence
      end
    end

    describe "POST #create" do
      let(:request) { post :create, member: {user_id: 1, board_id: 1}, board_id: board.id}

      it "redirects to boards#index" do
        request
        expect(response).to redirect_to control_panel_boards_path
      end

      it "flashes alert" do
        request
        expect(flash[:alert]).presence
      end

      it "doesn't change Member count" do
        expect { request }.to_not change { Member.count }
      end
    end

    describe "DELETE #destroy" do
      let!(:member) { create :member }
      let(:request) { delete :destroy, board_id: board.id, id: member.id }

      it "doesn't change Member count" do
        expect{ request }.to_not change{ Member.count }
      end

      it "redirects to boards#index" do
        request
        expect(response).to redirect_to control_panel_boards_path
      end

      it "flashes message" do
        request
        expect(flash[:alert]).presence
      end
    end
  end #context "User signed in is not a member"

  context "User signed in is member of board" do
    before do
      sign_in(user)
      member
    end

    describe "GET #index" do
      it "renders index" do
        get :index, board_id: member.board_id
        expect(response).to render_template :index
      end
    end

    describe "GET #new" do
      it "redirects to board path" do
        get :new, board_id: member.board_id
        expect(response).to redirect_to control_panel_board_path(member.board_id)
      end

      it "flashes alert" do
        get :new, board_id: member.board_id
        expect(flash[:alert]).presence
      end
    end

    describe "POST #create" do
      let(:request) { post :create, member: {user_id: 1, board_id: 1}, board_id: member.board_id}

      it "redirects to board path" do
        request
        expect(response).to redirect_to control_panel_board_path(member.board_id)
      end

      it "flashes alert" do
        request
        expect(flash[:alert]).presence
      end

      it "doesn't change Member count" do
        expect { request }.to_not change { Member.count }
      end
    end

    describe "DELETE #destroy" do
      let(:request) { delete :destroy, board_id: member.board_id, id: member.id }

      it "doesn't change Member count" do
        expect{ request }.to_not change{ Member.count }
      end

      it "redirects to board path" do
        request
        expect(response).to redirect_to control_panel_board_path(member.board_id)
      end

      it "flashes message" do
        request
        expect(flash[:alert]).presence
      end
    end
  end #context is member of board

  context "is owner of board" do
    before do
      sign_in(owner)
      owner_member
    end

    describe "GET #index" do
      it "renders index" do
        get :index, board_id: owner_member.board_id
        expect(response).to render_template :index
      end
    end

    describe "GET #new" do
      it "redirects to board path" do
        get :new, board_id: owner_member.board_id
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "success" do
        let(:request) { post :create, member_form: {email: user.email, board_id: owner_member.board_id},
                             board_id: owner_member.board_id }
        it "changes count of Members" do
          expect { request }.to change { Member.count }.by(1)
        end

        it "redirects properly" do
          request
          expect(response).to redirect_to control_panel_board_path(owner_member.board_id)
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
        let(:request) { post :create, member_form: {email: 'abc', board_id: owner_member.board_id},
                               board_id: owner_member.board_id }

        it "renders boards#new" do
          request
          expect(response).to render_template :new
        end

        it "doesn't change Board count" do
          expect { request }.to_not change { Member.count }
        end
      end #context 'failure'
    end

    describe "DELETE #destroy" do
      context "member" do
        let!(:member) { create :member, user_id: user.id, board_id: owner_member.board_id}
        let(:request) { delete :destroy, board_id: owner_member.board_id,id: member.id }

        it "change count of Member by -1" do
          expect{ request }.to change{ Member.count }.by(-1)
        end
        it "redirects to board path" do
          request
          expect(response).to redirect_to control_panel_board_path(owner_member.board.id)
        end

        it "flashes message" do
          request
          expect(flash[:notice]).presence
        end
      end #context "member"

      context "owner" do
        let(:request) { delete :destroy, board_id: owner_member.board_id,id: owner_member.id }
        it "doesn't change Member count" do
          expect{ request }.to_not change{ Member.count }
        end
        it "redirects to board members path" do
          request
          expect(response).to redirect_to control_panel_board_members_path(owner_member.board.id)
        end

        it "flashes message" do
          request
          expect(flash[:alert]).presence
        end
      end #context "owner"
    end
  end #context is owner of board
end