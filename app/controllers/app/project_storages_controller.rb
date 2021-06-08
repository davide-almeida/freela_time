class App::ProjectStoragesController < AppController
  before_action :set_project_storage, only: [:edit, :update, :destroy]

  def calc_percent(v1, v2)
    #v1 = equivale vale a 100%
    #v2 = equivale vale a X
    (v1*100)/v2.to_f
  end

  def new
    @project_storages = current_user.project_storages.all
    @project_storage = ProjectStorage.new
    options_for_select

    @storage_sum = 0
    @project_storages.each do |storage|
      @storage_sum += storage.file.byte_size
    end
    @limit_percent = 104857600 #100mb -> (104857600 / 1024 / 1024 = 100)
    @ocuped_percent = calc_percent(@storage_sum, @limit_percent)
    @ocuped_percent = @ocuped_percent.to_s(:rounded, precision: 2, round_mode: :up)
    
    
    # @ocuped_percent = calc_percent(@limit_percent, @storage_sum)

    # @ocuped_percent = @ocuped_percent.to_s(:human_size)
    @storage_sum = @storage_sum.to_s(:human_size)

    

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
