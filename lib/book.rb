#!/usr/bin/env ruby

class Book
  attr_reader :id, :title, :author_first, :author_last

  def initialize(args)
    @id = args[:id] || nil
    @title = args[:title]
    @author_first = args[:author_first]
    @author_last = args[:author_last]
  end

  def author_name
    "#{@author_first} #{@author_last}"
  end

  def save
    results = DB.exec("INSERT INTO books (title, author_first, author_last) VALUES ('#{@title}', '#{@author_first}', '#{@author_last}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM books;")
    results.map do |result|
      Book.new({
        title: result['title'],
        author_first: result['author_first'],
        author_last: result['author_last'],
        id: result['id'].to_i
        })
    end
  end

  def self.find(search_term)
    results = []
    if search_term.class == Integer
      results = DB.exec("SELECT * FROM books WHERE id = #{search_term};")
    else
      results = DB.exec("SELECT * FROM books WHERE title = '#{search_term}' OR author_first = '#{search_term}' OR author_last = '#{search_term}';")
    end
    results.map do |result|
      Book.new({
        title: result['title'],
        author_first: result['author_first'],
        author_last: result['author_last'],
        id: result['id'].to_i
        })
    end
  end

  def ==(other_book)
    (@id == other_book.id ) &
    (@title == other_book.title) &
    (author_name == other_book.author_name)
  end
end
