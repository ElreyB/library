#!/usr/bin/env ruby

require 'spec_helper'

describe('Book') do
  let(:book) { Book.new({:title => "Harry Potter", :author_first => "J. K.", :author_last => "Rowling"})}

  describe '#initialize' do
    it 'has a readable title, first name and last name, and is created checked in' do
      expect(book.title).to eq "Harry Potter"
      expect(book.author_last).to eq "Rowling"
      expect(book.author_first).to eq "J. K."
      expect(book.id).to eq nil
      expect(book.checked_in).to eq true
    end
  end

  describe '#author_name' do
    it "returns author's full name" do
      expect(book.author_name).to eq "J. K. Rowling"
    end
  end

  describe '#==' do
    it "declares two books are the same if they have the same id, title and author_name" do
      book2 = Book.new({:title => "Harry Potter", :author_first => "J. K.", :author_last => "Rowling"})
      expect(book).to eq book2
    end
  end

  describe '.all' do
    it 'will return all books that have been saved' do
      expect(Book.all).to eq []
    end
  end

  describe '#save' do
    it 'will save book to database' do
      book.save
      expect(Book.all).to eq [book]
    end

    it "updates a saved book's information in the database" do
      book.save
      book.checked_in = false
      book.save
      expect(Book.all).to eq [book]
    end
  end

  describe '.find' do
    it 'will find all books where attributes matches search term' do
      book2 = Book.new({:title => "Sorcerers Stone", :author_first => "J. K.", :author_last => "Rowling"})
      book.save
      book2.save
      expect(Book.find("Sorcerers Stone")).to eq [book2]
    end
  end

  describe '#delete' do
    it 'will delete book from database' do
      book.save
      book.delete
      expect(Book.all).to eq []
    end
  end

  describe '#checkout' do
    it "creates a checkout record for a book and patron, and marks it as checked out" do
      book.save
      checkout_record = book.checkout(1)
      expect(Checkout.all).to eq [checkout_record]
      expect(book.checked_in).to eq false
    end
  end

  describe '#checkin' do
    # it "sets a book to checked in, and updates checkout record" do
    #   book.save
    #   checkout_record = book.checkout(1)
    #   book.checkin
    #   expect(checkout_record.checked_in).to eq true
    #   expect(book.checked_in).to eq true
    # end
  end
end
