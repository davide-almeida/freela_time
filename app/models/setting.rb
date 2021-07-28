class Setting < ApplicationRecord
  belongs_to :user

  enum theme: [ "Clear", "Darkcool" ]

  validates :theme, :user_id, presence: true

  # has_many :payment_informations
  # accepts_nested_attributes_for :payment_informations, allow_destroy: true

end
