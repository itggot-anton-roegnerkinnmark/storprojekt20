require 'slim'
require 'bcrypt'
require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new("db/database.db")
db.results_as_hash = true 

get('/') {
    slim(:index)
}

get('/login') {

}

get('/register') {
    
}