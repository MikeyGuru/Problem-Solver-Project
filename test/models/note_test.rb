require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  should validate_presence_of(:comment)
  should validate_presence_of(:user)
  should validate_presence_of(:problem)

  should belong_to(:user)
  should belong_to(:problem)

  context "a note" do
    subject { notes(:one) }

    should "send email if problem was created by different user" do
      new_note = Note.new(comment: notes(:one).comment,
                          problem: problems(:two),
                          user: notes(:two).user)

      assert_not_equal new_note.user, new_note.problem.user, "note and problem users should be different"

      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        new_note.save
      end
    end

    should "not send email if problem was created by same user" do
      new_note = Note.new(comment: notes(:one).comment,
                           problem: problems(:one),
                           user: notes(:two).user)

      assert_equal new_note.user, new_note.problem.user, "note and problem users should be the same"

      assert_difference 'ActionMailer::Base.deliveries.size', 0 do
        new_note.save
      end
    end

    should "not be allowed to be chosen if problem already resolved" do
      note = Note.create(comment: "blah", user: users(:two), problem: problems(:one_resolved), chosen: true)
      assert note.invalid?
    end
  end
end
