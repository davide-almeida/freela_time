class App::NewInpaymentWorker
  include Sidekiq::Worker

  # def perform(n1, n2)
  #   # Do something
  #   result = n1 * n2
  #   puts "RESULTADO (mult):"
  #   puts result

    # if result == 4
    #   App::NewInpaymentWorker.perform_at(10.seconds, 2, 5)
    #   puts "Entrou no IF"
    # end
  # end

  def perform(project_id)
    #05/07/2021
    @project = Project.find(project_id)
    
    if @project.status != "Concluído"
      # Verifica se existe alguma parcela desse projeto com a data de vencimento da fatura igual ao dia atual (dia da execução desse worker)
      parcel_status_open_count = @project.in_payments.joins(:in_parcels).where("in_parcels.invoice_due_date" => Time.zone.now.to_date).count

      # Se não existir, um novo pagamento/parcela sera criado com a data atual
      if parcel_status_open_count == 0
        @in_payment = InPayment.new(project_id: @project.id, user_id: @project.user_id)
        @in_payment.save

        if @in_payment.save
          # Verificando o dia da primeira data de vencimento do projeto e atribuindo a variável @due_date_day para montar a data completa de vencimento do novo pagamento na variável due_date.
          @due_date_day = @project.by_hour.start_pay_day.day
          @due_date = "#{@due_date_day}-#{Date.today.month}-#{Date.today.year}"

          due_date = @due_date.to_date
          invoice_due_date = Time.zone.now.to_date
          @in_parcel = InParcel.new(in_payment_id: @in_payment.id, value_cents: 0, status: 0, parcel_number: 1, due_date: due_date, invoice_due_date: invoice_due_date, paid_day: nil)
          @in_parcel.save

          # Se o pagamento e a parcela for criado, será atribuido a data atual + 1 mes a variável due_date e então gerado um novo worker
          # igual a esse, de forma recursiva.
          invoice_due_date = invoice_due_date.beginning_of_day + 1.month
          #invoice_due_date = Time.zone.now + 10.seconds #Para testes
          App::NewInpaymentWorker.perform_at(invoice_due_date, @project.id)

        end
      end

    end

  end

end
