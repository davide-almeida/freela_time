class App::GoalsController < AppController
  def index
    @goals = current_user.goals.all
  end

  def new
  end

  def edit
  end
end
