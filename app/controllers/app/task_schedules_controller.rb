class App::TaskSchedulesController < AppController
  before_action :set_task_schedule, only: [:edit, :update, :destroy]

  def index
  end

  def edit
    @task = Task.find(params[:task_id])
  end

  def convert_string_time_to_array(string_time)
    hour_array = string_time.split(":")
    @array_hour = work_hour_array[0].to_i
    @array_minute = work_hour_array[1].to_i
  end

  def convert_string_time_to_value_cents(string_time, value_hour)
    work_hour_array = string_time.split(":")
    @hour = work_hour_array[0].to_i
    @minute = work_hour_array[1].to_i
    work_hour = (@hour * 60 + @minute) / 60 * value_hour
  end

  def update
    old_string_time = @task_schedule.work_hour
    old_string_time_cents = convert_string_time_to_value_cents(old_string_time, @task_schedule.task.project.by_hour.hour_price_cents)
    #raise
    if @task_schedule.update(params_task_schedule)
      work_hour_array = @task_schedule.work_hour.split(":")
      hour = work_hour_array[0].to_i
      minute = work_hour_array[1].to_i

      if @task_schedule.task.project.by_hour != nil
        recurrence = @task_schedule.task.project.by_hour.recurrence
        start_invoice_day = @task_schedule.task.project.by_hour.start_invoice_day
        hour_price = @task_schedule.task.project.by_hour.hour_price_cents
      else
        recurrence = "Apenas uma vez"
      end

      @in_payments = @task_schedule.task.project.in_payments.joins(:in_parcels)

      if @in_payments.count == 1
        if recurrence == "Apenas uma vez"
          parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
          parcel_value_cents = @in_payments[0].in_parcels.first.value_cents
          @in_payments[0].in_parcels.first.update_columns(value_cents: (parcel_value_cents - old_string_time_cents) + parcel_work_hour)
        elsif recurrence == "Mensal"
          if ((@task_schedule.start_date.to_date && @task_schedule.end_date.to_date) < start_invoice_day)
            parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            parcel_value_cents = @in_payments[0].in_parcels.first.value_cents
            @in_payments[0].in_parcels.first.update_columns(value_cents: (parcel_value_cents - old_string_time_cents) + parcel_work_hour)
          end
        end
      elsif @in_payments.count > 1
        task_schedule_start_date = @task_schedule.start_date.to_date
        task_schedule_end_date = @task_schedule.end_date.to_date
        @parcel_date_after = @in_payments.joins(:in_parcels).where("invoice_due_date >= ?", task_schedule_start_date..task_schedule_end_date).order("invoice_due_date ASC").first.in_parcels.first

        if (task_schedule_start_date >= (@parcel_date_after.invoice_due_date - 1.month)) && (task_schedule_end_date < @parcel_date_after.invoice_due_date)
          parcel_value_cents = @parcel_date_after.value_cents

          parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
          @parcel_date_after.update_columns(value_cents: (parcel_value_cents - old_string_time_cents) + parcel_work_hour)

        end
      end


      redirect_to new_app_task_task_schedule_path(params[:task_id]), notice: "O horário foi editado com sucesso!"
    else
      render :edit
    end
  end

  def new
    @task = Task.find(params[:task_id])
    @task_schedules = @task.task_schedules.all
    @task_schedule = TaskSchedule.new
  end

  def create
    @task_schedule = TaskSchedule.new(params_task_schedule)
    @task_schedule.task_id = params['task_id']
    if @task_schedule.save

      # Lógica para salvar o valor da hora de trabalho no financeiro - START
      # (Hora * 60 + Minuto) / 60 * ValorHora

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
          puts "-------------- @in_payments_actives.count == 1 -------- recurrence == Apenas uma vez"
        elsif recurrence == "Mensal"
          if ((@task_schedule.start_date.to_date && @task_schedule.end_date.to_date) < start_invoice_day)
            parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            parcel_value_cents = @in_payments_actives[0].in_parcels.first.value_cents
            @in_payments_actives[0].in_parcels.first.update_columns(value_cents: parcel_value_cents + parcel_work_hour)
            puts "-------------- @in_payments_actives.count == 1 -------- recurrence == Mensal"
          end
        end
      elsif @in_payments_actives.count > 1
        if recurrence == "Mensal"

          task_schedule_start_date = @task_schedule.start_date.to_date
          task_schedule_end_date = @task_schedule.end_date.to_date
          #@parcel_date_before = @in_payments_actives.joins(:in_parcels).where("invoice_due_date <= ?", task_schedule_start_date..task_schedule_end_date).order("invoice_due_date DESC").first.in_parcels.first
          @parcel_date_after = @in_payments_actives.joins(:in_parcels).where("invoice_due_date >= ?", task_schedule_start_date..task_schedule_end_date).order("invoice_due_date ASC").first.in_parcels.first

          if (task_schedule_start_date >= (@parcel_date_after.invoice_due_date - 1.month)) && (task_schedule_end_date < @parcel_date_after.invoice_due_date)
            parcel_value_cents = @parcel_date_after.value_cents

            parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            @parcel_date_after.update_columns(value_cents: parcel_value_cents + parcel_work_hour)

          end
        end
      end

      # Lógica para salvar o valor da hora de trabalho no financeiro - END

      redirect_to new_app_task_task_schedule_path(params[:task_id]), notice: "Um novo horário foi cadastrado na tarefa #{@task_schedule.task.name}!"
    else
      render :new
    end
  end

  def destroy

    @task = Task.find(params[:task_id])
    @task_schedule_start_date = @task_schedule.start_date.to_date
    @task_schedule_end_date = @task_schedule.end_date.to_date
    task_schedule_string_time = @task_schedule.work_hour
    task_schedule_string_time_cents = convert_string_time_to_value_cents(task_schedule_string_time, @task.project.by_hour.hour_price_cents)

    if @task_schedule.destroy

      if @task.project.by_hour != nil
        recurrence = @task.project.by_hour.recurrence
        start_invoice_day = @task.project.by_hour.start_invoice_day
        hour_price = @task.project.by_hour.hour_price_cents
      else
        recurrence = "Apenas uma vez"
      end

      @in_payments = @task.project.in_payments.joins(:in_parcels)
      
      if @in_payments.count == 1

        if recurrence == "Apenas uma vez"
          # parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
          parcel_value_cents = @in_payments[0].in_parcels.first.value_cents
          @in_payments[0].in_parcels.first.update_columns(value_cents: parcel_value_cents - task_schedule_string_time_cents)
        elsif recurrence == "Mensal"
          if ((@task_schedule_start_date && @task_schedule_end_date) < start_invoice_day)
            # parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            parcel_value_cents = @in_payments[0].in_parcels.first.value_cents
            @in_payments[0].in_parcels.first.update_columns(value_cents: parcel_value_cents - task_schedule_string_time_cents)
          end
        end
      elsif @in_payments.count > 1
        if recurrence == "Mensal"
          task_schedule_start_date = @task_schedule_start_date
          task_schedule_end_date = @task_schedule_end_date
          @parcel_date_after = @in_payments.joins(:in_parcels).where("invoice_due_date >= ?", task_schedule_start_date..task_schedule_end_date).order("invoice_due_date ASC").first.in_parcels.first

          if (task_schedule_start_date >= (@parcel_date_after.invoice_due_date - 1.month)) && (task_schedule_end_date < @parcel_date_after.invoice_due_date)
            parcel_value_cents = @parcel_date_after.value_cents

            # parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            @parcel_date_after.update_columns(value_cents: parcel_value_cents - task_schedule_string_time_cents)
          end
        end
      end


      redirect_to new_app_task_task_schedule_path(params[:task_id]), notice: "O horário foi excluído com sucesso!"
    else
      render :new
    end
  end

  private
    def set_task_schedule
      @task_schedule = TaskSchedule.find(params[:id])
    end

    def params_task_schedule
      params.require(:task_schedule).permit(:start_date, :end_date, :work_hour, :task_id)
    end
end
