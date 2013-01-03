class CreateBreweryAuthCoreUsers < ActiveRecord::Migration
  def change
    create_table :brewery_auth_core_users do |t|
      t.string :email,                null: false
      t.string :family_name,          null: true
      t.string :other_names,          null: true
      t.string :new_email,            null: true

      t.boolean :active,              default: false, null: false

      # Password
      t.string :crypted_password,     null: false
      t.string :password_salt,        null: false

      # Tokens
      t.string :persistence_token,    null: false
      t.string :perishable_token,     null: true # Confirmation, reset password, ...
      t.string :single_access_token,  null: true # Used for viewing (private) RSS feeds for example.

      # Login data
      t.integer  :login_count,        default: 0, null: false
      t.datetime :last_request_at,    null: true
      t.datetime :last_login_at,      null: true
      t.datetime :current_login_at,   null: true
      case ActiveRecord::Base.connection.adapter_name.downcase.to_sym
      when :postgresql
        t.inet     :last_login_ip,      null: true
        t.inet     :current_login_ip,   null: true
      else
        t.string     :last_login_ip,      null: true
        t.string     :current_login_ip,   null: true
      end

      t.timestamps
    end

    add_index :brewery_auth_core_users, :email, unique: true
    add_index :brewery_auth_core_users, :persistence_token, unique: true
    add_index :brewery_auth_core_users, :perishable_token, unique: true
    add_index :brewery_auth_core_users, :single_access_token, unique: true

  end
end
