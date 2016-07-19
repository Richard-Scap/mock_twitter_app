class UsersController < ApplicationController
 	
 	def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

  	if @user.save
      log_in(@user) #log_in method from sessions helper
  		flash[:success] = "Welcome to the Mock Twitter App!"
  		redirect_to user_url(@user)
  	else
  		render 'new'  		
  	end
  end

  private
	  def user_params
	    params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end
end
