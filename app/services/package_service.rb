require "uri"
require "net/http"
require "dcf"
require "open-uri"
class PackageService

  def initialize(params)
    @name = params[:name]
    @version = params[:version]
    @publication_date = params[:publication_date]
    @title = params[:title]
    @description = params[:description]
    @authors = params[:authors]
    @maintainers = params[:maintainers]
  end

  def self.get_all_packages
    uri = URI("https://cran.r-project.org/src/contrib/PACKAGES")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(uri.path)
    response = http.request(request)
    packages = Dcf.parse(response.body)
    Package.get_information(packages)
  end

  def create_package
    begin
      external_package_service.create(package_attributes)
      FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/#{@name}/*"))
      File.delete("#{Rails.root}/public/#{@name}_#{version}.tar.gz") if File.exist?("#{Rails.root}/public/#{@name}_#{version}.tar.gz")
    rescue
      false
    end
  end

  private

  def external_package_service
    Package
  end

  def package_attributes
    {
      name: @name,
      version: @version,
      publication_date: @publication_date,
      title: @title,
      description: @description,
      authors: @authors,
      maintainers: @maintainers
    }
  end

end