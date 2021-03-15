class ChangeCurrentEpToUserCurrentEp < ActiveRecord::Migration[6.1]
  def change
    change_table :animes do |t|
      t.rename :current_ep, :user_current_ep
    end
  end
end
