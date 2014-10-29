require 'test_helper'

class ProblemsControllerTest < ActionController::TestCase
  def invalid_problem_attributes
    { problem: { issue: "",
                  try: "" } }
  end

  def valid_problem_attributes
    { problem: { issue: "How do I?",
                 try: "I tried this" } }
  end

  context "GET problems#index" do
    setup { get :index }

    should render_template("index")
    should respond_with(:ok)

    should "show problems" do
      assert assigns[:problems], "should load problems"
    end
  end

  context "GET problems#show" do
	  setup { get :show, id: problems(:one) }

	  should render_template("show")
	  should respond_with(:ok)

	  should "show problem" do
		  assert assigns[:problem], "should show specific problem"
	  end
  end

  context "GET problems#new" do
    setup { get :new }

    should "redirect to login page" do
      assert_redirected_to new_login_path
    end
  end

  context "POST#create" do
    context "when user is not logged in" do
      setup { post :create }

      should "redirect to homepage" do
        assert_redirected_to new_login_path
      end
    end

    context "when I send invalid information" do
      setup do
        post :create, invalid_problem_attributes, logged_in_session
      end

      should "re-render the form" do
        assert_template :new
      end

      should "instantiate an invalid problem object" do
        assert assigns[:problem], "Should have a problem"
        assert assigns[:problem].invalid?, "Should have an invalid problem"
      end
    end

    context "when I send valid information" do
      setup do
        post :create, valid_problem_attributes, logged_in_session
      end

      should "create a problem" do
        assert assigns[:problem], "Should have a problem"
        assert assigns[:problem].persisted?, "Should have saved problem in the DB"
      end

      should "show problem" do
        assert_redirected_to problem_path(assigns[:problem]), "Should redirect to show problem"
      end
    end
  end
end
