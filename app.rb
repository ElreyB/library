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

get('/:user/books') do
  @user = params[:user]
  @books = Book.all
  erb(:books_list)
end

get('/admin/patrons') do
  @patrons = Patron.all
  erb(:admin_patrons)
end

get('/patron') do
  patron2 = Patron.new({:first_name => "Bob", :last_name => "Smith"})
  patron2.save
  book2 = Book.new({:title => "Harry Potter", :author_first => "J. K.", :author_last => "Rowling"})
  book2.save
  @id = patron2.id
  erb(:patron_portal)
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

post('/patron') do
  @patron = Patron.find(params['patron-id'].to_i).first
  redirect "/patron/patrons/#{@patron.id}"
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

get('/:user/patrons/:id') do
  id = params[:id].to_i
  @user = params[:user]
  @patron = Patron.find(id).first
  erb(:patron)
end

get('/:user/books/:id') do
  id = params[:id].to_i
  @user = params[:user]
  @book = Book.find(id).first
  erb(:book)
end

patch('/:patron_id/:book_id/checkout') do
  patron_id = params[:patron_id].to_i
  book_id = params[:book_id].to_i
  book = Book.find(book_id).first
  book.checkout(patron_id)
  redirect "#{patron_id}/books/#{book_id}"
end

patch('/:patron_id/:book_id/checkin') do
  patron_id = params[:patron_id].to_i
  book_id = params[:book_id].to_i
  book = Book.find(book_id).first
  book.checkin
  redirect "#{patron_id}/books/#{book_id}"
end

get('/admin/patrons/:id/edit') do
  id = params[:id].to_i
  @patron = Patron.find(id).first
  erb(:edit_patron)
end

patch('/patrons/:id') do
  id = params[:id].to_i
  patron = Patron.find(id).first
  patron.first_name = params['first-name']
  patron.last_name = params['last-name']
  patron.save
  redirect "/admin/patrons/#{patron.id}"
end

delete('/admin/patrons/:id') do
  id = params[:id].to_i
  patron = Patron.find(id).first
  patron.delete
  redirect "/admin/patrons"
end

delete('/admin/books/:id') do
  id = params[:id].to_i
  book = Book.find(id).first
  book.delete
  redirect "/admin/books"
end
