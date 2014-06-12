require 'spec_helper'

feature 'invoke correct dom route', :js => true do
  def filters(controller_namespace, js=false)
    action = @parameters ? "with_parameters" : "index"

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

  def generate_path(base)
    base + (@parameters ? "/with_parameters" : "")
  end

  shared_examples "dom route controllers" do
    scenario 'with basic controller' do
      visit generate_path('/users')
      test_elements filters('users')
    end

    scenario 'with namespaced controller' do
      visit generate_path('/dashboard/users')
      test_elements filters('dashboard.users')
    end
  end

  context 'without parameters' do
    before :all do
      @parameters = false
    end
    it_should_behave_like "dom route controllers"
  end

  context 'with parameters' do
    before :all do
      @parameters = true
    end
    it_should_behave_like "dom route controllers"

    scenario 'with ajax' do
      visit '/users/with_parameters'
      click_link "ajax_link"
      test_elements filters('users', true)
    end
  end
end