class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :company

  has_many :task_schedules, dependent: :destroy
  accepts_nested_attributes_for :task_schedules, allow_destroy: true

  validates :name, :company_id, :user_id, presence: true

  enum status: [ "A fazer", "Em desenvolvimento", "Concluído" ]

end
