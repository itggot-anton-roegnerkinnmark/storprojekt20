require 'slim'
require 'bcrypt'
require 'sinatra'
require 'sqlite3'
require_relative './model.rb'
require 'sinatra/reloader'



db = SQLite3::Database.new('db/database.db')
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

    matched_password = db.execute('SELECT password FROM Customer WHERE username = ?;', username)[0]['password']

    if BCrypt::Password.new(matched_password) == password
        session[:user_id] = db.execute('SELECT id from Customer WHERE username = ?;', username)[0]['id']
        p session[:user_id] # här syns det om användaren är inloggad... (exempelvis if session[:user_id].length < 1 då är han/hon inte inloggad!)
        redirect('/')
    end

end

get('/product/:product_id') do 
    product = db.execute('SELECT * FROM Product WHERE id = ?', params[:product_id].to_i)[0]
    p product
    slim(:product, locals:{product:product})
end 
    

get('/upload_product') do 
    slim(:product_upload)
end


post('/upload_product') do 
    cat_id = params["cat_id"]
    stock = params["stock"]
    price = params["decide_price"]
    product_name = params["product_name"]


    #insert_new_product(stock, price, reviews_star, reviews_text, product_name) 

    db.execute('INSERT INTO Product (stock, price, product_name) VALUES (?,?,?)', stock, price, product_name)
    db.execute('INSERT INTO relation_cat_product (cat_id, product_id) VALUES (?,?)', cat_id, product_id)
    redirect("/upload_product")
end

post('/update_product') do 
    stock = params["stock"]
    price = params["decide_price"]
    reviews_text = params["reviews_text"]
    product_name = params["product_name"]
    id = params["id"]

    update = db.execute('UPDATE Product SET stock=?, price=?, reviews_text=?, product_name=? WHERE id=?', stock, price, reviews_text, product_name, id)
    redirect("/")
end 

post('/delete_product') do 
    id = params["id"]

    db.execute('DELETE FROM Product WHERE id=?', id)
    p 'lmao'
    redirect("/")
end 


get('/all_products') do
    product = db.execute('SELECT * FROM Product')
    p product
    slim(:show_products, locals:{products:product})
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