class CreateAnimes < ActiveRecord::Migration[6.1]
  def change
    create_table :animes do |t|
      t.string :title
      t.string :url 
      t.string :image_url
      t.string :content
      t.integer :user_id
      t.timestamps
    end
  end
end
