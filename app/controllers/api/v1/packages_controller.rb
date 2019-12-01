class Api::V1::PackagesController < ApplicationController

  def index
    @packages = PackageService.get_all_packages
  end

end