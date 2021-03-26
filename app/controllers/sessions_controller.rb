class SessionsController < ApplicationController 

  get '/login' do
    if logged_in?
      redirect '/animes/home'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/animes/home"
    else
      flash[:message] = 'Username and Password did not match!'
      erb :"users/login"
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect '/home'
    else
      redirect '/login'
    end
  end
end