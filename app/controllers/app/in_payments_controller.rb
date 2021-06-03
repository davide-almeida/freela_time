class App::InPaymentsController < AppController
  def index
    @in_payments = current_user.in_payments.all
    @in_payments_reports = current_user.in_payments.all

    # Report Payable - START
    @report_in_payments_month_payable = @in_payments_reports.joins(:in_parcels).where('status = ?', 0).where("due_date BETWEEN ? AND ?", Time.zone.now.at_beginning_of_month, Time.zone.now.at_end_of_month)
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
    @report_in_payments_month_payd = @in_payments_reports.joins(:in_parcels).where('status = ?', 1).where("due_date BETWEEN ? AND ?", Time.zone.now.at_beginning_of_month, Time.zone.now.at_end_of_month)
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
    
    # Report Payd Annual - START
    @report_in_payments_payd_annual = @in_payments_reports.joins(:in_parcels).where('status = ?', 1).where("due_date BETWEEN ? AND ?", Time.zone.now.at_beginning_of_year, Time.zone.now.at_end_of_year)
    @value_sum = 0
    @report_in_payments_payd_annual.each do |in_payment|
      in_payment.in_parcels.each do |in_parcel|
        @value_sum = @value_sum + in_parcel.value_cents
      end
    end
    @report_in_payments_payd_annual_sum = @value_sum
    @value_sum = 0
    # Report Payd Annual - END
  end

  def new
  end

  def edit
  end
end
