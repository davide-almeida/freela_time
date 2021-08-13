# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
    
    # add group to new user
    # @workgroup = WorkGroup.new(name: "Grupo #{@user.first_name}", description: "Grupo de trabalho #{@user.first_name}", owner_user_id: @user.id)
    # @workgroup.save
    # UserWorkGroup.create!(user_id: @user.id, work_group_id: @workgroup.id)
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # raise
    # add user host to user invited and update invite status if present
    if params['user']['invite'].present?
      # add user_id to host_id
      host_params = Rails.application.message_verifier('host').verify(params['user']['invite']).split('|')
      # update invite status to "aceito"
      @invite = Invite.find(host_params[1].to_i)
      if @invite.status == "Pendente"
        @invite.update(:status => "Aceito")
        # set host_id
        @user.update(:host_id => host_params[0].to_i)
        # add contact to host and add contact to new user
        Friendship.create!(user_id: host_params[0].to_i, friend_id: @user.id) #User Host have User Friend like a friend
        Friendship.create!(user_id: @user.id, friend_id: host_params[0].to_i) #User Friend have User Host like a friend
      else
        @user.update(:host_id => nil)
      end
    else
      @user.update(:host_id => nil)
    end

    super(resource)

    app_dashboard_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
