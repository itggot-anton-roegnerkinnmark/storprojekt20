require 'slim'
require 'bcrypt'
require 'sinatra'
require 'sqlite3'

$db = SQLite3::Database.new('db/database.db')
$db.results_as_hash = true

def insert_new_product(stock, price, reviews_star, reviews_text, product_name)

    $db.execute('INSERT INTO Product (stock, price, product_name) VALUES (?,?,?,?)', stock, price, product_name)
end

