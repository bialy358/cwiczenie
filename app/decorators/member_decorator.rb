class MemberDecorator < Draper::Decorator
  delegate_all

  def show_email(member)
    User.find(member.user_id).email
  end
end
