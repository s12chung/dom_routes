class ApplicationController < ActionController::Base
  self.append_view_path File.join(File.dirname(__FILE__), "views")
end

module BaseController
  extend ActiveSupport::Concern

  def index
    render_users
  end
  def with_parameters
  end

  protected
  def render_users
    render "users/#{action_name}"
  end
end

class UsersController < ApplicationController
  include BaseController

  def manually_execute
  end
end
module Dashboard
  class UsersController < ApplicationController
    include BaseController
  end
end