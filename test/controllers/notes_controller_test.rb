require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  def invalid_note_attributes
    { comment: "" }
  end

  def valid_note_attributes
    { comment: "this is the note" }
  end

  context "POST notes#create" do
    context "when user is not logged in" do
      setup do
        @problem = problems(:one)
        post :create, { problem_id: @problem.id }, { note: invalid_note_attributes }
      end

      should "redirect to new login" do
        assert_redirected_to new_login_path, "should redirect to new login"
      end
    end

    context "when user is logged in" do

      context "when I send invalid information" do
        setup do
          post :create, { problem_id: problems(:one).id, note: invalid_note_attributes }, logged_in_session
        end

        should "instantiate an invalid note object" do
          assert assigns[:note], "Should have a note"
          assert assigns[:note].invalid?, "Should have an invalid note"
        end

        should "redirect to problem" do
          assert_redirected_to problems(:one), "should show problem"
        end
      end

      context "when I send valid information" do
        setup do
          post :create, { problem_id: problems(:one).id, note: valid_note_attributes }, logged_in_session
        end

        should "create a note" do
          assert assigns["note"], "Should have a note"
          assert assigns["note"].persisted?, "Should have saved note in the DB"
        end

        should "show note" do
          assert_redirected_to problems(:one), "Should redirect to show problem"
        end
      end

    end
  end



  context "PATCH :update" do
    context "when a problem creator chooses note" do
      should "change chosen to true" do
        patch :choose, { id: notes(:one) }, logged_in_session
        assert notes(:one).reload.chosen, "should change boolean to true"
      end
    end
  end
end
