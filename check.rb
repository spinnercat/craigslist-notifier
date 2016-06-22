require "set"

# Log stores a record of which urls we've already notified the user about. These will be skipped.
log_file_name = "/Users/MSchorow/Projects/craigslist-notifier/log.txt"

# Make a query on craiglist and insert format=rss as part of the query.
# I'm looking for a digital piano! Anyone know somebody in the LA area selling? :D
query_url = "http://losangeles.craigslist.org/search/sss?format=rss&max_price=1250&min_price=200&postal=90046&query=digital%20piano&search_distance=12&sort=rel"

# Set your phone number here
phone_to_notify = ENV["PHONE"]

puts "*** Starting check at #{Time.now.to_s} ***"
saved_urls = File.readlines(log_file_name).map {|l| l.chomp}.to_set


page = `curl "#{query_url}"`
page = page.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
items = page.scan(/<items>(.*)<\/items>/m).first.first
urls = items.scan(/<rdf:li rdf:resource="(.*)" \/>/)
# urls is in format [["url1"], ["url2"], ...]

urls_to_save = []
urls.each do |query_url|
    # query_url will be an array with one element
    query_url = query_url.first
    unless saved_urls.include?(query_url)
        urls_to_save << query_url
        message = "message=New Posting! View it at #{query_url}."
        # Use textbelt for free texting.
        `curl -X POST http://textbelt.com/text -d number=#{phone_to_notify} -d "message=#{message}"`
        puts message
    else
        puts "skipped #{query_url}"
    end
end

# Append notified urls to the end of the log.
open(log_file_name, "a") do |f|
    urls_to_save.each {|url| f.puts url }
end
