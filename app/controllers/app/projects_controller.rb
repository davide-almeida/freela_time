class App::ProjectsController < AppController
  before_action :set_projects_params, only: [:edit, :update, :destroy]
  include Scheduling

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
    @project.build_by_project #has_one
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
    raise
    
    if @project.payment_type == "Por hora"
      @project.by_project = nil
    elsif @project.payment_type == "Por projeto"
      @project.by_hour = nil
    end

    if @project.save
      @in_payment = InPayment.new(project_id: @project.id, user_id: @project.user_id)
      @in_payment.save

      if @in_payment.save     
        if @project.payment_type == "Por hora"
          start_pay_day = @project.by_hour.start_pay_day
          start_invoice_day = @project.by_hour.start_invoice_day

          @in_parcel = InParcel.new(in_payment_id: @in_payment.id, value_cents: 0, status: 0, parcel_number: 1, due_date: start_pay_day, invoice_due_date: start_invoice_day, paid_day: nil)
          @in_parcel.save
        elsif @project.payment_type == "Por projeto"
          start_pay_day = @project.by_project.start_pay_day
          start_invoice_day = @project.by_project.start_invoice_day

          if @project.by_project.payment_type == "À vista"
            @in_parcel = InParcel.new(in_payment_id: @in_payment.id, value_cents: 0, status: 0, parcel_number: 1, due_date: start_pay_day, invoice_due_date: start_invoice_day, paid_day: nil)
            @in_parcel.save

          elsif @project.by_project.payment_type == "Parcelado"
            number_parcels = @project.by_project.total_parcel
            total_value = @project.by_project.total_value_cents
            each_parcel_value = total_value/number_parcels

            recurrence_identify(@project.by_project.recurrence)
            new_start_pay_day = start_pay_day
            new_start_invoice_day = start_invoice_day

            number_parcels.times do |number|
              number += 1
              @in_parcel = InParcel.new(in_payment_id: @in_payment.id, value_cents: each_parcel_value, status: 0, parcel_number: number, due_date: new_start_pay_day, invoice_due_date: new_start_invoice_day, paid_day: nil)
              @in_parcel.save
              new_start_pay_day += @recurrence
              new_start_invoice_day += @recurrence
            end
          end

        end

        if @in_parcel.save
          redirect_to app_projects_path, notice: "O projeto #{@project.name} e seu respectivo pagamento foram cadastrados com sucesso!"
          
          # if @project.by_hour.recurrence == "Mensal"
            # invoice_due_date = start_invoice_day.beginning_of_day + 1.month
            #invoice_due_date = Time.zone.now + 10.seconds #Para testes
            # App::NewInpaymentWorker.perform_at(invoice_due_date, @project.id) #Remover posteriormente, pq os pagamentos serão gerados ao cadastrar uma task_schedule
          # end
        else
          render :new
        end

      else
        render :new
      end

    else
      render :new
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
      redirect_to app_projects_path, notice: "O projeto #{project_name} seus respectivos pagamentos, tarefas e horas de trabalho foram excluídas com sucesso!"
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
        by_hour_attributes:[:start_pay_day, :start_invoice_day, :hour_price, :recurrence, :_destroy, :id],
        by_project_attributes:[:payment_type, :total_value, :total_parcel, :recurrence, :start_invoice_day, :start_pay_day, :_destroy, :id]
      )
    end
    

end
