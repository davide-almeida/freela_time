class ProjectStorage < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_one_attached :file
end
