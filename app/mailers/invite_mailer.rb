class InviteMailer < ApplicationMailer
    def send_email(current_user_id, email, link)
        @current_user = User.find(current_user_id)
        @email = email
        @link = link
        mail(from: 'FreelaTime <contato@davidealmeida.com.br>', to: @email, subject: "Convite de acesso ao FreelaTime")
    end
end
