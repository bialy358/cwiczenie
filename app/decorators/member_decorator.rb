class MemberDecorator < Draper::Decorator
  delegate_all

  def show_email
    object.user.email
  end
end
