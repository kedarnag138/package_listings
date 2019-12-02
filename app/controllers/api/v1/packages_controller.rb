class Api::V1::PackagesController < ApplicationController

  def index
    @packages = Package.limit(50).all
    if @packages.present?
      render json: { packages: @packages, status: { code: 200, errorDetail: "", message: "OK" } }
    else
      render json: { status: { code: 204, errorDetail: "NO CONTENT", message: "Nothing to display" } }
    end
  end

end