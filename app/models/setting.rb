class Setting < ApplicationRecord
  belongs_to :user

  # has_many :payment_informations
  # accepts_nested_attributes_for :payment_informations, allow_destroy: true

end
