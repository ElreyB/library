#!/usr/bin/env ruby

require 'spec_helper'

describe('Patron') do
  let (:patron) { Patron.new({:first_name => "Bob", :last_name => "Smith"}) }

  it "stores a patron's first & last name and id, initializing id to nil" do
    expect(patron.id).to eq(nil)
    expect(patron.first_name).to eq("Bob")
    expect(patron.last_name).to eq("Smith")
  end

  describe('#full_name') do
    it "returns a patron's first and last names together" do
      expect(patron.full_name).to eq("Bob Smith")
    end
  end

  describe('#==') do
    it "is equal when two patrons' first & last names and ids are the same" do
      patron2 = Patron.new({:first_name => "Bob", :last_name => "Smith"})
      expect(patron).to eq(patron2)
    end
  end

  describe('#save') do
    it "saves a patron to the database" do
      patron.save
      expect(Patron.all).to eq([patron])
    end

    it "updates a saved patron in the database" do
      patron.save
      patron.last_name = "Jones"
      patron.save
      expect(Patron.all).to eq [patron]
    end
  end

  describe('.all') do
    it "returns all patrons saved to the database" do
      expect(Patron.all).to eq([])
    end
  end

  describe '#get_checkouts' do
    it "returns all checkout associated" do
      patron.save
      book2 = Book.new({:title => "Sorcerers Stone", :author_first => "J. K.", :author_last => "Rowling"})
      book3 = Book.new({:title => "Harry Potter", :author_first => "J. K.", :author_last => "Rowling"})
      book2.save
      book3.save
      record2 = book2.checkout(patron.id)
      record3 = book3.checkout(patron.id)
      expect(patron.get_checkouts).to eq [record2, record3]
    end
  end

  describe('.find') do
    it "returns all patrons whose first or last name or id matches the search term" do
      patron.save
      patron2 = Patron.new({:first_name => "Bob", :last_name => "Smith"})
      patron2.save
      expect(Patron.find(patron.id)).to eq([patron])
    end
  end

  describe '#delete' do
    it 'will delete patron from database' do
      patron.save
      patron.delete
      expect(Patron.all).to eq []
    end
  end
end
