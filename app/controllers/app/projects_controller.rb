class App::ProjectsController < AppController
  before_action :set_projects_params, only: [:edit, :update, :destroy]

  def index
    if params[:completed_projects] != "true"
      @projects = current_user.projects.where.not(status: 2)
      @link_projects = app_projects_path(:completed_projects => true)
      @link_projects_button = "Projetos concluídos"
      @projects_page_title = "Projetos pendentes"
      @fa_icon = "fas fa-check"
      @button_class = "btn-primary"
    else
      @projects = current_user.projects.where(status: 2)
      @link_projects = app_projects_path
      @link_projects_button = "Projetos pendentes"
      @projects_page_title = "Projetos concluídos"
      @fa_icon = "fa fa-list-ul"
      @button_class = "btn-success"
    end
  end

  def new
    @projects = Project.all
    @project = Project.new
    options_for_select

    @project.build_by_hour #has_one
    # @project.by_hours.build #has_many
  end

  def create
    # options_for_select
    # if params_project['hour_price'].exclude? ","
    #   params_project['hour_price'] = "#{params_project['hour_price'].gsub('.', '')}0"
    # end
    # params_project['hour_price'].gsub('.', '') #remove point
    @project = Project.new(params_project)
    @project.user_id = current_user.id
    @project.status = 0

    # raise

    if @project.payment_type = "Por hora"
      # if @project.by_hour.recurrence = "Apenas uma vez"

        if @project.save
          @in_payment = InPayment.new(project_id: @project.id, user_id: @project.user_id)
          @in_payment.save
          # puts "Salvou o project"

          if @in_payment.save
            start_pay_day = @project.by_hour.start_pay_day
            start_invoice_day = @project.by_hour.start_invoice_day
            @in_parcel = InParcel.new(in_payment_id: @in_payment.id, value_cents: 0, status: 0, parcel_number: 1, due_date: start_pay_day, invoice_due_date: start_invoice_day, paid_day: nil)
            @in_parcel.save

            if @in_parcel.save
              redirect_to app_projects_path, notice: "O projeto #{@project.name} e seu respectivo pagamento foram cadastrados com sucesso!"
              
              if @project.by_hour.recurrence == "Mensal"
                invoice_due_date = start_invoice_day.beginning_of_day + 1.month
                #invoice_due_date = Time.zone.now + 10.seconds #Para testes
                # App::NewInpaymentWorker.perform_at(invoice_due_date, @project.id) #Remover posteriormente, pq os pagamentos serão gerados ao cadastrar uma task_schedule
              end
            else
              render :new
            end

          else
            render :new
          end

        else
          render :new
        end

      # end
    end

  end

  def edit
    options_for_select
  end

  def update
    if @project.update(params_project)
      redirect_to app_projects_path, notice: "O projeto #{@project.name} foi editado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    project_name = @project.name
    if @project.destroy
      redirect_to app_projects_path, notice: "O projeto #{project_name} e suas respectivas tarefas foram excluídas com sucesso!"
    else
      render :index
    end
  end

  def change_status
    @project = Project.find(params[:project_id])
    @params_status = params[:status]
    if @params_status == "A fazer"
      @project.update(:status => "Em desenvolvimento")
    elsif @params_status == "Em desenvolvimento"
      @project.update(:status => "Concluído")
    elsif @params_status == "Concluído"
      @project.update(:status => "A fazer")
    end

    # redirect
    if params[:completed_projects].nil?
      @redirect_path = app_projects_path
    else
      @redirect_path = app_projects_path(:completed_projects => true)
    end

    redirect_to @redirect_path, notice: "O status do projeto #{@project.name} foi atualizado com sucesso!"
  end

  private
    def options_for_select
      @company_options_for_select = current_user.companies
      @status_options_for_select = ["A fazer", "Em desenvolvimento", "Concluído"]
      @payment_type_options_for_select = [ "Por hora", "Por projeto" ]
      @recurrence_options_for_select_options_for_select = [ "Apenas uma vez", "Semanal", "Quinzenal", "Mensal" ]
    end

    def set_projects_params
      @project = Project.find(params[:id])
    end

    def params_project
      params.require(:project).permit(
        :name, :description, :status, :hour_price, :payment_type, :company_id,
        by_hour_attributes:[:start_pay_day, :start_invoice_day, :hour_price, :recurrence, :_destroy, :id]
      )
    end
    

end
