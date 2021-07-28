class App::SettingsController < AppController
  before_action :set_settings_params, only: [:edit, :update, :destroy]
  def index
  end

  def new
    @setting = Setting.new
    options_for_select
  end
  
  def create
    @setting = Setting.new(params_setting)
    @setting.user_id = current_user.id
    if @setting.save
      redirect_to edit_app_setting_path(@setting.id), notice: "As configurações foram alteradas com sucesso!"
    else
      render :new
    end
  end

  def edit
    options_for_select
  end

  def update
    if @setting.update(params_setting)
      redirect_to edit_app_setting_path(@setting.id), notice: "As configurações foram alteradas com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    if @setting.destroy
      redirect_to app_dashboard_path, notice: "Configurações excluídas com sucesso!"
    else
      render :edit
    end
  end

  private
    def options_for_select
      @themes_options_for_select = [ "Clear", "Darkcool" ]
    end

    def set_settings_params
      @setting = Setting.find(params[:id])
    end

    def params_setting
      params.require(:setting).permit(:theme, :user_id)
    end

end
