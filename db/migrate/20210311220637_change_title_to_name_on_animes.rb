class ChangeTitleToNameOnAnimes < ActiveRecord::Migration[6.1]
  def change
    change_table :animes do |t|
      t.rename :title, :name
    end
  end
end
