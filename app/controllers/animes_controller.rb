class AnimesController < ApplicationController
  
  get '/animes' do
    if logged_in?
      @users = User.all
      @user = current_user
      erb :'animes/index'
    else
      redirect '/login'
    end 
  end

  get '/animes/search' do
    if logged_in?
      @user = current_user
      erb :'animes/search'
    else
      redirect '/login'
    end
  end

  post '/animes/search' do 
    if params[:name]
      user = current_user
      anime_check = Anime.new_from_api(params[:name])
      check = false
      user.animes.each { |anime| check = true if anime.name == anime_check.name }
      redirect !check ? "/animes/#{Anime.new_from_api(params[:name]).slug}/new" : '/animes/search'
    else 
      redirect '/animes/search'
    end
  end

  get '/animes/:slug/new' do
    if logged_in?
      @user = current_user
      @anime = Anime.new_from_api(params[:slug])
      erb :'animes/new'
    else
      redirect '/login'
    end  
  end

  post '/animes/:slug/new' do
    if params[:user_content] && params[:user_episode] && params[:user_rating]
      @user = current_user
      @anime = Anime.new_from_api(params[:slug])
      @anime.update(
        user_content: params[:user_content],
        user_current_ep: params[:user_episode], 
        user_rating: params[:user_rating]
      )
      @user.animes << @anime
      redirect "/animes/#{@user.slug}/#{@anime.slug}/#{@anime.id}"
    else
      redirect "/animes/#{Anime.new(name: params[:slug]).slug}/new"
    end
  end

  get '/animes/:user_slug/:anime_slug/:id' do
    if logged_in?
      @user = current_user
      @page_user = User.find_by_slug(params[:user_slug])
      @anime = Anime.find_by_id(params[:id])
      erb :'animes/show'
    else
      redirect '/login'
    end
  end

  get '/animes/:user_slug/:anime_slug/:id/edit' do
    if logged_in?
      @user = current_user
      @page_user = User.find_by_slug(params[:user_slug])
      @anime = Anime.find_by_id(params[:id])
      if @user.id  == @anime.user.id
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
        user_current_ep: params[:user_episode],
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