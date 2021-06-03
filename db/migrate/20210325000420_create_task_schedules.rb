class CreateTaskSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :task_schedules do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
