class ApplicationController < ActionController::Base
  self.append_view_path File.join(File.dirname(__FILE__), "views")
end

class UsersController < ApplicationController
  def index
  end
end
class AdminsController < UsersController
  def index
  end
end
class ArtistsController < UsersController
  def index
  end
end