class Anime < ActiveRecord::Base
  include Slugs::InstanceMethods
  extend Slugs::ClassMethods

  belongs_to :user
  
  def self.new_from_api(name)
    results = Api.get_anime(name)
    Anime.new(
      name: results['title'], 
      url: results['url'], 
      image_url: results['image_url'], 
      synopsis: results['synopsis'],
      episodes: results['episodes']
    )
  end
end