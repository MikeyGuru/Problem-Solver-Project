require 'test_helper'

class LoginsControllerTest < ActionController::TestCase
	def valid_login_attributes
		{email: users(:one).email,
		 password: "password"}
	end

	def invalid_login_attributes
		{email: "",
		 password: ""}
	end

	context "GET logins#new" do
		setup { get :new }

		should respond_with(:ok)
		should render_template(:new)
	end

	context "POST logins#create" do
		context "when I send invalid information" do
			setup { post :create, invalid_login_attributes }

			should "re-render the form" do
				assert_template :new
			end
		end

		context "when I send valid information" do
			context "if user is activated" do
				setup do
					users(:one).update(activated: true)
					post :create, valid_login_attributes
				end

				should "create new session with user id" do
					assert_equal users(:one).id, session[:current_user_id]
				end

				should "redirect to homepage" do
					assert_redirected_to root_path
				end
			end

			context "if user is not activated" do
				setup { post :create, valid_login_attributes }

				should "redirect to homepage" do
					assert_template 'show', "should show user page to suggest activation"
				end
			end
		end
	end

	context "DELETE logins#destroy" do
		context "when I log out" do
			setup do
				delete :destroy, {}, logged_in_session
			end

			should "set clear out session" do
				assert_nil session[:current_user_id]
			end

			should "send to homepage" do
				assert_redirected_to root_path
			end
		end
	end

end
