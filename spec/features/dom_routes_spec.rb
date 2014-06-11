require 'spec_helper'

feature 'invoke correct dom route', :js => true do
  def filters(controller_namespace)
    action = @parameters ? "with_parameters" : "index"

    filters = %W[before #{action} after].map do |filter|
      ["application.#{filter}", "#{controller_namespace}.#{filter}"]
    end.flatten
    filters[-1], filters[-2] = filters[-2], filters[-1]
    filters
  end

  def test_elements(filters)
    within '#test_append' do
      all('div').zip(filters).each do |div, filter|
        div[:class].should == filter

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
    scenario 'basic controller' do
      visit generate_path('/users')
      test_elements filters('users')
    end

    scenario 'namespaced controller' do
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
  end
end