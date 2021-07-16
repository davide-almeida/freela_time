class ByProject < ApplicationRecord
  belongs_to :project

  enum recurrence: [ "Apenas uma vez", "Semanal", "Quinzenal", "Mensal" ]
  enum payment_type: [ "À vista", "Parcelado" ]

  monetize :total_value_cents
  validates :total_value, numericality: { greater_than: 0 }
end
