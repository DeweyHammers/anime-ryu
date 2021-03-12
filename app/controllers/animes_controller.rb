class AnimesController < ApplicationController
  
  get '/animes' do
    if Helpers.logged_in?(session)
      Helpers.set_webpage('anime_index')
      session[:anime_found] = nil
      @users = User.all
      @user = Helpers.current_user(session)
      erb :'animes/index'
    else
      redirect '/login'
    end 
  end

  get '/animes/new' do
    if Helpers.logged_in?(session)
      @user = Helpers.current_user(session)
      Helpers.set_webpage('user')
      if session[:anime_found]
        @anime = session[:anime_found]
        erb :'animes/new'
      else
        erb :'animes/new'
      end
    else
      redirect '/login'
    end  
  end

  post '/animes/new' do
    if params[:name] != ''
      if params[:remove]
        session[:anime_found] = nil
        redirect '/animes/new'
      end
      session[:anime_found] = Anime.new_from_api(params[:name])
      redirect '/animes/new'
    else
      redirect '/animes/new'
    end
  end
end