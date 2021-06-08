class App::DashboardController < AppController
  def index
    @tasks = current_user.tasks.order(:updated_at).last(3)
    # Task.joins(:task_schedules).where(:task_schedules => {task_id: 2})
    
    # task_scheduler modal form
    @task_schedule = TaskSchedule.new
    options_for_select

    #Reports
    @in_payments_reports = current_user.in_payments.all

    # Report Payable - START
    @report_in_payments_month_payable = @in_payments_reports.joins(:in_parcels).where('status = ?', 0).where("invoice_due_date BETWEEN ? AND ?", Time.zone.now.at_beginning_of_month, Time.zone.now.at_end_of_month)
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
    @report_in_payments_month_payd = @in_payments_reports.joins(:in_parcels).where('status = ?', 1).where("invoice_due_date BETWEEN ? AND ?", Time.zone.now.at_beginning_of_month, Time.zone.now.at_end_of_month)
    @value_sum = 0
    @report_in_payments_month_payd.each do |in_payment|
      in_payment.in_parcels.each do |in_parcel|
        @value_sum = @value_sum + in_parcel.value_cents
      end
    end
    @report_in_payments_month_payd_sum = @value_sum
    @value_sum = 0
    # Report Payd - END
    
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
    @in_payment_json = @in_payments_reports.joins(:in_parcels).where('status = ?', 1).where("invoice_due_date BETWEEN ? AND ?", Time.zone.now.at_beginning_of_year, Time.zone.now.at_end_of_year)
    value_array = []
    @in_payment_json.each do |in_payment|
      value_array << in_payment.in_parcels.first
      # raise
    end
    respond_to do |format|
      format.html
      format.json { render json: value_array }
    end
    # render "receita mensal" json - END

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
      redirect_to app_dashboard_path, notice: "Um novo horário foi cadastrado na tarefa #{@task_schedule.task.name}!"

      # Lógica cadastrar o valor da task_schedule também em um in_parcel com status ema berto - START

      work_hour_array = @task_schedule.work_hour.split(":")
      hour = work_hour_array[0].to_i
      minute = work_hour_array[1].to_i

      if @task_schedule.task.project.by_hour != nil
        recurrence = @task_schedule.task.project.by_hour.recurrence
        start_invoice_day = @task_schedule.task.project.by_hour.start_invoice_day
        hour_price = @task_schedule.task.project.by_hour.hour_price_cents
      end

      @in_payments_actives = @task_schedule.task.project.in_payments.joins(:in_parcels).where("status != ?", 1)

      if @in_payments_actives.count == 1
        if recurrence == "Apenas uma vez"
          parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
          parcel_value_cents = @in_payments_actives[0].in_parcels.first.value_cents
          @in_payments_actives[0].in_parcels.first.update_columns(value_cents: parcel_value_cents + parcel_work_hour)
        elsif recurrence == "Mensal"
          if ((@task_schedule.start_date.to_date && @task_schedule.end_date.to_date) < start_invoice_day)
            parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            parcel_value_cents = @in_payments_actives[0].in_parcels.first.value_cents
            @in_payments_actives[0].in_parcels.first.update_columns(value_cents: parcel_value_cents + parcel_work_hour)
          end
        end
      elsif @in_payments_actives.count > 1
        # if recurrence == "Mensal"
        #   task_schedule_start_date = @task_schedule.start_date.to_date
        #   task_schedule_end_date = @task_schedule.end_date.to_date
        #   @parcel_date_before = @in_payments_actives.joins(:in_parcels).where("invoice_due_date <= ?", task_schedule_start_date..task_schedule_end_date).order("invoice_due_date DESC").first.in_parcels.first
        #   @parcel_date_after = @in_payments_actives.joins(:in_parcels).where("invoice_due_date >= ?", task_schedule_start_date..task_schedule_end_date).order("invoice_due_date ASC").first.in_parcels.first

        #   if (task_schedule_start_date >= @parcel_date_before.invoice_due_date) && (task_schedule_end_date <= @parcel_date_after.invoice_due_date)
        #     parcel_value_cents = @parcel_date_before.value_cents
        #     parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
        #     @parcel_date_before.update_columns(value_cents: parcel_value_cents + parcel_work_hour)

        #   end
        # end
        if recurrence == "Mensal"

          task_schedule_start_date = @task_schedule.start_date.to_date
          task_schedule_end_date = @task_schedule.end_date.to_date
          @parcel_date_after = @in_payments_actives.joins(:in_parcels).where("invoice_due_date >= ?", task_schedule_start_date..task_schedule_end_date).order("invoice_due_date ASC").first.in_parcels.first

          if (task_schedule_start_date >= (@parcel_date_after.invoice_due_date - 1.month)) && (task_schedule_end_date < @parcel_date_after.invoice_due_date)
            parcel_value_cents = @parcel_date_after.value_cents

            parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            @parcel_date_after.update_columns(value_cents: parcel_value_cents + parcel_work_hour)

          end
        end
      end

      # Lógica cadastrar o valor da task_schedule também em um in_parcel com status ema berto - END

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

  private
    def options_for_select
      @company_options_for_select = current_user.companies.all
      @project_options_for_select = current_user.projects.all.where(company_id: :company_id, user_id: current_user.id)
      @task_options_for_select = current_user.tasks.where(project_id: :project_id, user_id: current_user.id).where.not(status: "Concluído")
    end

    # def set_dashboard
    #   @task_schedule = TaskSchedule.find(params[:id])
    # end

    def params_dashboard
      params.require(:task_schedule).permit(:start_date, :end_date, :work_hour, :task_id, :company_id, :project_id)
    end

end
