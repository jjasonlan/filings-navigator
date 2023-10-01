require 'httparty'

filings = [
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201612429349300846_public.xml",
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201831309349303578_public.xml",
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201641949349301259_public.xml",
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201921719349301032_public.xml",
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/202141799349300234_public.xml",
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201823309349300127_public.xml",
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/202122439349100302_public.xml",
  "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201831359349101003_public.xml",
]

task :seed => :environment do
  filings.each do |filing|
    response = HTTParty.post("http://localhost:3000/filings?url=#{filing}")
    puts response.message unless response.code == 200
  end
end
