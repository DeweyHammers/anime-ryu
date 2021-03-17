class Api
  URL = "https://api.jikan.moe/v3/search/anime?q="
  
  def self.get_anime(name)
    page = HTTParty.get("#{URL}#{name}")
    page['results'].first
  end
end