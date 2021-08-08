class App::UserContactsController < AppController
  def index
    @user_contacts = current_user.friends.all
  end

  def destroy_friendship
    user_contact_id = params['user_contact'].to_i
    if current_user.friends.ids.include?(user_contact_id)

      @friendship_first = current_user.friendships.where(user_id: current_user.id).where(friend_id: user_contact_id).first
      @friend = current_user.friends.find_by_id(user_contact_id)
      @friendship_last = @friend.friendships.where(user_id: user_contact_id).where(friend_id: current_user.id).first

      friend_name = "#{@friendship_first.friend.first_name}"

      if @friendship_first.present?
        @friendship_first.destroy
      end

      if @friendship_last.present?
        @friendship_last.destroy
      end



      redirect_to app_user_contacts_path, notice: "O contato #{friend_name} foi excluido da lista!"

    else
      redirect_to app_user_contacts_path, alert: "Você não pode excluir um contato inexistente!"
    end

  end

end
