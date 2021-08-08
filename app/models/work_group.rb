class WorkGroup < ApplicationRecord
    # before_save :add_current_user

    has_many :user_work_groups, dependent: :destroy
    has_many :users, through: :user_work_groups
    
    # accepts_nested_attributes_for :user_work_groups, allow_destroy: true

    # def name_with_email
    #     "#{first_name.first}. #{last_name}"
    # end

    has_many :company
end
