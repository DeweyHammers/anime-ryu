class AddSynopsisAndUserRatingAndWatchedAndCurrentEpsToAnimes < ActiveRecord::Migration[6.1]
  def change
    add_column :animes, :synonyms, :string 
    add_column :animes, :user_rating, :integer
    add_column :animes, :watched, :boolean
    add_column :animes, :current_ep, :integer
  end
end
