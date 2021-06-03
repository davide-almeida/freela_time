class TaskSchedule < ApplicationRecord
  belongs_to :task

  validates :start_date, :end_date, :task_id, :work_hour, presence: true
  # validates :task_id, presence: { message: "O campo TAREFA é obrigatório" }

end
