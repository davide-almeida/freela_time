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
      # Verifica se existe alguma parcela desse projeto com a data de vencimento igual ao dia atual (dia da execução desse worker)
      parcel_status_open_count = @project.in_payments.joins(:in_parcels).where("in_parcels.due_date" => Time.zone.now.to_date).count

      # Se não existir, um novo pagamento/parcela sera criado com a data atual
      if parcel_status_open_count == 0
        @in_payment = InPayment.new(project_id: @project.id, user_id: @project.user_id)
        @in_payment.save

        if @in_payment.save
          due_date = Time.zone.now.to_date
          @in_parcel = InParcel.new(in_payment_id: @in_payment.id, value_cents: 0, status: 0, parcel_number: 1, due_date: due_date)
          @in_parcel.save

          # Se o pagamento e a parcela for criado, será atribuido a data atual + 1 mes a variável due_date e então gerado um novo worker
          # igual a esse, de forma recursiva.
          due_date = due_date.beginning_of_day + 1.month
          App::NewInpaymentWorker.perform_at(due_date, @project.id)

        end
      end

    end

  end

end
