class UsersController < ApplicationController

  before_action :set_user, only: [:update_role]

  # GET /users
  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 5)
    if params[:search]
      @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 5)
    end
  end

  # PATCH/PUT /users/1
  def update_role
    if @user.update(user_params)
      redirect_to :back, notice: I18n.t('users.successful_role_update')
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