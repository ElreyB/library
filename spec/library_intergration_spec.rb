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

  it 'allow admin to edit a patron' do
    visit('/admin')
    click_link('Patrons')
    click_link('Add a Patron')
    fill_in('first-name', :with => "James")
    fill_in('last-name', :with => "Jameson")
    click_button('Add Patron')
    click_link('James Jameson')
    click_link('Edit')
    fill_in('first-name', :with => "James")
    fill_in('last-name', :with => "Jenkins")
    click_button('Edit Patron')
    expect(page).to have_content("James Jenkins")
  end

  it 'allow admin to edit a patron' do
    visit('/admin')
    click_link('Patrons')
    click_link('Add a Patron')
    fill_in('first-name', :with => "James")
    fill_in('last-name', :with => "Jameson")
    click_button('Add Patron')
    click_link('James Jameson')
    click_button('Delete')
    expect(page).to have_no_content("James Jameson")
  end

  it 'allows admin to delete a book' do
    visit('/admin')
    click_link('Books')
    click_link('Add a Book')
    fill_in('title', :with => "Harry Potter")
    fill_in('author-first', :with => "J. K.")
    fill_in('author-last', :with => "Rowling")
    click_button('Add Book')
    click_link('Harry Potter')
    click_button('Delete')
    expect(page).to have_no_content("Harry Potter")
  end
end

describe('Patron Portal', {:type =>:feature}) do
  it 'allows patron to checkout a book and check a book in' do
    visit('/patron')
    click_button('Sign In')
    click_link('Catalog')
    click_link('Harry Potter')
    click_button('Check Out')
    expect(page).to have_content("Checked Out")
    click_button('Check In')
    expect(page).to have_content("Checked In")
  end
end
