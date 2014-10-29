require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
	test "account_activation" do
		user = users(:one)
		mail = UserMailer.account_activation(user.id)
		assert_match "User verification", mail.subject
		assert_equal [user.email], mail.to
		assert_equal ["no-reply@example.com"], mail.from
		assert_match "Hello", mail.body.encoded
  end

  test "new_problem" do
    problem = problems(:one)
    mail = UserMailer.new_problem(problem.id)
    assert_match "Your problem was added", mail.subject
    assert_equal [problem.user.email], mail.to
    assert_equal ["no-reply@example.com"], mail.from
    assert_match "Hello", mail.body.encoded
  end

  test "new_note" do
    note = notes(:one)
    mail = UserMailer.new_note(note.id)
    assert_match "A note was added", mail.subject
    assert_equal [note.problem.user.email], mail.to
    assert_equal ["no-reply@example.com"], mail.from
    assert_match "Hello", mail.body.encoded
  end
end
