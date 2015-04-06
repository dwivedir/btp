class UsersController < ApplicationController

  before_filter :authenticate , :only => [:index, :edit, :update]
  before_filter :correct_user,  :only => [:edit, :update]

  def index
    @users = User.all
    @title = "All users"
  end

  def new
    @user = User.new
    @title="Sign up"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      local_dir = "/#{@user.id}"
      Store.make_local_dir(local_dir)
      flash[:success] = "Welcome to the sample App"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id]) 
    @title = "Edit User"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user, :flash => { :success => "Profile updated" }
    else
      @title = "Edit User"
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless correct_user?(@user)
  end

end
