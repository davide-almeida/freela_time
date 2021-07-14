module ApplicationHelper
    ### Sum Time ###
    def sum_time(task)
        @task_schedule_hour = 0
        @task_schedule_minute = 0
        @task_schedule_second = 0

        task.task_schedules.each do |task_schedule|
            task_schedule_array = []
            task_schedule_array = task_schedule.work_hour.split(':')
            @task_schedule_hour += task_schedule_array[0].to_i
            @task_schedule_minute += task_schedule_array[1].to_i
            @task_schedule_second += task_schedule_array[2].to_i
        end
    end

    ### convert time ###
    def minute_to_hour(time)
        @hour = time / 60
        @hour_rest = time % 60
    end

    def second_to_minute(time)
        @minute = time / 60
        @minute_rest = time % 60
    end

    def calc_time(hours, minutes, seconds)
        @calc_hour = 0
        @calc_minute = 0
        @calc_second = 0
        # set second
        second_to_minute(seconds)
        @calc_second = seconds - (@minute * 60)
        @calc_second < 10 ? @calc_second="0#{@calc_second}" : @calc_second # add zero to left
        # set minute
        minute_to_hour(minutes)
        @calc_minute = (minutes - (@hour * 60)) + @minute
        @calc_minute < 10 ? @calc_minute="0#{@calc_minute}" : @calc_minute # add zero to left
        # set hour
        @calc_hour = hours + @hour
        @calc_hour < 10 ? @calc_hour="0#{@calc_hour}" : @calc_hour # add zero to left

        # result is <%= @calc_hour %>:<%= @calc_minute %>:<%= @calc_second %>
    end

    # select recurrence on project page (CRUD)
    RECURRENCE = [
        ["Apenas uma vez", "Apenas uma vez"],
        ["Semanal", "Semanal"],
        ["Quinzenal", "Quinzenal"],
        ["Mensal", "Mensal"]
    ]
    def options_for_recurrence(selected)
        options_for_select(RECURRENCE, selected)
    end
    
    # select goal_type on goal page (CRUD)
    GOAL_TYPE = [
        ["Receita", "Receita"]
    ]
    def options_for_goal_type(selected)
        options_for_select(GOAL_TYPE, selected)
    end

    # select PAYMENT_TYPE_PER_PROJECT on project page (CRUD)
    PAYMENT_TYPE_PER_PROJECT = [
        ["A vista", "A vista"],
        ["Parcelado", "Parcelado"],
    ]
    def options_for_payment_type_per_project(selected)
        options_for_select(PAYMENT_TYPE_PER_PROJECT, selected)
    end

    #Calc percent
    def calc_percent(v1, v2)
        #v1 = equivale a 100%
        #v2 = equivale a X
        (v1*100)/v2.to_f
        #result = (v1*100)/v2.to_f
        #result = result.to_s(:rounded, precision: 2, round_mode: :up)
    end

    # Metas (goal_in_payments)
    def calc_goal_percent(goal_type, goal_value, start_date, end_date)
        if goal_type == "Receita"
            @in_payments = current_user.in_payments.joins(:in_parcels).where("status = ?", 1).where("in_parcels.paid_day BETWEEN ? AND ?", start_date.to_date, end_date.to_date)
            
            @in_parcel_sum = 0
            @in_payments.each do |in_payment|
                in_payment.in_parcels.each do |in_parcel|
                    @in_parcel_sum = @in_parcel_sum + in_parcel.value_cents
                end
            end
            
            # raise
        end
    end

    # Convert string_time to array and convert this to value (work_hour) - I use this in dashboard_report
    def convert_string_time_to_value_cents(string_time, value_hour)
        work_hour_array = string_time.split(":")
        @hour = work_hour_array[0].to_i
        @minute = work_hour_array[1].to_i
        work_hour = (@hour * 60 + @minute) / 60.to_f * value_hour
    end

    
    
end
