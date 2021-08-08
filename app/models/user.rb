class User < ApplicationRecord

  # belongs_to :user, optional: true
  # has_many :users
  # has_many :friendships, :foreign_key => "user_id", :dependent => :destroy
  # has_many :friend, :class_name => "Friendship", :foreign_key => "friend_id", :dependent => :destroy

  # Social relationships
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  # has_many :received_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  # has_many :received_friends, through: :received_friendships, source: 'user'

  # def active_friends
  #   friends.select{ |friend| friend.friends.include?(self) }  
  # end

  # def pending_friends
  #   friends.select{ |friend| !friend.friends.include?(self) }  
  # end

  def full_name
    [self.first_name, self.last_name].join(' ')
  end


  # Others relacionships
  has_many :companies
  has_many :projects
  has_many :tasks
  has_many :in_payments
  has_many :project_storages
  has_many :goals
  has_one :setting
  has_many :user_contacts
  accepts_nested_attributes_for :companies, allow_destroy: true
  accepts_nested_attributes_for :projects, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true
  accepts_nested_attributes_for :in_payments, allow_destroy: true
  accepts_nested_attributes_for :project_storages, allow_destroy: true
  accepts_nested_attributes_for :goals, allow_destroy: true
  accepts_nested_attributes_for :setting, allow_destroy: true
  # accepts_nested_attributes_for :work_groups, allow_destroy: true

  # validates :first_name, :last_name, :email, :password, :password_confirmation, presence: true
  validates_presence_of :first_name, :last_name, :email, :password, :password_confirmation

  has_many :user_work_groups, dependent: :destroy
  has_many :work_groups, through: :user_work_groups
  # accepts_nested_attributes_for :user_work_groups, allow_destroy: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
