class AnimesController < ApplicationController 
  
  get '/animes' do
    if Helpers.logged_in?(session)
      Helpers.set_webpage('anime_index')
      @user = Helpers.current_user(session)
      erb :'animes/index'
    else
      redirect '/login'
    end 
  end
end