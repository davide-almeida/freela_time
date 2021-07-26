class User < ApplicationRecord

  has_many :companies
  has_many :projects
  has_many :tasks
  has_many :in_payments
  has_many :project_storages
  has_many :goals
  has_one :setting
  accepts_nested_attributes_for :companies, allow_destroy: true
  accepts_nested_attributes_for :projects, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true
  accepts_nested_attributes_for :in_payments, allow_destroy: true
  accepts_nested_attributes_for :project_storages, allow_destroy: true
  accepts_nested_attributes_for :goals, allow_destroy: true
  accepts_nested_attributes_for :setting, allow_destroy: true

  # validates :first_name, :last_name, :email, :password, :password_confirmation, presence: true
  validates_presence_of :first_name, :last_name, :email, :password, :password_confirmation

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
