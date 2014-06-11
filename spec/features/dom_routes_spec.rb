require 'spec_helper'

def filters(controller_namespace)
  filters = %w[before index after].map do |filter|
    ["application.#{filter}", "#{controller_namespace}.#{filter}"]
  end.flatten
  filters[-1], filters[-2] = filters[-2], filters[-1]
end

def test_elements(filters)
  within '#test_append' do
    all('div').zip(filters).each do |div, filter|
      div[:class].should == filter
    end
  end
end

feature 'invoke correct dom route', :js => true do
  context 'without parameters' do
    scenario 'basic controller' do
      visit '/users'
      filters 'users'
    end

    scenario 'namespaced controller' do
      visit '/dashboard/users'
      filters 'dashboard.users'
    end
  end
end