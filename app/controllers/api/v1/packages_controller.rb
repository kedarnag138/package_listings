class Api::V1::PackagesController < ApplicationController

  def index
    @packages = Package.all
  end

end