class AddBlockedStateToUser < ActiveRecord::Migration
  def change
    change_table :brewery_auth_core_users do |t|
        t.boolean :blocked, default: false
    end
  end
end
