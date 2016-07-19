class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
  		redirect_to user_url(user.id)  #can also be 'redirect_to user_url(user)' OR 'redirect_to user'
  		flash[:success] = "Login successful!"
  	else
  		flash.now[:danger] = 'User email or password is incorrect.'
  	render 'new'
  	end
  end

  def destroy
  	#rails method which destroys current session
  	reset_session
  	@current_user = nil #remove current user
  	#redirect
  	redirect_to root_url
  end
end
