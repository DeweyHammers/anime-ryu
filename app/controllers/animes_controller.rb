class AnimesController < ApplicationController
  
  get '/animes/home' do
    if logged_in?
      @users = User.all
      erb :'animes/index'
    else
      redirect '/login'
    end 
  end

  get '/animes/search' do
    if logged_in?
      erb :'animes/search'
    else
      redirect '/login'
    end
  end

  post '/animes/search' do 
    if params[:name] != ''
      anime = Anime.new_from_api(params[:name])
      check = current_user.animes.select {|user_anime| user_anime.name == anime.name}.first
      if !check  
        redirect "/animes/new/#{anime.slug}" 
      else 
        flash[:message] = "That anime has already been created!" 
        redirect '/animes/search'
      end
    else
      flash[:message] = "You did not enter a name!" 
      redirect '/animes/search'
    end
  end

  get '/animes/new/:slug' do
    if logged_in?
      @anime = Anime.new_from_api(params[:slug])
      erb :'animes/new'
    else
      redirect '/login'
    end  
  end

  post '/animes/new/:slug' do
    anime = Anime.new_from_api(params[:slug])
    if params[:user_content] != ''
      params[:user_episode] = 1 if params[:user_episode] == 'Current Episode'
      params[:user_rating] = 1 if params[:user_rating] == 'Choose Your Rating'
      anime.update(
        user_content: params[:user_content],
        user_current_ep: params[:user_episode], 
        user_rating: params[:user_rating],
        user: current_user
      )
      redirect "/animes/#{anime.user.slug}/#{anime.slug}"
    else
      flash[:message] = "Please fill out your review!" 
      redirect "/animes/new/#{anime.slug}"
    end
  end

  get '/animes/:user_slug/:anime_slug' do
    if logged_in?
      set_user
      @anime = @user.animes.select {|anime| anime.slug == params[:anime_slug]}.first
      erb :'animes/show'
    else
      redirect '/login'
    end
  end

  get '/animes/:user_slug/:anime_slug/edit' do
    redirect_if_not_logged_in
    set_user
    @anime = @user.animes.select {|anime| anime.slug == params[:anime_slug]}.first
    if @user.id  == current_user.id
      erb :'animes/edit'
    else
      redirect "/animes/#{@user.slug}/#{@anime.slug}"
    end
  end

  patch '/animes/:user_slug/:anime_slug/edit' do
    user = User.find_by_slug(params[:user_slug])
    if user.id == current_user.id
      anime = user.animes.select {|anime| anime.slug == params[:anime_slug]}.first
      if params[:user_content] != '' 
        params[:user_episode] = anime.user_current_ep if params[:user_episode] == 'Change Your Episode'
        params[:user_rating] = anime.user_rating if params[:user_rating] == 'Update Your Rating'
        anime.update(
          user_content: params[:user_content],
          user_current_ep: params[:user_episode],
          user_rating: params[:user_rating]
        )
        redirect "/animes/#{user.slug}/#{anime.slug}"
      else
        flash[:message] = "User review cannot be blank!"
        redirect "/animes/#{user.slug}/#{anime.slug}/edit"
      end
    else 
      redirect "/animes/#{user.slug}/#{anime.slug}"
    end
  end

  delete '/animes/:user_slug/:anime_slug/delete' do
    user = User.find_by_slug(params[:user_slug])
    if user.id == current_user.id
      anime = user.animes.select {|anime| anime.slug == params[:anime_slug]}.first
      anime.delete
    end
    redirect "users/#{user.slug}"
  end
end