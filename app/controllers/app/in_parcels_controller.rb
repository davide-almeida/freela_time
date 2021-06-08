class App::InParcelsController < AppController
  before_action :set_in_parcels_params, only: [:edit, :update, :destroy]

  def index
  end

  def new
  end

  def edit
  end

  def change_status
    @in_parcel = InParcel.find(params[:in_parcel_id])
    @params_status = params[:status]
    if @params_status == "A pagar"
      @in_parcel.update(:status => "Pago", :paid_day => Date.today)
    elsif @params_status == "Pago"
      @in_parcel.update(:status => "Em atraso", :paid_day => nil)
    elsif @params_status == "Em atraso"
      @in_parcel.update(:status => "A pagar", :paid_day => nil)
    end

    # redirect
    redirect_to app_in_payments_path, notice: "O status do pagamento foi atualizado com sucesso!"
  end

  private
    # def options_for_select
    #   @company_options_for_select = current_user.companies
    #   @status_options_for_select = ["A fazer", "Em desenvolvimento", "Concluído"]
    #   @payment_type_options_for_select = [ "Por hora", "Por projeto" ]
    #   @recurrence_options_for_select_options_for_select = [ "Apenas uma vez", "Semanal", "Quinzenal", "Mensal" ]
    # end

    def set_in_parcels_params
      @in_parcel = InParcel.find(params[:id])
    end

    def params_project
      params.require(:in_parcel).permit(
        :due_date, :parcel_number, :status, :value, :in_payment_id,
      )
    end

end
