class UsersController < ApplicationController 

  get '/sign-up' do
    if Helpers.logged_in?(session)
      redirect '/animes'
    else 
      Helpers.set_webpage('sign-up')
      erb :'users/new'
    end
  end

  post '/sign-up' do
    if params[:name] && params[:email] && params[:password] 
      if User.find_by(name: params[:name], email: params[:email])
        redirect '/sign-up'
      else
        user = User.create(params)
        session['user_id'] = user.id
        redirect "/animes"
      end
    else
      redirect '/sign-up'
    end
  end

  get '/login' do
    if Helpers.logged_in?(session)
      redirect '/animes'
    else
      Helpers.set_webpage('login')
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/animes"
    else
      redirect "/login"
    end
  end

  get '/users/:slug' do
    if Helpers.logged_in?(session)
      @page_user = User.find_by_slug(params[:slug])
      @user = Helpers.current_user(session)
      Helpers.set_webpage('user') if @page_user.id == @user.id
      erb :'users/show'
    else 
      redirect '/login'
    end
  end

  get '/logout' do
    if Helpers.logged_in?(session)
      session.clear
      redirect '/'
    else
      redirect '/login'
    end
  end
end