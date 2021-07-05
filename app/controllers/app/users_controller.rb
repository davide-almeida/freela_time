class App::UsersController < AppController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    # @users = User.all
  end

  def new
    # @user = User.new
  end

  def create
    # @user = User.new(params_user)
    # if @user.save
    #   redirect_to app_users_path, notice: "O cadastro #{@user.email} foi realizado com sucesso!"
    # else
    #   render :new
    # end
  end

  def edit
  end

  def destroy
    # user_email = @user.email

    # if @user.destroy
    #   redirect_to app_users_path, notice: "O cadastro #{user_email} foi excluido com sucesso!"
    # else
    #   render :index
    # end

  end

  def update
    passwd = params[:user][:password]
    passwd_confirmation = params[:user][:password_confirmation]
    if passwd.blank? && passwd_confirmation.blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(params_user)
      redirect_to edit_app_user_path(current_user.id), notice: "O cadastro #{@user.email} foi atualizado com sucesso!"
    else
      render :edit
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def params_user
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end

end
