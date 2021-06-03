class ByHour < ApplicationRecord
  belongs_to :project

  enum recurrence: [ "Apenas uma vez", "Semanal", "Quinzenal", "Mensal" ]

  monetize :hour_price_cents
  validates :hour_price, numericality: { greater_than: 0 }
end
