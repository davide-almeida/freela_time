class GoalInPayment < ApplicationRecord
  belongs_to :goal

  # enum status: [ "Pendente", "Concluído" ]

  monetize :goal_value_cents
  validates :goal_value, numericality: { greater_than: 0 }
end
