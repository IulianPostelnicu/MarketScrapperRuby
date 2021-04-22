require 'nokogiri' #parse web content
require 'httparty' #get http page
require 'byebug' #debug by adding buybug on any line

def scraper(base_url)
  # jobs_extracted = []

  index_page = 1
  number_of_pages = 0

  url = base_url + index_page.to_s
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page.body)
  job_listings = parsed_page.css('div.listing-data')
  jobs_per_page = job_listings.count

  # uncomment next line to take all the pages on the web pages
  # comment "   number_of_pages=3   "
  # number_of_pages = parsed_page.css('ul.pagination.radius a')[-2].text.to_i
  number_of_pages = 3

  File.open('jobs.txt', 'r+') do |file|
    int = 1
    while index_page <= number_of_pages
      url = base_url + index_page.to_s
      unparsed_page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(unparsed_page.body)
      job_listings = parsed_page.css('div.listing-data')

      job_listings.each do |job_listing|
        job = {
          title: job_listing.css('a.maincolor').text.strip,
          description: job_listing.css('p').text.strip,
          location: job_listing.css('span').text.strip,
          web: job_listing.css('a.maincolor')[0].attributes['href'].value
        }
        puts "\n Added Job: #{int}:#{job[:title]}"
        # jobs_extracted << job
        file.write("#{job[:title]}++#{job[:description]}++#{job[:location]}++#{job[:web]}")
        int += 1
      end
      index_page += 1
    end
  end

  # byebug
end

puts 'Hello there! insert URL here without an index!'
puts 'To exit type - crtl+c - else enter needed URL'
puts 'Here is an example: https://www.publi24.ro/anunturi/locuri-de-munca/?pag= !'
puts 'Insert command:'
url = ''
url = gets.chomp
scraper(url)
