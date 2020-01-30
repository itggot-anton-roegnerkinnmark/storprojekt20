require 'slim'
require 'bcrypt'
require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new("db/database.db")
db.results_as_hash = true 
enable :session

get('/') do
    slim(:index)
end

get('/register') do
    slim(:register)
end

post('/register') do
    username = params[:username]
    password = params[:password]
    
    password_digest = BCrypt::Password.create(password)

    db.execute('INSERT INTO Customer (username, password) VALUES (?,?)', username, password_digest)
    redirect('/')
end 

get('/login') do 
    slim(:login)
end 

post('/login') do 
    username = params[:username]
    password = params[:password]

    matched_password = db.execute("SELECT password FROM Customer WHERE username = ?;", username)[0]["password"]

    if BCrypt::Password.new(matched_password) == password
        session[:user_id] = db.execute("SELECT id from Customer WHERE username = ?;", username)[0]["id"]
        p session[:user_id] # här har ser du om användaren är inloggad... (exempelvis if session[:user_id].length < 1 då inte inloggad!)
        redirect("/")
    end
end

get('/error') do 
    if session[:error_message] != nil
        error_message = session[:error_message]
        session[:error_message] = nil
        return error_message
    else 
        return 'Undefined Error'
    end 
end 