class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in(user)
  	  if params[:session][:remember_me] == '1'
        remember(user)
      else
        forget(user)
      end
  		redirect_to user_url(user.id)  #can also be 'redirect_to user_url(user)' OR 'redirect_to user'
  		flash[:success] = "Login successful!"
  	else
  		flash.now[:danger] = 'User email or password is incorrect.'
  	  render 'new'
  	end
  end

  def destroy
    log_out #method in sessions_helper which involves forget method in sessions_helper and deletes user session
  	#redirect to root
  	redirect_to(root_url)
  end
end
