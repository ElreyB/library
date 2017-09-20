#!/usr/bin/env ruby

require "rspec"
require "pg"
require "book"
require "checkout"
require "patron"

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM patrons *;")
  end
end
