class App::DashboardReportsController < AppController
  before_action :params_dashboard_report
  def index
  end

  ### action print inpayment report (relatório receita) - START ###
  def print_in_payment_report
    @company = current_user.companies.find(params[:dashboard_report][:company_id])
    @project = @company.projects.find(params[:dashboard_report][:project_id])
    @tasks = @project.tasks
    @start_date = params[:dashboard_report][:start_date].to_date.beginning_of_day
    @end_date = params[:dashboard_report][:end_date].to_date.end_of_day

    @task_schedules = TaskSchedule.joins(:task).eager_load(:task).where(:task_id => @tasks.ids).where('start_date >= ?', @start_date).where('end_date <= ?', @end_date)
    
    @tasks_list = @tasks
    @task_schedules.each do |task_schedule|
      unless @tasks_list.include?(task_schedule.task)
        @tasks_list << task_schedule.task
      end
    end

  end
  ### action print inpayment report (relatório receita) - END ###

  private
    def options_for_select
      @company_options_for_select = current_user.companies.all
      @project_options_for_select = current_user.projects.all.where(company_id: :company_id, user_id: current_user.id)
      @task_options_for_select = current_user.tasks.where(project_id: :project_id, user_id: current_user.id).where.not(status: "Concluído")
    end
    
    def params_dashboard_report
      # params.require(:dashboard_report).permit!
      params.permit!
      # params.permit!
    end

end
