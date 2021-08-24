class User < ActiveRecord::Base
  validates_presence_of :name, :email, :password
end

#user model has a few attributes - name, email, password
#this validates if a name is invalid or an email or password
#THIS IS THE FIRST STEP 
#run rake db:create_migration to write a migration that creates a Users table with columns for name, email, pass
#run rake db:migrate SINATRA_ENV=test