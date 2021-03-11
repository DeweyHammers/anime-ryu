class RenameContentToUserContentOnAnimes < ActiveRecord::Migration[6.1]
  def change
    change_table :animes do |t|
      t.rename :content, :user_content
    end
  end
end
