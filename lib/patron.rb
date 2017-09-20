#!/usr/bin/env ruby

class Patron
  attr_reader :id
  attr_accessor :first_name, :last_name

  def initialize(attributes)
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
    @id = attributes[:id] || nil
  end

  def full_name
    @first_name + " " + @last_name
  end

  def save
    if @id
      DB.exec("UPDATE patrons SET first_name = '#{@first_name}', last_name = '#{@last_name}' WHERE id = #{@id};")
    else
      results = DB.exec("INSERT INTO patrons (first_name, last_name) VALUES ('#{@first_name}', '#{@last_name}') RETURNING id;")
      @id = results.first["id"].to_i
    end
  end

  def ==(other_patron)
    (full_name == other_patron.full_name) & (@id == other_patron.id)
  end

  def self.all
    results = DB.exec("SELECT * FROM patrons;")
    results.map do |result|
      Patron.new({
        :first_name => result["first_name"],
        :last_name => result["last_name"],
        :id => result["id"].to_i
      })
    end
  end

  def delete
    DB.exec("DELETE FROM patrons WHERE id = #{@id};")
    DB.exec("DELETE FROM checkouts WHERE patron_id = #{@id};")
  end

  def self.find(search_term)
    results = []
    if search_term.class == Integer
      results = DB.exec("SELECT * FROM patrons WHERE id = #{search_term};")
    else
      results = DB.exec("SELECT * FROM patrons WHERE first_name = '#{search_term}' OR last_name = '#{search_term}';")
    end
    results.map do |result|
      Patron.new({
        :first_name => result["first_name"],
        :last_name => result["last_name"],
        :id => result["id"].to_i
      })
    end
  end
end
