class Helpers
  def self.logged_in?(session)
    !!session[:user_id]
  end

  def self.current_user(session)
    User.find(session[:user_id])
  end

  def self.set_webpage(page)
    @webpage = page
  end

  def self.webpage
    @webpage
  end
end