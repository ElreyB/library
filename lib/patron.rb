#!/usr/bin/env ruby

class Patron
  attr_reader :id, :first_name, :last_name

  def initialize(attributes)
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
    @id = attributes[:id] || nil
  end

  def full_name
    @first_name + " " + @last_name
  end

  def save
    results = DB.exec("INSERT INTO patrons (first_name, last_name) VALUES ('#{@first_name}', '#{@last_name}') RETURNING id;")
    @id = results.first["id"].to_i
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

  def self.find(search_term)
    results = DB.exec("SELECT * FROM patrons WHERE first_name = '#{search_term}' OR last_name = '#{search_term}' OR id = #{search_term};")
    results.map do |result|
      Patron.new({
        :first_name => result["first_name"],
        :last_name => result["last_name"],
        :id => result["id"].to_i
      })
    end
  end
end
