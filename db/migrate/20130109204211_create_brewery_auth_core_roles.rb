class CreateBreweryAuthCoreRoles < ActiveRecord::Migration
  def change
    create_table :brewery_auth_core_roles do |t|
      t.string    :name,               limit: 128,      nil: false
      t.string    :authorizable_type,  limit: 128,      nil: true
      t.integer   :authorizable_id,                     nil: true

      t.boolean   :hidden,            default: true,    nil: false
    end
    add_index(:brewery_auth_core_roles, [:name, :authorizable_type, :authorizable_id], unique: true, name: 'index_brewery_auth_core_roles_unique')

    create_table :brewery_auth_core_roles_users, id: false do |t|
      t.references :user
      t.references :role

      t.timestamps
    end

    add_index(:brewery_auth_core_roles_users, [:user_id, :role_id], unique: true, name: 'index_brewery_auth_core_roles_users_id')
    add_foreign_key(:brewery_auth_core_roles_users, :brewery_auth_core_users, column: 'user_id')
    add_foreign_key(:brewery_auth_core_roles_users, :brewery_auth_core_roles, column: 'role_id')
  end
end
