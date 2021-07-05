class App::TasksController < AppController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  include Scheduling

  def index
    if params[:completed_tasks] != "true"
      @tasks = current_user.tasks.where.not(status: 2)
      @link_tasks = app_tasks_path(:completed_tasks => true)
      @link_tasks_button = "Tarefas concluídas"
      @tasks_page_title = "Tarefas pendentes"
      @fa_icon = "fas fa-check"
      @button_class = "btn-primary"
    else
      @tasks = current_user.tasks.where(status: 2)
      @link_tasks = app_tasks_path
      @link_tasks_button = "Tarefas pendentes"
      @tasks_page_title = "Tarefas concluídas"
      @fa_icon = "fa fa-list-ul"
      @button_class = "btn-success"
    end
  
  end

  def new
    @tasks = current_user.tasks
    @task = Task.new
    options_for_select
  end

  def create
    @task = Task.new(params_task)
    @task.user_id = current_user.id
    # @task.company_id = @task.project.company_id
    if @task.save
      redirect_to app_tasks_path, notice: "A tarefa #{@task.name} foi cadastrada com sucesso!"
    else
      render :new
    end
  end

  def edit
    @tasks = current_user.tasks
    options_for_select
  end

  def update
    if @task.update(params_task)
      redirect_to app_tasks_path, notice: "A tarefa #{@task.name} foi atualizada com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    task_name = @task.name
    task_id = @task.id
    task_string_time = params[:task_total_work_time]
    raise
    destroy_in_payment_from_task(task_string_time, task_id)

    if @task.destroy
      redirect_to app_tasks_path, notice: "A tarefa #{task_name} foi excluida com sucesso!"
    else
      render :index
    end
  end

  def show
  end

  def filter_projects_by_company
    @filtered_projects = Project.where(company_id: params[:selected_company])
    # respond_to do |format|
    #   format.json { render json: @filtered_projects }
    # end
  end

  def change_status
    @task = Task.find(params[:task_id])
    @params_status = params[:status]
    if @params_status == "A fazer"
      @task.update(:status => "Em desenvolvimento")
    elsif @params_status == "Em desenvolvimento"
      @task.update(:status => "Concluído")
    elsif @params_status == "Concluído"
      @task.update(:status => "A fazer")
    end

    # redirect
    if params[:completed_tasks].nil?
      @redirect_path = app_tasks_path
    else
      @redirect_path = app_tasks_path(:completed_tasks => true)
    end

    redirect_to @redirect_path, notice: "O status da tarefa #{@task.name} foi atualizado com sucesso!"
  end

  private
    def options_for_select
      @company_options_for_select = current_user.companies.all
      @project_options_for_select = current_user.projects.all.where(company_id: :company_id)
      @status_options_for_select = ["A fazer", "Em desenvolvimento", "Concluído"]
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def params_task
      params.require(:task).permit(:name, :status, :project_id, :company_id)
    end

end
