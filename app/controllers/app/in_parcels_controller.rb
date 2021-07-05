class App::InParcelsController < AppController
  before_action :set_in_parcels_params, only: [:edit, :update, :destroy]

  def index
  end

  def new
  end

  def edit
    options_for_select
    # raise
  end

  def update
    if @in_parcel.update(params_in_parcel)
      redirect_to app_in_payments_path, notice: "A parcela foi editada com sucesso!"
    else
      render :edit
    end
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
    def options_for_select
      # @company_options_for_select = current_user.companies
      @status_options_for_select = [ "A pagar", "Pago", "Em atraso" ]
    end

    def set_in_parcels_params
      @in_parcel = InParcel.find(params[:id])
    end

    def params_in_parcel
      params.require(:in_parcel).permit(
        :due_date, :parcel_number, :status, :value, :invoice_due_date, :paid_day, :in_payment_id,
      )
    end

end
