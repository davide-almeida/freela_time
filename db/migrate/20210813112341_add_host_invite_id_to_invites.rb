class AddHostInviteIdToInvites < ActiveRecord::Migration[6.1]
  def change
    add_column :invites, :host_invite_id, :integer
  end
end
