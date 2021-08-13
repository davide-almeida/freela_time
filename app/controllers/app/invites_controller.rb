class App::InvitesController < AppController
  before_action :set_invite_params, only: [:destroy]

  def new
    @invites = current_user.invites
    @invite = Invite.new
    options_for_select
  end

  def inviter(user_id, due_date, status, link, invite_type, email, host_invite_id)
    @invite = Invite.new(user_id: user_id, due_date: due_date, status: status, link: link, invite_type: invite_type, email: email, host_invite_id: host_invite_id)
    @invite.save
  end

  def create
    @invite = Invite.new(params_invite)
    # verify if friend exist on your contact list
    @user_guest = User.find_by_email(@invite.email)
    if current_user.friends.include?(@user_guest = User.find_by_email(@invite.email)) == false
      @invite.user_id = current_user.id
      @invite.due_date = Date.today + 5.days
      @invite.status = "Pendente"
      @invite.link = "Sem link"
      @invite.invite_type = "Host"
      @invite.host_invite_id = nil
      # host_params = Rails.application.message_verifier('host').generate(current_user.id) # crypto current_user.id
      if @invite.save
        # email link
        if @user_guest == nil
          host_params = Rails.application.message_verifier('host').generate("#{current_user.id}|#{@invite.id}") # crypto current_user.id
          @invite.update(:link => "#{request.base_url}#{new_user_registration_path(invite:host_params)}") # refatorar
          # send email
          InviteMailer.send_email(current_user.id, @invite.email, @invite.link).deliver_later
        else
          # if guest exist, will create a new invite to him.
          inviter(@user_guest.id, @invite.due_date, @invite.status, @invite.link, "Guest", current_user.email, @invite.id)
        end
        redirect_to new_app_invite_path(current_user.id), notice: "O convite para #{@invite.email} foi criado e um link para cadastrar uma nova conta foi enviado com sucesso!"
      else
        render :new
      end
    else
      redirect_to new_app_invite_path, alert: "Você já possui #{@invite.email} na sua lista de contatos."
    end
  end

  def accept_invite
    @invite = current_user.invites.find(params['invite_id'].to_i)
    @invite_host = Invite.find(@invite.host_invite_id)
    # change invitation to "aceito"
    @invite.update(:status => "Aceito")
    @user_host = @invite_host.user
    @invite_host.update(:status => "Aceito")
    # add friendship
    @friend_host = Friendship.new(user_id: @user_host.id, friend_id: current_user.id)
    @friend_host.save
    @friend_guest = Friendship.new(user_id: current_user.id, friend_id: @user_host.id)
    @friend_guest.save

    redirect_to new_app_invite_path, notice: "O convite recebido por #{@user_host.first_name} foi aceito! Consulte o menu de Contatos."

  end

  def destroy
    email = @invite.email
    if @invite.destroy
      redirect_to new_app_invite_path, notice: "O convite para #{email} foi excluído com sucesso e o link enviado para o email se tornou inválido."
    else
      render :new
    end
  end

  private
    def options_for_select
      @status_options_for_select = ["Aceito", "Recusado", "Pendente"]
    end

    def set_invite_params
      @invite = Invite.find(params[:id])
    end

    def params_invite
      params.require(:invite).permit(:user_id, :email, :link, :due_date, :status, :invite_type, :host_invite_id)
    end

end
