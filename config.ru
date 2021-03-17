require './config/environment'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']) if ENV['DATABASE_URL']

use Rack::MethodOverride
use UsersController
use SessionsController
use AnimesController
run ApplicationController