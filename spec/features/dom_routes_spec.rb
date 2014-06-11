require 'spec_helper'

feature 'invoke correct dom route', :js => true do
  context 'without parameters' do
    scenario 'invoke basic methods and helpers' do
      visit "/users"
      within '#test_append' do
        namespaces = %w[before index after].map do |filter|
          "application.#{filter}"
        end

        all('div').zip(namespaces).each do |div, namespace|
          div[:class].should == namespace
        end
      end
    end
  end
end