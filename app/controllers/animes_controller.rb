class AnimesController < ApplicationController
  
  get '/animes' do
    if Helpers.logged_in?(session)
      Helpers.set_webpage('anime_index')
      @users = User.all
      @user = Helpers.current_user(session)
      erb :'animes/index'
    else
      redirect '/login'
    end 
  end

  get '/animes/search' do
    if Helpers.logged_in?(session)
      @user = Helpers.current_user(session)
      Helpers.set_webpage('user')
      erb :'animes/search'
    else
      redirect '/login'
    end
  end

  post '/animes/search' do 
    if params[:name] 
     redirect "/animes/#{Anime.new(name: params[:name]).slug}/new"
    else 
     erb :'/animes/search'
    end
  end

  get '/animes/:slug/new' do
    if Helpers.logged_in?(session)
      Helpers.set_webpage('user')
      @user = Helpers.current_user(session)
      @anime = Anime.new_from_api(params[:slug])
      erb :'animes/new'
    else
      redirect '/'
    end  
  end

  post '/animes/:slug/new' do
    if params[:user_content] && params[:user_rating]
      @user = Helpers.current_user(session)
      @anime = Anime.new_from_api(params[:slug])
      @anime.update(
        user_content: params[:user_content], 
        user_rating: params[:user_rating]
      )
      @user.animes << @anime
      redirect "/animes/#{@user.slug}/#{@anime.slug}/#{@anime.id}"
    else
      redirect "/animes/#{Anime.new(name: params[:slug]).slug}/new"
    end
  end

  get '/animes/:user_slug/:anime_slug/:id' do
    if Helpers.logged_in?(session)
      @user = Helpers.current_user(session)
      @anime = Anime.find_by_id(params[:id])
      erb :'animes/show'
    else
      redirect '/login'
    end
  end
end