require "sinatra"
require "sinatra/reloader"
also_reload "lib/**/*.rb"
require "pg"
require "./lib/book"
require "./lib/patron"
require "./lib/checkout"
require "pry"

DB = PG.connect({:dbname => 'library_test'})

get('/') do
  erb(:index)
end

get('/admin') do
  erb(:admin)
end

get('/admin/books') do
  @books = Book.all
  erb(:admin_books)
end

get('/admin/patrons') do
  @patrons = Patron.all
  erb(:admin_patrons)
end

get('/patron/add') do
  erb(:add_patron)
end

get('/book/add') do
  erb(:add_book)
end

post('/patron/add') do
  patron = Patron.new({
    first_name: params["first-name"],
    last_name: params["last-name"]
  })
  patron.save
  redirect "/admin/patrons"
end

post('/book/add') do
  book = Book.new({
    title: params["title"],
    author_first: params["author-first"],
    author_last: params["author-last"]
  })
  book.save
  redirect "/admin/books"
end

get('/admin/patrons/:id') do
  id = params[:id].to_i
  @patron = Patron.find(id).first
  erb(:patron)
end

get('/admin/books/:id') do
  id = params[:id].to_i
  @book = Book.find(id).first
  erb(:book)
end
