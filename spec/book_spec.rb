#!/usr/bin/env ruby

require 'spec_helper'

describe('Book') do
  let(:book) { Book.new({:title => "Harry Potter", :author_first => "J. K.", :author_last => "Rowling"})}

  describe '#initialize' do
    it 'has a readable title, first name and last name' do
      expect(book.title).to eq "Harry Potter"
      expect(book.author_last).to eq "Rowling"
      expect(book.author_first).to eq "J. K."
      expect(book.id).to eq nil
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
  end

  describe '.find' do
    it 'will find all books where attributes matches search term' do
      book2 = Book.new({:title => "Sorcerers Stone", :author_first => "J. K.", :author_last => "Rowling"})
      book.save
      book2.save
      expect(Book.find("Sorcerers Stone"))
    end
  end
end
