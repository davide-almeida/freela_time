class App::CompaniesController < AppController
  before_action :set_company_params, only: [:edit, :update, :destroy]

  def index
    @companies = current_user.companies
  end

  def edit
  end

  def update
    if @company.update(params_company)
      redirect_to app_companies_path, notice: "A empresa #{@company.name} foi editada com sucesso!"
    else
      render :edit
    end
  end
  

  def new
    @companies = Company.all
    @company = Company.new
    # @company.user_id = current_user.id
  end

  def create
    @company = Company.new(params_company)
    @company.user_id = current_user.id
    if @company.save
      redirect_to app_companies_path, notice: "A empresa #{@company.name} foi cadastrada com sucesso!"
    else
      render :new
    end
  end

  def destroy
    company_name = @company.name
    if @company.destroy
      redirect_to app_companies_path, notice: "A empresa #{company_name}, seus respectivos projetos, pagamentos, tarefas e horas de trabalho foram excluídas com sucesso!"
    else
      render :new
    end
  end

  private
    def set_company_params
      @company = Company.find(params[:id])
    end

    def params_company
      params.require(:company).permit(:name, :user_id)
    end

end
