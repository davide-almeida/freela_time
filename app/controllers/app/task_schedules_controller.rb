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
    old_value_parcel = convert_string_time_to_value_cents(old_string_time, @task_schedule.task.project.by_hour.hour_price_cents)
    #raise
    if @task_schedule.update(params_task_schedule)
      work_hour_array = @task_schedule.work_hour.split(":")
      hour = work_hour_array[0].to_i
      minute = work_hour_array[1].to_i

      if @task_schedule.task.project.by_hour != nil
        recurrence = @task_schedule.task.project.by_hour.recurrence
        start_pay_day = @task_schedule.task.project.by_hour.start_pay_day
        hour_price = @task_schedule.task.project.by_hour.hour_price_cents
      end

      @in_payments_actives = @task_schedule.task.project.in_payments.joins(:in_parcels)

      if @in_payments_actives.count == 1
        if recurrence == "Apenas uma vez"
          parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
          parcel_value_cents = @in_payments_actives[0].in_parcels.first.value_cents
          @in_payments_actives[0].in_parcels.first.update_columns(value_cents: (parcel_value_cents - old_value_parcel) + parcel_work_hour)
        elsif recurrence == "Mensal"
          if ((@task_schedule.start_date.to_date && @task_schedule.end_date.to_date) < start_pay_day)
            parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            parcel_value_cents = @in_payments_actives[0].in_parcels.first.value_cents
            @in_payments_actives[0].in_parcels.first.update_columns(value_cents: (parcel_value_cents - old_value_parcel) + parcel_work_hour)
          end
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
        start_pay_day = @task_schedule.task.project.by_hour.start_pay_day
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
          if ((@task_schedule.start_date.to_date && @task_schedule.end_date.to_date) < start_pay_day)
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
          @parcel_date_before = @in_payments_actives.joins(:in_parcels).where("due_date <= ?", task_schedule_start_date..task_schedule_end_date).order("due_date DESC").first.in_parcels.first
          @parcel_date_after = @in_payments_actives.joins(:in_parcels).where("due_date >= ?", task_schedule_start_date..task_schedule_end_date).order("due_date ASC").first.in_parcels.first
          #@parcel_date_before = @task_schedule.task.project.in_payments.joins(:in_parcels).where("due_date <= ?", task_schedule_start_date..task_schedule_end_date).order("due_date DESC").first.in_parcels.first
          #@parcel_date_after = @task_schedule.task.project.in_payments.joins(:in_parcels).where("due_date >= ?", task_schedule_start_date..task_schedule_end_date).order("due_date ASC").first.in_parcels.first
          
          #@in_payments_ordered_asc = @in_payments_actives.joins(:in_parcels).order("due_date ASC")

          if (task_schedule_start_date >= @parcel_date_before.due_date) && (task_schedule_end_date <= @parcel_date_after.due_date)
            parcel_value_cents = @parcel_date_before.value_cents
            #if task_schedule_start_date == @parcel_date_before.due_date
            #  parcel_value_cents = @parcel_date_before.value_cents
            #elsif task_schedule_end_date == @parcel_date_after.due_date
            #  parcel_value_cents = @parcel_date_before.value_cents
            #elsif (task_schedule_start_date > @parcel_date_before.due_date) && (task_schedule_end_date <= @parcel_date_after.due_date)
            #  parcel_value_cents = @parcel_date_before.value_cents
            #end

            parcel_work_hour = (hour * 60 + minute) / 60 * hour_price
            @parcel_date_before.update_columns(value_cents: parcel_value_cents + parcel_work_hour)

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
    if @task_schedule.destroy
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
