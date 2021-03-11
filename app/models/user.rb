class User < ActiveRecord::Base
  include Slugs::InstanceMethods
  extend Slugs::ClassMethods

  has_secure_password
  has_many :animes  
end