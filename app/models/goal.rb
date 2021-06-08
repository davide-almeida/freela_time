class Goal < ApplicationRecord
  belongs_to :user

  has_many :goal_in_payments, dependent: :destroy
  accepts_nested_attributes_for :goal_in_payments, allow_destroy: true
end
