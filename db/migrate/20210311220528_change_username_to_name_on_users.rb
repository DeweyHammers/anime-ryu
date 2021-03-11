class ChangeUsernameToNameOnUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.rename :username, :name 
    end
  end
end
