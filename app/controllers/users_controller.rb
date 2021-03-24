class UsersController < ApplicationController 
  
  get '/sign-up' do
    if logged_in?
      redirect '/animes/home'
    else 
      erb :'users/new'
    end
  end

  post '/sign-up' do
    if params[:name] != '' && params[:email] != '' && params[:password] != '' && params[:password_confirmation]  != '' 
      if !User.find_by(name: params[:name], email: params[:email])
        if params[:password] == params[:password_confirmation]
          if params[:password].length >= 8
            user = User.create(params)
            session['user_id'] = user.id
            redirect "/animes/home"
          else
            flash[:message] = 'Password must be 8 characters or longer!'
            erb :'users/sign-up'
          end
        else
          flash[:message] = 'Password does not match!'
          erb :'users/sign-up'
        end
      else
        flash[:message] = 'User with that account has been already made!'
        erb :'users/sign-up'
      end
    else
      flash[:message] = 'Nothing was passed in!'
      erb :'users/sign-up'
    end 
  end

  
  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :'users/show'
    else 
      redirect '/login'
    end
  end
end