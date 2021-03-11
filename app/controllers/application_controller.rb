require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

  get "/" do
    if Helpers.logged_in?(session)
      redirect '/animes'
    else
      Helpers.set_webpage('index')
      erb :index
    end
  end

end
