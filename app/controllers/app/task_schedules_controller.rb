class App::TaskSchedulesController < AppController
  before_action :set_task_schedule, only: [:edit, :update, :destroy]
  include Scheduling

  def index
  end

  def edit
    @task = Task.find(params[:task_id])
  end

  # def convert_string_time_to_array(string_time)
  #   hour_array = string_time.split(":")
  #   @array_hour = work_hour_array[0].to_i
  #   @array_minute = work_hour_array[1].to_i
  # end

  # def convert_string_time_to_value_cents(string_time, value_hour)
  #   work_hour_array = string_time.split(":")
  #   @hour = work_hour_array[0].to_i
  #   @minute = work_hour_array[1].to_i
  #   work_hour = (@hour * 60 + @minute) / 60.to_f * value_hour
  # end

  def update
    # old_string_time = @task_schedule.work_hour
    old_task_schedule = @task_schedule
    if @task_schedule.update(old_task_schedule)
      update_in_payment(@task_schedule.id, old_string_time) #Concern Scheduling
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
      save_in_payment(@task_schedule.id) #Concern Scheduling
      # raise
      redirect_to new_app_task_task_schedule_path(params[:task_id]), notice: "Um novo horário foi cadastrado na tarefa #{@task_schedule.task.name}!"
    else
      render :new
    end
  end

  def destroy

    @task_schedule_start_date = @task_schedule.start_date.to_date
    @task_schedule_end_date = @task_schedule.end_date.to_date
    task_schedule_string_time = @task_schedule.work_hour
    if @task_schedule.destroy
      destroy_in_payment(params[:task_id], @task_schedule_start_date, @task_schedule_end_date, task_schedule_string_time) #Concern Scheduling
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
