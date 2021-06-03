class Company < ApplicationRecord
    belongs_to :user

    has_many :projects, dependent: :destroy
    has_many :tasks, dependent: :destroy
    accepts_nested_attributes_for :projects, allow_destroy: true
    accepts_nested_attributes_for :tasks, allow_destroy: true

    validates :name, :user_id, presence: true
end
