class LoginsController < ApplicationController
	def new
	end

	def create
		@user = User.find_by(email: params[:email])

		if @user && @user.authenticate(params[:password])
			if @user.activated
				session[:current_user_id] = @user.id
				redirect_to root_path, success: "You are successfully logged in."
			else
        flash.now[:info] = "You have not been logged in."
        render :show
			end
		else
			flash.now[:alert] = "Your email and password were invalid."
      render :new
    end
	end

	def destroy
		session[:current_user_id] = nil
		redirect_to root_path, success: "You have been logged out."
	end

	def show
		@user = User.find(params[:id])
	end
end
