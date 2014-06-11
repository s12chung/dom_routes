class ApplicationController < ActionController::Base
  self.append_view_path File.join(File.dirname(__FILE__), "views")
end

module BaseController
  extend ActiveSupport::Concern

  def index
    render_users
  end
  def with_parameters
    render_users
  end

  protected
  def render_users
    render "users/#{action_name}"
  end
end

class UsersController < ApplicationController
  include BaseController
end
module Dashboard
  class UsersController < ApplicationController
    include BaseController
  end
end
class AdminsController < UsersController
  include BaseController
end
class ArtistsController < UsersController
  include BaseController
end