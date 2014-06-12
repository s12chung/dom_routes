require 'spec_helper'

feature 'invoke correct dom route', :js => true do
  def filters(controller_namespace, action, js=false)
    formats = %w[html]
    if js; formats += %w[js] end

    formats.map do |format|
      format_filters = %W[before #{action} after].map do |filter|
        ["application.#{format}.#{filter}", "#{controller_namespace}.#{format}.#{filter}"]
      end.flatten
      format_filters[-1], format_filters[-2] = format_filters[-2], format_filters[-1]
      format_filters
    end.flatten
  end

  def test_elements(filters)
    within '#test_append' do
      all('div').zip(filters).each do |div, filter|
        div[:filter].should == filter

        if @parameters
          div.text.should == "params_test"
        end
      end
    end
  end

  context 'without parameters' do
    before :all do
      @parameters = false
    end

    scenario 'with basic controller' do
      visit '/users'
      test_elements filters('users', "index")
    end

    scenario 'with namespaced controller' do
      visit '/dashboard/users'
      test_elements filters('dashboard.users', "index")
    end


    scenario "with manual execution" do
      visit '/users/manually_execute'
      test_elements (filters('users', "index") + filters('users', 'manually_execute'))
    end

    scenario "with different route" do
      visit '/users/different_route'
      test_elements filters('users', "index")
    end

    scenario "with redirect" do
      visit '/users/redirect'
      test_elements (filters('users', 'redirect') + filters('users', "index"))
    end
  end

  context 'with parameters' do
    before :all do
      @parameters = true
    end

    scenario 'with basic controller' do
      visit '/users/with_parameters'
      test_elements filters('users', "with_parameters")
    end

    scenario 'with namespaced controller' do
      visit '/dashboard/users/with_parameters'
      test_elements filters('dashboard.users', "with_parameters")
    end

    scenario 'with ajax' do
      visit '/users/with_parameters'
      click_link "ajax_link"
      test_elements filters('users', "with_parameters", true)
    end
  end
end