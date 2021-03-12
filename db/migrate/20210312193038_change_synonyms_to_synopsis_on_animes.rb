class ChangeSynonymsToSynopsisOnAnimes < ActiveRecord::Migration[6.1]
  def change
    change_table :animes do |t|
      t.rename :synonyms, :synopsis
    end
  end
end
