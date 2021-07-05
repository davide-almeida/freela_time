class App::DashboardController < AppController
  include Scheduling

  def index
    #dashboard_array = [] #Utilizado para renderizar o dashboard.json
    # @a = "banana"

    #@tasks = current_user.tasks.order(:updated_at).last(3)
    @tasks = current_user.tasks.joins(:task_schedules).order("task_schedules.updated_at DESC").uniq.first(3)
    # @tasks = @tasks.first(3)
    # raise

    ### Dashboard Reports print (PDF) - START ###
    @dashboard_report_params = "Novo teste"
    ### Dashboard Reports print (PDF) - END ###
    
    
    # task_scheduler modal form
    @task_schedule = TaskSchedule.new
    options_for_select

    #Reports
    @in_payments_reports = current_user.in_payments.all

    # Report Payable - START
    @report_in_payments_month_payable = @in_payments_reports.joins(:in_parcels).where('status = ?', 0).where("due_date BETWEEN ? AND ?", Time.zone.now.at_beginning_of_month, Time.zone.now.at_end_of_month)
    @value_sum = 0
    @report_in_payments_month_payable.each do |in_payment|
      in_payment.in_parcels.each do |in_parcel|
        @value_sum = @value_sum + in_parcel.value_cents
      end
    end
    @report_in_payments_month_payable_sum = @value_sum
    @value_sum = 0
    # Report Payable - END
    
    # Report Payd - START
    # @report_in_payments_month_payd = @in_payments_reports.joins(:in_parcels).where('status = ?', 1).where("paid_day BETWEEN ? AND ?", Time.zone.now.at_beginning_of_month, Time.zone.now.at_end_of_month)
    @report_in_payments_month_payd = current_user.in_payments
    @report_in_parcels_month_payd = InParcel.joins(:in_payment).eager_load(:in_payment).where(:in_payment_id => @report_in_payments_month_payd.ids).group_by_month(:paid_day).where('status = ?', 1).where("paid_day BETWEEN ? AND ?", Time.zone.now.at_beginning_of_month, Time.zone.now.at_end_of_month).sum(:value_cents)
    # Acima está verificando se cada pagamento possui pelo menos uma parcela paga. Verificar isso aqui posteriormente.
    @value_sum = 0
    @report_in_parcels_month_payd.each do |in_parcel|
      @value_sum = @value_sum + in_parcel[1]
    end
    # raise
    # @report_in_payments_month_payd.each do |in_payment|
    #   in_payment.in_parcels.each do |in_parcel|
    #     if in_parcel.status == "Pago"
    #       @value_sum = @value_sum + in_parcel.value_cents
    #     end
    #   end
    # end
    # Verificar isso aqui posteriormente, pois está somando todas as parcelas de cada pagamento.
    @report_in_payments_month_payd_sum = @value_sum
    @value_sum = 0
    # Report Payd - END

    # Report Payd Annual - START
    @report_in_payments_payd_annual = @in_payments_reports.joins(:in_parcels).where('status = ?', 1).where("paid_day BETWEEN ? AND ?", Time.zone.now.at_beginning_of_year, Time.zone.now.at_end_of_year)
    @value_sum = 0
    @report_in_payments_payd_annual.each do |in_payment|
      in_payment.in_parcels.each do |in_parcel|
        @value_sum = @value_sum + in_parcel.value_cents
      end
    end
    @report_in_payments_payd_annual_sum = @value_sum
    @value_sum = 0
    # Report Payd Annual - END
    
    # Report Late Payment - START
    @report_in_payments_late_payment = @in_payments_reports.joins(:in_parcels).where('status = ?', 2)
    @value_sum = 0
    @report_in_payments_late_payment.each do |in_payment|
      in_payment.in_parcels.each do |in_parcel|
        @value_sum = @value_sum + in_parcel.value_cents
      end
    end
    @report_in_payments_late_payment_sum = @value_sum
    @value_sum = 0
    # Report Late Payment - END

    # render "receita mensal" json - START
    @in_payment_paid_year = @in_payments_reports.joins(:in_parcels).where('status = ?', 1).where('paid_day BETWEEN ? AND ?', Date.today.beginning_of_year, Date.today.end_of_year)
    in_parcels_hash = InParcel.joins(:in_payment).eager_load(:in_payment).where(:in_payment_id => @in_payment_paid_year.ids).group_by_month(:paid_day).where('status = ?', 1).sum(:value_cents)
    # raise
    # Lembrar de refatorar isso aqui!!!
    # criando uma hash apenas com mes e valor da receita do respectivo mes {key=>value}
    in_parcels_new_hash = {}
    in_parcels_hash.each do |in_parcel|
      # in_parcels_new_hash.update({in_parcel[0].month => (in_parcel[1]/100)})
      # in_parcels_new_hash.update({in_parcel[0].month => ActionController::Base.helpers.humanized_money(in_parcel[1]/100)})
      in_parcels_new_hash.update({in_parcel[0].month => sprintf('%.2f', in_parcel[1]/100.round(2).to_f)})
      
    end

    12.times do |n|
      n = n+1
      unless in_parcels_new_hash[n].present?
        # in_parcels_new_hash.update({n => 0})
        # in_parcels_new_hash.update({n => ActionController::Base.helpers.humanized_money(0)})
        in_parcels_new_hash.update({n => sprintf('%.2f', 0.round(2).to_f)})
      end
    end
    in_parcels_new_hash = in_parcels_new_hash.sort.to_h

    dashboard_hash = {:in_payments => in_parcels_new_hash}
    #render "receita mensal" json - END

    #render "Armazenamento" json - START
    @project_storages = current_user.project_storages.all
    @storage_sum = 0
    @project_storages.each do |storage|
      @storage_sum += storage.file.byte_size
    end
    @limit_percent = 104857600 #100mb -> (104857600 / 1024 / 1024 = 100)
    @ocuped_percent = calc_percent(@storage_sum, @limit_percent)
    @empty_percent = calc_percent((@storage_sum-@limit_percent), @limit_percent)
    @empty_percent = 100 - @ocuped_percent.round(2)
    @ocuped_percent = @ocuped_percent.to_s(:rounded, precision: 2, round_mode: :up)
    @empty_calc = @limit_percent - @storage_sum
    @empty_calc = @empty_calc.to_s(:human_size)
    @storage_sum = @storage_sum.to_s(:human_size)
    
    storage_hash = {}
    storage_hash.update({'storage_ocuped' => @ocuped_percent, 'storage_empty' => @empty_percent.to_s(:rounded, precision: 2, round_mode: :up)})
    dashboard_hash.update(:storage_percent => storage_hash)
    #render "Armazenamento" json - END

    # Render metas (goals) - START
    @goals = current_user.goals.all
    # Render metas (goals) - END

    #Mount dashboard.json - START
    respond_to do |format|
      format.html
      format.json { render json: dashboard_hash }
    end
    #Mount dashboard.json - END

  end

  ### Sum Time ###
  def sum_time(task)
    @task_schedule_hour = 0
    @task_schedule_minute = 0
    @task_schedule_second = 0

    task.task_schedules.each do |task_schedule|
        task_schedule_array = []
        task_schedule_array = task_schedule.work_hour.split(':')
        @task_schedule_hour += task_schedule_array[0].to_i
        @task_schedule_minute += task_schedule_array[1].to_i
        @task_schedule_second += task_schedule_array[2].to_i
    end
  end

  ### Calc percent ###
  def calc_percent(v1, v2)
    #v1 = equivale a 100%
    #v2 = equivale a X
    (v1*100)/v2.to_f
  end

  def new
    options_for_select
    @task_schedule = TaskSchedule.new
    # @task_schedule.build_task
    # @task_schedule.build_task.build_project
  end
  
  def create
    @task_schedule = TaskSchedule.new(params_dashboard.except(:company_id, :project_id))
    if @task_schedule.save
      save_in_payment(@task_schedule.id) #Concern Scheduling
      redirect_to app_dashboard_path, notice: "Um novo horário foi cadastrado na tarefa #{@task_schedule.task.name}!"
    else
      redirect_to app_dashboard_path, alert: @task_schedule.errors.messages.values[1].join(", ").html_safe
      # raise
    end
  end

  def filter_projects_by_company
    @filtered_projects = Project.where(company_id: params[:selected_company])
  end

  def filter_tasks_by_project
    # @filtered_tasks = Task.where(company_id: params[:selected_company]).where.not(status: "Concluído")
    @filtered_tasks = Task.where(project_id: params[:selected_project]).where.not(status: "Concluído")
  end

  def filter_dashboard_report_projects_by_company
    @filtered_projects = Project.where(company_id: params[:selected_company])
  end

  private
    def options_for_select
      @company_options_for_select = current_user.companies.all
      @project_options_for_select = current_user.projects.all.where(company_id: :company_id, user_id: current_user.id)
      @task_options_for_select = current_user.tasks.where(project_id: :project_id, user_id: current_user.id).where.not(status: "Concluído")

      #dashboard_report
      @company_dashboard_report_options_for_select = current_user.companies.all
      @project_dashboard_report_options_for_select = current_user.projects.all.where(company_id: :company_id, user_id: current_user.id)
    end

    # def set_dashboard
    #   @task_schedule = TaskSchedule.find(params[:id])
    # end

    def params_dashboard
      params.require(:task_schedule).permit(:start_date, :end_date, :work_hour, :task_id, :company_id, :project_id)
    end

end
