require "uri"
require "net/http"
class PackageService

  def self.get_all_packages
    uri = URI("https://cran.r-project.org/src/contrib/PACKAGES")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(uri.path)
    response = http.request(request)
    response_body = JSON.parse(response.body)
    
    binding.pry
    
  end

end