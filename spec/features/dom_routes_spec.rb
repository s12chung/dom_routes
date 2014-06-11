require 'spec_helper'

feature 'invoke correct dom route', :js => true do
  scenario 'invoke basic methods and helpers' do
    visit "/users"
    page.should have_content 'test'
  end
end