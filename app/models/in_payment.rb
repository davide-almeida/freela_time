class InPayment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :in_parcels, dependent: :destroy
  accepts_nested_attributes_for :in_parcels, allow_destroy: true
end
