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
      match = Helpers.current_user(session).animes.each {|anime| anime.name == params[:name]}.first
      if params[:name] != match.name
        redirect "/animes/#{Anime.new(name: params[:name]).slug}/new"
      else 
       redirect '/animes/search'
      end
    else 
      redirect '/animes/search'
    end
  end

  get '/animes/:slug/new' do
    if Helpers.logged_in?(session)
      Helpers.set_webpage('user')
      @user = Helpers.current_user(session)
      @anime = Anime.new_from_api(params[:slug])
      erb :'animes/new'
    else
      redirect '/login'
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
      @page_user = User.find_by_slug(params[:user_slug])
      @anime = Anime.find_by_id(params[:id])
      Helpers.set_webpage('user') if @page_user.id == @user.id
      erb :'animes/show'
    else
      redirect '/login'
    end
  end

  get '/animes/:user_slug/:anime_slug/:id/edit' do
    if Helpers.logged_in?(session)
      @user = Helpers.current_user(session)
      @page_user = User.find_by_slug(params[:user_slug])
      @anime = Anime.find_by_id(params[:id])
      if @user.id  == @anime.user.id
        Helpers.set_webpage('user')
        erb :'animes/edit'
      else
        redirect "/animes/#{@page_user.slug}/#{@anime.slug}/#{@anime.id}"
      end
    else
      redirect '/login'
    end
  end

  patch '/animes/:user_slug/:anime_slug/:id/edit' do
    if params[:user_content] && params[:user_rating]
      @anime = Anime.find_by_id(params[:id])
      @anime.update(
        user_content: params[:user_content],
        user_rating: params[:user_rating]
      )
      redirect "/animes/#{@anime.user.slug}/#{@anime.slug}/#{@anime.id}"
    else
      redirect "/animes/#{@anime.user.slug}/#{@anime.slug}/#{@anime.id}/edit"
    end
  end

  delete '/animes/:user_slug/:anime_slug/:id/delete' do
    @anime = Anime.find_by_id(params[:id])
    @user = @anime.user
    @anime.delete
    redirect "users/#{@user.slug}"
  end
end