class UsersController < ApplicationController 

  get '/sign-up' do
    if Helpers.logged_in?(session)
      session[:anime_found] = nil
      redirect '/animes'
    else 
      Helpers.set_webpage('sign-up')
      erb :'users/new'
    end
  end

  post '/sign-up' do
    if params[:name] = '' && params[:email] = '' && params[:password] = ''
      redirect '/sign-up'
    else
      user = User.save(params)
      if User.find_by(name: user.name, email: user.email)
        redirect '/login'
      else
        user = User.create(params)
        session['user_id'] = @user.id
        redirect "/animes"
      end
    end
  end

  get '/login' do
    if Helpers.logged_in?(session)
      session[:anime_found] = nil
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
      session[:anime_found] = nil
      redirect "/animes"
    else
      redirect "/login"
    end
  end

  get '/users/:slug' do
    if Helpers.logged_in?(session)
      Helpers.set_webpage('user')
      session[:anime_found] = nil
      @user = User.find_by_slug(params[:slug])
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