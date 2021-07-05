class App::GoalsController < AppController
  before_action :set_goal, only: [:edit, :update, :destroy]

  def index
    @goals = current_user.goals.all
  end

  def new
    @goal = Goal.new
    @goal.goal_in_payments.build
    options_for_select
  end

  def create
    @goal = Goal.new(params_goal)
    @goal.user_id = current_user.id
    @goal.goal_in_payments.first.start_date = @goal.goal_in_payments.first.start_date.in_time_zone.beginning_of_day
    @goal.goal_in_payments.first.end_date = @goal.goal_in_payments.first.end_date.in_time_zone.end_of_day
    if @goal.save
      redirect_to app_goals_path, notice: "A meta foi cadastrada com sucesso!"
    else
      render :new
    end  
  end
  

  def edit
    options_for_select
  end

  def update
    if @goal.update(params_goal)
      redirect_to app_goals_path, notice: "A meta foi atualizada com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    if @goal.destroy
      redirect_to app_goals_path, notice: "A meta foi excluída com sucesso!"
    else
      render :index
    end
  end

  private
    def options_for_select
      @goal_type_options_for_select = ["Receita"]
    end

    def set_goal
      @goal = Goal.find(params[:id])
    end

    def params_goal
      params.require(:goal).permit(:goal_type, :user_id,
        goal_in_payments_attributes:[:goal_value, :start_date, :end_date, :goal_id, :_destroy, :id]
      )
    end

end
