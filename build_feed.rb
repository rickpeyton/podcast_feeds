require 'yaml'
require 'date'
now = DateTime.now

base_url = 'http://audiocasts.rickpeyton.com/'
podcasts = YAML.load_file("podcasts.yml")
feed_filename = 'audiocasts.xml'
feed_email = 'rick@rickpeyton.com'
feed_title = 'Audiocasts by @rickpeyton'
feed_link = base_url
feed_description = 'A feed of audiobooks for @rickpeyton for use in Overcast.'
feed_language = 'en-us'
feed_image = 'coverart.png'
last_change_date = now.strftime("%a, %d %b %Y %T CST")

File.open(feed_filename, 'w') do |f|
  f.puts '<?xml version="1.0"?>'
  f.puts '<rss version="2.0">'
  f.puts '  <channel>'
  f.puts "    <title>#{feed_title}</title>"
  f.puts "    <link>#{feed_link}</link>"
  f.puts "    <description>#{feed_description}</description>"
  f.puts '    <image>'
  f.puts "      <url>#{base_url}img/#{feed_image}</url>"
  f.puts "      <title>#{feed_title}</title>"
  f.puts "      <link>#{base_url}</link>"
  f.puts "    </image>"
  f.puts "    <language>en-us</language>"
  f.puts "    <lastBuildDate>#{last_change_date}</lastBuildDate>"
  f.puts "    <managingEditor>#{feed_email}</managingEditor>"
  f.puts "    <webMaster>#{feed_email}</webMaster>"
  podcasts.each do |podcast|
    f.puts "    <item>"
    f.puts "      <title>#{podcast[:title]}</title>"
    file_size = File.size("./files/#{podcast[:filename]}")
    f.puts "      <enclosure url='#{base_url}files/#{podcast[:filename]}' length='#{file_size}' type='#{podcast[:type]}' />"
    f.puts "      <description>#{podcast[:title]} audiobook for Overcast</description>"
    f.puts "      <pubDate>#{podcast[:date]}</pubDate>"
    f.puts "      <guid>#{base_url}files/#{podcast[:filename]}</guid>"
    f.puts "    </item>"
  end
  f.puts "  </channel>"
  f.puts "</rss>"
end
puts "Syncing with server..."
exec "rsync -av --progress --delete . rickpeyton:~/public/audiocasts.rickpeyton.com/public" if fork.nil?
Process.wait
puts "Sync complete"
