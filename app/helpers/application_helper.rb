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
    
end
