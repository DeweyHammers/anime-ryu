require './config/environment'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']) if ENV['DATABASE_URL']

use UsersController
use AnimesController
run ApplicationController