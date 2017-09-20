#!/usr/bin/env ruby

require 'spec_helper'

describe('Checkout') do
  let(:checkout) { Checkout.new({book_id: 1, patron_id: 2, checkout_date: "2017-09-20"}) }

  describe '.initialize' do
    it "stores book id and patron id, as well as checkout date, and initializes id, due date, and checked in state" do
      expect(checkout.id).to eq nil
      expect(checkout.book_id).to eq 1
      expect(checkout.patron_id).to eq 2
      expect(checkout.checkout_date).to eq "2017-09-20"
      expect(checkout.due_date).to eq "2017-10-11"
      expect(checkout.checked_in).to eq false
    end
  end

  describe "#==" do
    it "declares two checkouts are the same if all their attributes match" do
      checkout2 = Checkout.new({book_id: 1, patron_id: 2, checkout_date: "2017-09-20"})
      expect(checkout).to eq checkout2
    end
  end

  describe ".all" do
    it "returns a list of all checkouts" do
      expect(Checkout.all).to eq []
    end
  end

  describe "#save" do
    it "saves a checkout to the database" do
      checkout.save
      expect(Checkout.all).to eq [checkout]
    end

    it 'updates a saved checkout' do
      checkout.save
      checkout.checked_in = true
      checkout.save
      expect(Checkout.all).to eq [checkout]
    end
  end

  describe ".find" do
    it "finds a checkout by its id" do
      checkout.save
      checkout2 = Checkout.new({book_id: 1, patron_id: 2, checkout_date: "2017-09-20"})
      checkout2.save
      expect(Checkout.find(checkout.id)).to eq checkout
    end
  end

  describe ".overdue" do
    it "returns a list of all overdue checkouts" do
      checkout.save
      overdue_checkout = Checkout.new({book_id: 1, patron_id: 2, checkout_date: "2017-07-20"})
      overdue_checkout.save
      expect(Checkout.overdue).to eq [overdue_checkout]
    end
  end

  describe '#delete' do
    it 'will delete checkout from database' do
      checkout.save
      checkout.delete
      expect(Checkout.all).to eq []
    end
  end
end
