class App::FriendsController < AppController
  def index
    @friends = current_user.friends.all
  end

  def destroy_friendship
    friend_id = params['friend'].to_i
    # Groups owned and friend belongs to
    @same_groups_owned = current_user.work_groups.joins(:users).where('users.id = ? and owner_user_id = ?', friend_id, current_user.id).ids
    # groups belongs to and friend is owned
    @same_groups_member = current_user.work_groups.joins(:users).where('users.id = ? and owner_user_id = ?', friend_id, friend_id).ids

    # se o contato NÃO pertence a algum grupo que você é líder e NÃO é líder de nenhum grupo que você pertence
    if ((@same_groups_owned.count < 1) && (@same_groups_member.count < 1))
      # remove contact
      remove_friend(friend_id)
      redirect_to app_friends_path, notice: "O contato #{@friendship_first.friend.first_name} foi excluído com sucesso!" # @friendship_first -> remove_friend()

    # Se o contato Pertence a algum grupo que você é líder e NÃO é líder de nenhum grupo que você pertence
    elsif ((@same_groups_owned.count > 0) && (@same_groups_member.count < 1))
      redirect_alert("Antes de excluir este contato você deve exclui-lo dos grupos que você é líder.")

    # Se o contato NÃO pertence a algum grupo que você é líder, Porém, é líder de algum grupo que você pertence
    elsif ((@same_groups_owned.count < 1) && (@same_groups_member.count > 0))
      redirect_alert("Antes de excluir este contato você deve sair do grupo o qual este contato é líder.")

    # se o contato Pertence a algum grupo que você é líder e É Líder de algum grupo que você pertence 
    elsif ((@same_groups_owned.count > 0) && (@same_groups_member.count > 0))
      redirect_alert("Antes de excluir este contato você deve exclui-lo dos grupos o qual você é líder e você deve sair dos grupos o qual ele é líder.")

    else
      redirect_alert("Houve um erro! Informe a um administrador.")
    end

  end

  def remove_friend(friend_id)
    @friendship_first = current_user.friendships.where(user_id: current_user.id).where(friend_id: friend_id).first
    @friend = current_user.friends.find_by_id(friend_id)
    @friendship_last = @friend.friendships.where(user_id: friend_id).where(friend_id: current_user.id).first

    if @friendship_first.present?
      @friendship_first.destroy
    end

    if @friendship_last.present?
      @friendship_last.destroy
    end
  end

  def redirect_alert(alert_msg)
    redirect_to app_friends_path, alert: alert_msg
  end

end
