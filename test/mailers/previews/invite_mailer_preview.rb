class InviteMailerPreview < ActionMailer::Preview
    default from: 'contato@davidealmeida.com.br'
    def send_email
        InviteMailer.send_email(User.first.id, "davide.jhonatan@gmail.com", "www.google.com.br")
    end
end