class Invite < ApplicationRecord
    belongs_to :user

    enum status: ["Aceito", "Recusado", "Pendente"]
    enum invite_type: ["Host", "Guest"]
end
