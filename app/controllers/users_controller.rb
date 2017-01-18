class UsersController < ApplicationController

  before_action :set_user, only: [:update_role]

  # GET /users
  def index
    authorize! :index, User
    @users = User.with_profiles.paginate(:page => params[:page], :per_page => 20)
    if params[:search]
      @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 20)
    end
  end

  # PATCH/PUT /users/1/role
  def update_role
    authorize! :update_role, @user
    if user_params[:role] == "admin"
      authorize! :update_role_to_admin, @user
    end

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