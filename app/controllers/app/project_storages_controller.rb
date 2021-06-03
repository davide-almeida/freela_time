class App::ProjectStoragesController < AppController
  before_action :set_project_storage, only: [:edit, :update, :destroy]

  def new
    @project_storages = current_user.project_storages.all
    @project_storage = ProjectStorage.new
    options_for_select
  end

  def create
    @project_storage = ProjectStorage.new(params_project_storage)
    @project_storage.user_id = current_user.id
    if @project_storage.save
      redirect_to new_app_project_storage_path, notice: "O arquivo #{@project_storage.name} foi enviado com sucesso!"
    else
      render :new
    end
  end

  def edit
    options_for_select
  end

  def update
    if @project_storage.update(params_project_storage)
      redirect_to new_app_project_storage_path, notice: "O arquivo #{@project_storage.name} foi editado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    project_storage_name = @project_storage.name
    if @project_storage.destroy
      redirect_to new_app_project_storage_path, notice: "O arquivo #{project_storage_name} foi excluído com sucesso!"
    else
      render :new
    end
  end

  private
    def options_for_select
      @project_options_for_select = current_user.projects.all
    end

    def set_project_storage
      @project_storage = current_user.project_storages.find(params[:id])
    end

    def params_project_storage
      params.require(:project_storage).permit(:name, :project_id, :file)
    end
end
