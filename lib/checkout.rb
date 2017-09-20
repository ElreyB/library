#!/usr/bin/env ruby

class Checkout
  attr_reader :id, :book_id, :patron_id, :checkout_date, :due_date
  attr_accessor :checked_in

  def initialize(attributes)
    @id = attributes[:id] || nil
    @book_id = attributes[:book_id]
    @patron_id = attributes[:patron_id]
    @checkout_date = attributes[:checkout_date]
    @due_date = attributes[:due_date] || (Date.parse(@checkout_date) + 21).to_s
    @checked_in = attributes[:checked_in] || false
  end

  def save
    if @id
      DB.exec("UPDATE checkouts SET due_date = '#{@due_date}', checked_in = #{@checked_in} WHERE id = #{@id};")
    else
      results = DB.exec("INSERT INTO checkouts (book_id, patron_id, checkout_date, due_date, checked_in) VALUES (#{@book_id}, #{@patron_id}, '#{@checkout_date}', '#{@due_date}', #{@checked_in}) RETURNING id;")
      @id = results.first['id'].to_i
    end
  end

  def self.all
    results = DB.exec("SELECT * FROM checkouts;")
    results.map do |result|
      Checkout.new({
        id: result["id"].to_i,
        book_id: result["book_id"].to_i,
        patron_id: result["patron_id"].to_i,
        checkout_date: result["checkout_date"],
        due_date: result["due_date"],
        checked_in: ((result["checked_in"] == "t") ? true : false)
      })
    end
  end

  def self.find(id)
    results = DB.exec("SELECT * FROM checkouts WHERE id = #{id};")
    Checkout.new({
      id: results.first["id"].to_i,
      book_id: results.first["book_id"].to_i,
      patron_id: results.first["patron_id"].to_i,
      checkout_date: results.first["checkout_date"],
      due_date: results.first["due_date"],
      checked_in: ((results.first["checked_in"] == "t") ? true : false)
    })
  end

  def self.overdue
    today = Date.today.to_s
    results = DB.exec("SELECT * FROM checkouts WHERE due_date <= '#{today}';")
    results.map do |result|
      Checkout.new({
        id: result["id"].to_i,
        book_id: result["book_id"].to_i,
        patron_id: result["patron_id"].to_i,
        checkout_date: result["checkout_date"],
        due_date: result["due_date"],
        checked_in: ((result["checked_in"] == "true") ? true : false)
      })
    end
  end

  def delete
    DB.exec("DELETE FROM checkouts WHERE id = #{@id};")
  end

  def ==(other_checkout)
    (@id == other_checkout.id) &
    (@book_id == other_checkout.book_id) &
    (@patron_id == other_checkout.patron_id) &
    (@checkout_date == other_checkout.checkout_date) &
    (@due_date == other_checkout.due_date) &
    (@checked_in == other_checkout.checked_in)
  end
end
