#!/usr/bin/env ruby

class Book
  attr_reader :id, :title, :author_first, :author_last
  attr_accessor :checked_in

  def initialize(args)
    @id = args[:id] || nil
    @title = args[:title]
    @author_first = args[:author_first]
    @author_last = args[:author_last]
    @checked_in = (args.has_key?(:checked_in) ? args[:checked_in] : true)
  end

  def author_name
    "#{@author_first} #{@author_last}"
  end

  def save
    if @id
      DB.exec("UPDATE books SET checked_in = #{@checked_in} WHERE id = #{@id};")
    else
      results = DB.exec("INSERT INTO books (title, author_first, author_last, checked_in) VALUES ('#{@title}', '#{@author_first}', '#{@author_last}', #{@checked_in}) RETURNING id;")
      @id = results.first['id'].to_i
    end
  end

  def checkout(patron_id)
    checkout_record = Checkout.new({
      book_id: @id,
      patron_id: patron_id,
      checkout_date: Date.today.to_s
    })
    checkout_record.save
    @checked_in = false
    save
    checkout_record
  end

  def checkin
    checkout_records = Checkout.find_by_book(@id)
    checkout_records.each do |record|
      record.checked_in = true
      record.save
    end
    @checked_in = true
    save
  end

  def get_checkouts
    Checkout.find_by_book(@id)
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{@id};")
    DB.exec("DELETE FROM checkouts WHERE book_id = #{@id};")
  end

  def self.all
    results = DB.exec("SELECT * FROM books;")
    results.map do |result|
      Book.new({
        title: result['title'],
        author_first: result['author_first'],
        author_last: result['author_last'],
        id: result['id'].to_i,
        checked_in: ((result["checked_in"] == "t") ? true : false)
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
        id: result['id'].to_i,
        checked_in: ((result["checked_in"] == "t") ? true : false)
        })
    end
  end

  def ==(other_book)
    (@id == other_book.id ) &
    (@title == other_book.title) &
    (author_name == other_book.author_name)
    (@checked_in == other_book.checked_in)
  end
end
