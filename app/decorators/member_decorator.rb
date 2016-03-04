class MemberDecorator < Draper::Decorator
  delegate_all

  def show_email
    User.find(object.user_id).email
  end
end
