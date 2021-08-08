class App::WorkGroupsController < AppController
  before_action :set_work_group_params, only: [:edit, :update, :destroy, :show]
  def index
    @work_groups = current_user.work_groups.all
  end

  def new
    @work_group = WorkGroup.new
    @work_group.owner_user_id = current_user.id
    options_for_select
  end

  def create
    name = params_work_group["name"]
    description = params_work_group["description"]
    # remove user_id = ""
    @user_ids = params_work_group["user_ids"] - [""]
    #  include current_user.id if not present in @user_ids
    if @user_ids.include?("#{current_user.id}") == false
      @user_ids << "#{current_user.id}"
    end

    @work_group = WorkGroup.new(name: name, description: description, owner_user_id: current_user.id)

    if @work_group.save
      @user_ids.each do |user_id|
        @user_work_group = UserWorkGroup.new(user_id: user_id, work_group_id: @work_group.id)
        @user_work_group.save
      end

      redirect_to app_work_groups_path, notice: "O grupo #{@work_group.name} foi cadastrado com sucesso!"
    else
      render :new
    end
  end

  def edit
    if @work_group.owner_user_id == current_user.id
      options_for_select
    else
      redirect_to app_work_groups_path, alert: "Essa página não existe!"
    end

  end

  def update
    if @work_group.update(params_work_group)
      unless @work_group.users.ids.include?(current_user.id)
        @user_work_group = UserWorkGroup.new(user_id: current_user.id, work_group_id: @work_group.id)
        @user_work_group.save
      end
      redirect_to app_work_groups_path, notice: "O grupo #{@work_group.name} foi alterado com sucesso!"
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    if @work_group.owner_user_id == current_user.id
      work_group_name = @work_group.name
      if @work_group.destroy
        redirect_to app_work_groups_path, notice: "O grupo #{@work_group.name} foi excluído com sucesso!"
      else
        render :new
      end
    else
      redirect_to app_work_groups_path, alert: "O grupo #{@work_group.name} só pode ser excluído pelo seu respectivo líder!"
    end
  end

  private
    def options_for_select
      @user_options_for_select = current_user.friends.all
    end

    def set_work_group_params
      @work_group = WorkGroup.find(params[:id])
    end

    def params_work_group
      params.require(:work_group).permit(:name, :description, :owner_user_id, user_ids: [] )
    end

end
