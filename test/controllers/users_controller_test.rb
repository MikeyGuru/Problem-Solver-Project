require 'test_helper'

class UsersControllerTest < ActionController::TestCase
	include BCrypt

	def password
		@password ||= Password.new(password_hash)
	end

	def password=(new_password)
		@password = Password.create(new_password)
		self.password_hash = @password
	end

	def valid_user_attributes
		{name: Faker::Name.name,
		 email: Faker::Internet.email,
		 password: "password",
		 password_confirmation: "password"}
	end

	def invalid_user_attributes
		{name: "",
		 email: "",
		 password: "",
		 password_confirmation: ""}
	end

	test "should get new" do
		get :new
		assert_response :ok
	end

	context "POST :create" do
		context "when I send invalid information" do
			setup { post :create, { user: invalid_user_attributes } }

			should "re-render the form" do
				assert_template :new
			end

			should "instantiate an invalid user object" do
				assert assigns["user"], "Should have a user"
				assert assigns["user"].invalid?, "Should have an invalid user"
			end
		end

		context "when I send valid information" do
			setup do
				@user = valid_user_attributes
				post :create, { user: @user }
			end

			should "create a user" do
				assert assigns["user"], "Should have a user"
				assert assigns["user"].persisted?, "Should have saved user in the DB"
				assert_equal @user[:name], assigns["user"].name
			end

			should "send to login show prompt after creating user" do
				assert_redirected_to login_show_path(assigns["user"].id), "Should send to login show"
			end
		end
	end

	context "Verify" do
		context "when I verify with an invalid key" do
			setup do
				@user = users(:one)
				patch :activate, { id: @user.id, activation_key: SecureRandom.uuid }
			end

			should "not verify the user" do
				assert_not @user.reload.activated, "should not verify the user"
			end

			should "send user back to show" do
				assert_template :show, "should send to show"
			end
		end

		context "when I verify with a valid key" do
			setup do
				@user = users(:one)
				patch :activate, { id: @user.id, activation_key: @user.activation_key }
			end

			should "verify the user" do
				assert @user.reload.activated, "should verify the user"
			end

			should "send user to login show page" do
				assert_redirected_to login_show_path(@user), "should send to login show page"
			end
		end
	end
end
