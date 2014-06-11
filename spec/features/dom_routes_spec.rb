require 'spec_helper'

feature 'invoke correct dom route' do
  scenario 'invoke basic methods and helpers' do
    visit "/users"
  end
end