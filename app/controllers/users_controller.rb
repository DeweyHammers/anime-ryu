class UsersController < ApplicationController 

  get '/sign-up' do
    if logged_in?
      redirect '/animes'
    else 
      erb :'users/new'
    end
  end

  post '/sign-up' do
    if params[:name] && params[:email] && params[:password] && params[:password_confirmation] &&
       !User.find_by(name: params[:name], email: params[:email]) &&
       params[:password] == params[:password_confirmation] && 
       params[:password].length >= 8 
        user = User.create(params)
        session['user_id'] = user.id
        redirect "/animes"
    else
      redirect '/sign-up'
    end 
  end

  
  get '/users/:slug' do
    if logged_in?
      @page_user = User.find_by_slug(params[:slug])
      @user = current_user
      erb :'users/show'
    else 
      redirect '/login'
    end
  end
end