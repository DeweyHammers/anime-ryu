class SessionsController < ApplicationController 

  get '/login' do
    if logged_in?
      redirect '/animes'
    else
      set_webpage
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

  get '/logout' do
    if logged_in?
      session.destroy
      redirect '/'
    else
      redirect '/login'
    end
  end
end