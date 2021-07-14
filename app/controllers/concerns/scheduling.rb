module Scheduling
    extend ActiveSupport::Concern
    
    # Convert work time in value_cents and save in in_payment - START
    def save_in_payment(task_schedule_id)
        @task_schedule = TaskSchedule.find(task_schedule_id)

        convert_string_time_to_array_concern(@task_schedule.work_hour)

        if @task_schedule.task.project.by_hour != nil
            hour_price = @task_schedule.task.project.by_hour.hour_price_cents
            recurrence = @task_schedule.task.project.by_hour.recurrence
            project_start_invoice_date = @task_schedule.task.project.by_hour.start_invoice_day
        end

        convert_string_time_to_value_cents_concern(@task_schedule.work_hour, hour_price)

        @in_payments = @task_schedule.task.project.in_payments

        if @in_payments.count > 0
            @in_parcels = InParcel.joins(:in_payment).eager_load(:in_payment).where(:in_payment_id => @in_payments.ids).where('status != ?', 1)
        end

        task_schedule_start_date = @task_schedule.start_date
        task_schedule_end_date = @task_schedule.end_date

        merge_invoice_date(project_start_invoice_date, task_schedule_start_date, recurrence)
        # verifica se o start_date e o end_date da task_schedule devem ser cadastradas em faturas diferentes (caso precise)
        if (task_schedule_start_date < @first_invoice_date) && (task_schedule_end_date >= @first_invoice_date)
            # Primeira fatura
            @new_parcel_due_date = @first_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            first_worktime = Time.diff(task_schedule_start_date, task_schedule_start_date.end_of_day, '%h:%m:%s')[:diff]
            convert_string_time_to_value_cents_concern(first_worktime, hour_price)
            if (@in_parcels == nil) or (@in_parcels.where(:due_date => @new_parcel_due_date).present? == false)
                # cria a primeira fatura caso ela não exista
                @new_payment = InPayment.new(user_id: current_user.id, project_id: @task_schedule.task.project.id)
                @new_payment.save
                @new_parcel = InParcel.new(in_payment_id: @new_payment.id, value_cents: @work_time, status: 0, parcel_number: 1, due_date: @new_parcel_due_date, invoice_due_date: @first_invoice_date, paid_day: nil)
                @new_parcel.save
                # raise
            else
                # altera a primeira fatura caso ela exista
                @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
                parcel_value_cents = @in_parcel.value_cents
                @in_parcel.update(value_cents: parcel_value_cents + @work_time)
                # raise
            end

            # segunda fatura
            @new_parcel_due_date = @last_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            last_worktime = Time.diff(task_schedule_end_date.beginning_of_day, task_schedule_end_date, '%h:%m:%s')[:diff]
            convert_string_time_to_value_cents_concern(last_worktime, hour_price)
            if @in_parcels.where(:due_date => @new_parcel_due_date).present? == false
                # cria a segunda fatura caso ela não exista
                @new_payment = InPayment.new(user_id: current_user.id, project_id: @task_schedule.task.project.id)
                @new_payment.save
                @new_parcel = InParcel.new(in_payment_id: @new_payment.id, value_cents: @work_time, status: 0, parcel_number: 1, due_date: @new_parcel_due_date, invoice_due_date: @last_invoice_date, paid_day: nil)
                @new_parcel.save
            else
                # altera a segunda fatura caso ela exista
                @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
                parcel_value_cents = @in_parcel.value_cents
                @in_parcel.update(value_cents: parcel_value_cents + @work_time)
            end
        else # Caso NÃO seja necessário cadastrar mais de uma fatura separadamente
            @new_parcel_due_date = @first_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            if (@in_parcels == nil) or (@in_parcels.where(:due_date => @new_parcel_due_date).present? == false)
                # caso seja necessário criar uma nova fatura
                @new_payment = InPayment.new(user_id: current_user.id, project_id: @task_schedule.task.project.id)
                @new_payment.save
                @new_parcel = InParcel.new(in_payment_id: @new_payment.id, value_cents: @work_time, status: 0, parcel_number: 1, due_date: @new_parcel_due_date, invoice_due_date: @last_invoice_date - @recurrence, paid_day: nil)
                @new_parcel.save
            else # caso a fatura já exista e precise apenas atualiza-la
                @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
                parcel_value_cents = @in_parcel.value_cents
                @in_parcel.update_columns(value_cents: parcel_value_cents + @work_time)
            end

        end
    end
    # Convert work time in value_cents and save in in_payment - END

    # Update in_payment - START
    def update_in_payment(task_schedule_id, old_string_time, old_task_schedule_start_date, old_task_schedule_end_date)
        @task_schedule = TaskSchedule.find(task_schedule_id)

        # Definindo start_date e end_date da task_schedule
        task_schedule_start_date = @task_schedule.start_date
        task_schedule_end_date = @task_schedule.end_date

        # Definindo variáveis da task_schedule
        if @task_schedule.task.project.by_hour != nil
            hour_price = @task_schedule.task.project.by_hour.hour_price_cents
            recurrence = @task_schedule.task.project.by_hour.recurrence
            project_start_invoice_date = @task_schedule.task.project.by_hour.start_invoice_day
        end
        
        # Selecionando as parcelas e armazenando em @in_parcels
        @in_payments = @task_schedule.task.project.in_payments
        if @in_payments.count > 0
            @in_parcels = InParcel.joins(:in_payment).eager_load(:in_payment).where(:in_payment_id => @in_payments.ids).where('status != ?', 1)
        end

        # Definindo valor total da hora de trabalho da old_task_schedule
        convert_string_time_to_value_cents_concern(old_string_time, hour_price)
        old_string_time_cents = @work_time

        # REMOVENDO VALORES
        # Verificando se a old_task_schedule ESTAVA dividida em duas faturas
        merge_invoice_date(project_start_invoice_date, old_task_schedule_start_date, recurrence)
        if (old_task_schedule_start_date < @first_invoice_date) && (old_task_schedule_end_date >= @first_invoice_date)
            # Primeira fatura
            @new_parcel_due_date = @first_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            first_worktime = Time.diff(old_task_schedule_start_date, old_task_schedule_start_date.end_of_day, '%h:%m:%s')[:diff]
            convert_string_time_to_value_cents_concern(first_worktime, hour_price)
            # Removendo o valor da primeira fatura
            @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
            parcel_value_cents = @in_parcel.value_cents
            @in_parcel.update(value_cents: parcel_value_cents - @work_time)

            # Segunda fatura
            @new_parcel_due_date = @last_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            last_worktime = Time.diff(old_task_schedule_end_date.beginning_of_day, old_task_schedule_end_date, '%h:%m:%s')[:diff]
            convert_string_time_to_value_cents_concern(last_worktime, hour_price)
            # Removendo o valor da segunda fatura
            @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
            parcel_value_cents = @in_parcel.value_cents
            @in_parcel.update(value_cents: parcel_value_cents - @work_time)

        else
            # Caso a old_task_schedule não tenha sido dividida em duas faturas
            @new_parcel_due_date = @first_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
            parcel_value_cents = @in_parcel.value_cents
            @in_parcel.update_columns(value_cents: parcel_value_cents - old_string_time_cents)
        end

        # ADICIONANDO VALORES
        save_in_payment(@task_schedule.id)
        # Obs.: Foi reaproveitado o método save_in_payment que também é utilizado no momento de criar um novo task_schedule

    end
    # Update in_payment - END

    # (DESTROY)Remove in_payment - START
    def destroy_in_payment(task_id, task_schedule_start_date, task_schedule_end_date, task_schedule_string_time)
        @task = Task.find(task_id)

        # Definindo variáveis da task_schedule
        if @task.project.by_hour != nil
            hour_price = @task.project.by_hour.hour_price_cents
            recurrence = @task.project.by_hour.recurrence
            project_start_invoice_date = @task.project.by_hour.start_invoice_day
        end

        # Selecionando as parcelas e armazenando em @in_parcels
        @in_payments = @task.project.in_payments
        if @in_payments.count > 0
            @in_parcels = InParcel.joins(:in_payment).eager_load(:in_payment).where(:in_payment_id => @in_payments.ids).where('status != ?', 1)
        end

        # Definindo valor total da hora de trabalho da task_schedule
        convert_string_time_to_value_cents_concern(task_schedule_string_time, hour_price)
        string_time_cents = @work_time

        # REMOVENDO VALORES
        # Verificando se a task_schedule ESTAVA dividida em duas faturas
        merge_invoice_date(project_start_invoice_date, task_schedule_start_date, recurrence)
        if (task_schedule_start_date < @first_invoice_date) && (task_schedule_end_date >= @first_invoice_date)
            # Primeira fatura
            @new_parcel_due_date = @first_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            first_worktime = Time.diff(task_schedule_start_date, task_schedule_start_date.end_of_day, '%h:%m:%s')[:diff]
            convert_string_time_to_value_cents_concern(first_worktime, hour_price)
            # Removendo o valor da primeira fatura
            @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
            parcel_value_cents = @in_parcel.value_cents
            @in_parcel.update(value_cents: parcel_value_cents - @work_time)

            # Segunda fatura
            @new_parcel_due_date = @last_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            last_worktime = Time.diff(task_schedule_end_date.beginning_of_day, task_schedule_end_date, '%h:%m:%s')[:diff]
            convert_string_time_to_value_cents_concern(last_worktime, hour_price)
            # Removendo o valor da segunda fatura
            @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
            parcel_value_cents = @in_parcel.value_cents
            @in_parcel.update(value_cents: parcel_value_cents - @work_time)

        else
            # Caso a task_schedule não tenha sido dividida em duas faturas
            @new_parcel_due_date = @first_invoice_date + ((@task_schedule.task.project.by_hour.start_pay_day - @task_schedule.task.project.by_hour.start_invoice_day).to_i).days
            @in_parcel = @in_parcels.find_by_due_date(@new_parcel_due_date)
            parcel_value_cents = @in_parcel.value_cents
            @in_parcel.update_columns(value_cents: parcel_value_cents - string_time_cents)
        end
        
    end
    # (DESTROY)Remove in_payment - END

    # (DESTROY)Remove in_payment from task_page - START
    def destroy_in_payment_from_task(task_schedules_ids, task_id)
        @task = Task.find(task_id)
        @task_schedules = TaskSchedule.find(task_schedules_ids)
        @task_schedules.each do |task_schedule|
            @task_schedule = task_schedule
            task_schedule_start_date = @task_schedule.start_date
            task_schedule_end_date = @task_schedule.end_date
            task_schedule_string_time = @task_schedule.work_hour
            destroy_in_payment(task_id, task_schedule_start_date, task_schedule_end_date, task_schedule_string_time)
        end
    end
    # (DESTROY)Remove in_payment from task_page - END

    private
        def convert_string_time_to_array_concern(string_time)
            work_hour_array = string_time.split(":")
            @array_hour = work_hour_array[0].to_i
            @array_minute = work_hour_array[1].to_i
        end

        def convert_string_time_to_value_cents_concern(string_time, value_hour)
            work_hour_array = string_time.split(":")
            @hour = work_hour_array[0].to_i
            @minute = work_hour_array[1].to_i
            @work_time = (@hour * 60 + @minute) / 60.to_f * (value_hour/100.to_f)
            @work_time = @work_time * 100
            @work_time = @work_time.to_i
        end

        def merge_invoice_date(project_invoice_date, task_schedule_date, recurrence)
            project_invoice_day = project_invoice_date.day
            task_schedule_date = task_schedule_date + 1.month
            task_schedule_month = task_schedule_date.month
            task_schedule_year = task_schedule_date.year
            @first_invoice_date = "#{project_invoice_day}/#{task_schedule_month}/#{task_schedule_year}".to_time.beginning_of_day
            recurrence_identify(recurrence)
            @last_invoice_date = "#{project_invoice_day}/#{task_schedule_month}/#{task_schedule_year}".to_time.beginning_of_day + @recurrence
        end

        def recurrence_identify(recurrence)
            if recurrence == "Mensal"
                @recurrence = 1.month
            elsif recurrence = "Quinzenal"
                @recurrence = 15.days
            elsif recurrence = "Diário"
                @recurrence = 1.day
            else
                @recurrence = 0.day
            end
        end
    
end