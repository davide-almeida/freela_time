class AddWorkHourToTaskSchedule < ActiveRecord::Migration[6.1]
  def change
    add_column :task_schedules, :work_hour, :string
  end
end
