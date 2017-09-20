require 'capybara/rspec'
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('Librarian Portal', {:type => :feature}) do
  it 'allows admin to add new books' do
    visit('/admin')
    click_link('Books')
    click_link('Add a Book')
    fill_in('title', :with => "Harry Potter")
    fill_in('author-first', :with => "J. K.")
    fill_in('author-last', :with => "Rowling")
    click_button('Add Book')
    expect(page).to have_content("Harry Potter")
  end

  it "allows admin to add new patrons" do
    visit('/admin')
    click_link('Patrons')
    click_link('Add a Patron')
    fill_in('first-name', :with => "Bob")
    fill_in('last-name', :with => "Smith")
    click_button('Add Patron')
    expect(page).to have_content("Bob Smith")
  end
end
