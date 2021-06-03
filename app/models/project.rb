class Project < ApplicationRecord
  belongs_to :company
  belongs_to :user

  has_one :by_hour, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :in_payments, dependent: :destroy
  has_many :project_storages, dependent: :destroy
  accepts_nested_attributes_for :by_hour, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true
  accepts_nested_attributes_for :in_payments, allow_destroy: true
  accepts_nested_attributes_for :project_storages, allow_destroy: true

  validates :name, :company_id, :user_id, presence: true

  enum status: [ "A fazer", "Em desenvolvimento", "Concluído" ]
  enum payment_type: [ "Por hora", "Por projeto" ]

  # Executa o método "hour_price_validation" antes de salvar alguma coisa no BD.
  # before_save :hour_price_validation

  # método para verificar se o campo "hour_price" contem ".". Se sim, o "." será removido.
  # def hour_price_validation
  #   if self.hour_price.include? "."
  #     self.hour_price.gsub('.', '')
  #   end
  # end

end
