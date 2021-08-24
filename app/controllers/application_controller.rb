class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }


  #the act of logging in is the action of storing a users ID in the session hash

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    # render the app/views/home.erb
    erb :home
  end
  #1. User visits login page and fills in form with email and pass. Hit submit to POST data to controller route
  #Get new users name, email and password from params hash
  #Use info to create and save a new instance of User - User.create(name: params[:name], email: params[:email], password: params[:password])
  #Once the user signs up, they are logged in by setting the session - session[:user_id]
  #redirect to the hompage



  get '/registrations/signup' do
    # render the sign up form view
    #app/views/registrations/signup.erb
    erb :'/registrations/signup'
  end
 #2. Controller route accesses the user email and pass from params hash
 #info is used to find the user from the data base using User.find_by(emai: params[:email], password: params[:password])
 #This info is stored as the value of session[:user_id]


  post '/registrations' do
    # responsible for handing POST request sent when a user hits Submit on sign up form
    #contains code that gets the new user's info from the params hash - creates a new user, signs them in, redirects them
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save 
    #save the session
    session[:user_id] = @user.id
    redirect '/users/home'
  end


  #introspect on the session hash in any other controller route and grab the current user by matching a user ID
  #session[:user_id]
  get '/sessions/login' do
    # the line of code below render the view page in app/views/sessions/login.erb
    #Render the login form
    erb :'sessions/login'
  end


  post '/sessions' do
    # Receive the POST request that gets sent when a user hits "submit" on login form
    #route contains code that grabs the user's info from the params hash
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user 
      session[:user_id] = @user.id 
      redirect '/users/home'
    end 
    redirect '/sessions/login'
  end

  #logging out means terminating the session - clears all the data from the session hash - use Ruby method #clear
  get '/sessions/logout' do
    # responsible for logging the user out and clearning the hash
    session.clear
    redirect '/'
  end

  get '/users/home' do
    # renders the users homepage view 
    #in the view page use the <%= => tags to show the user and then do @user.name
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end

end

