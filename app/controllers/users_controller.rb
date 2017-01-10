class UsersController < ApplicationController

  before_action :set_user, only: [:update_role]

  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 5)
  end

  # PATCH/PUT /profiles/1
  def update_role
    if @user.update(user_params)
      redirect_to :users
      #TODO flash message
    end
  end

  def user_params
    params.require(:user).permit(:role)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

end