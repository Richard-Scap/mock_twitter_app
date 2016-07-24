class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		if user.activated?
        log_in(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or(user_url(user))
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to(root_url)
      end
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
