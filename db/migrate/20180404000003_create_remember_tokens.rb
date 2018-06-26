class CreateRememberTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :remember_tokens do |t|
      t.string :token
      t.datetime :expires_at
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :remember_tokens, [ :user_id, :token]
  end
end
