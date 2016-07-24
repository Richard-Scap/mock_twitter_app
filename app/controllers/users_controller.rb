class UsersController < ApplicationController
 	before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

 	def index
    @users = User.where(activated: true).paginate(page: params[:page])
    #binding.pry
  end

  def show
  	@user = User.find(params[:id])
    redirect_to(root_url) and return unless @user.activated?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #successful update
      flash[:success] = "Profile updated"
      redirect_to(user_url(@user))
    else
      render 'edit' #unsuccessful update
    end
  end

  def new
  	@user = User.new
  end

  # if user is created send activation email and redirect to root.
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    #binding.pry
    user = User.find(params[:id]) #store user in memory so we can display name in flash message
    User.find(params[:id]).destroy
    flash[:success] = "Successfully deleted #{user.name}"
    redirect_to(users_url)
  end

  private 
    #do not permit users to access :admin attribute of user object
	  def user_params
	    params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

    #before_action filters

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to(login_url)
      end
    end

    #confirms correct user (for access to edit and update actions)
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user     
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
