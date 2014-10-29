class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			redirect_to login_show_path(@user), success: "Thank you for registering."
		else
			render :new
		end

	end

	def activate
		if valid_key?
			@user.update(activated: true)
			redirect_to login_show_path(@user), success: "User account successfully activated."
		else
			render :show, error: "User activation failed. Please double check email or request new activation key."
		end
	end

	private

	def valid_key?
		@user = User.find_by(activation_key: params[:activation_key])
	end

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end
