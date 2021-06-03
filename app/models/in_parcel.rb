class InParcel < ApplicationRecord
  belongs_to :in_payment

  enum status: [ "A pagar", "Pago", "Em atraso" ]

  monetize :value_cents
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
