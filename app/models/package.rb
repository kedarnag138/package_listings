class Package < ApplicationRecord

  def self.get_information(packages)
    packages.each do |package|
      open("#{Rails.root}/public/#{package["Package"]}_#{package["Version"]}.tar.gz", "wb", encoding: "ascii-8bit") do |file|
        file << open("http://cran.r-project.org/src/contrib/#{package["Package"]}_#{package["Version"]}.tar.gz").read
      end
      Dir.chdir("public/") do
        `tar xzf #{Rails.root}/public/#{package["Package"]}_#{package["Version"]}.tar.gz`
      end
      package_information = File.read("#{Rails.root}/public/#{package["Package"]}/DESCRIPTION")
      response_body = Dcf.parse(package_information).first
      self.build_package(response_body)
    end
  end

  def self.build_package(package)
    PackageService.new({
      name: package["Name"],
      version: package["Version"],
      publication_date: package["Date/Publication"],
      title: package["Title"],
      description: package["Description"],
      authors: {
        name: package["Author"],
        email: package["Author"].scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
      },
      maintainers: {
        name: package["Maintainer"],
        email: package["Maintainer"].scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
      }
    }).create_package
  end

end