class UserMailer < ActionMailer::Base
  default from: "no-reply@example.com"

  def account_activation(id)
    create_mail(id, "User verification for I Need Help!")
  end

  def new_problem(problem_id)
    @problem = Problem.find(problem_id)
    create_mail(@problem.user_id, "Your problem was added to I Need Help!")
  end

  def new_note(note_id)
    @note = Note.find(note_id)
    @problem = @note.problem
    create_mail(@problem.user_id, "A note was added to your problem on I Need Help!")
  end

  private

  def create_mail(user_id,msg)
    @user = User.find(user_id)
    @greeting = "Hello #{@user.name}"
    mail to: @user.email, subject: msg
  end
end
