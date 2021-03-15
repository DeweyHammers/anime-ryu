class RemoveWatchedFromAnimes < ActiveRecord::Migration[6.1]
  def change
    remove_column :animes, :watched
  end
end
