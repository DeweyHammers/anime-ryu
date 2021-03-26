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

  get '/' do
    redirect logged_in? ? '/animes/home' : '/home'
  end

  get "/home" do
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end
  
    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def set_user
      @user ||= User.find_by_slug(params[:user_slug])
    end

    def redirect_if_not_logged_in
      redirect '/login' unless logged_in?
    end
  end
end
