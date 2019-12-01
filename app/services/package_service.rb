require "uri"
require "net/http"
require "dcf"
require "open-uri"
class PackageService

  def self.get_all_packages
    uri = URI("https://cran.r-project.org/src/contrib/PACKAGES")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(uri.path)
    response = http.request(request)
    packages = Dcf.parse(response.body)
    self.build_url_to_get_package_information(packages)
  end

  private

  def self.build_url_to_get_package_information(packages)
    packages.each do |package|
      open("#{Rails.root}/public/#{package["Package"]}_#{package["Version"]}.tar.gz", "wb", encoding: "ascii-8bit") do |file|
        file << open("http://cran.r-project.org/src/contrib/#{package["Package"]}_#{package["Version"]}.tar.gz").read
      end
      Dir.chdir("public/") do
        `tar xzf #{Rails.root}/public/#{package["Package"]}_#{package["Version"]}.tar.gz`
      end
      package_information = File.read("#{Rails.root}/public/#{package["Package"]}/DESCRIPTION")
      response_body = Dcf.parse(package_information).first
    end
  end

end