case @environment
when "development"
  every :day, at: '12:00pm' do
    puts "========START=============="
    runner "PackageService.get_all_packages", :output => "log/get_all_packages.log"
    puts "========FINISH=============="
  end
end