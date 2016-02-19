class MemberDecorator < Draper::Decorator
  delegate_all

 def give_email(member)
   User.find_by(id: member.user_id).email
 end

end
