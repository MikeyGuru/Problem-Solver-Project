require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
  should validate_presence_of(:issue)
  should validate_presence_of(:try)
  should validate_presence_of(:user)

  should belong_to(:user)
  should have_many(:notes)

  context "a problem" do
    setup do
      @problem = problems(:one)
    end

    should "know its note count" do
      assert_equal 1, @problem.note_count
    end

    should "send email when created" do
      @problem2 = Problem.new(issue: problems(:one).issue,
                              try: problems(:one).try,
                              user: problems(:one).user)

      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        @problem2.save
      end
    end
  end
end
