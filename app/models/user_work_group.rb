class UserWorkGroup < ApplicationRecord
  belongs_to :user
  belongs_to :work_group

  # accepts_nested_attributes_for :work_group
  # accepts_nested_attributes_for :user
end
