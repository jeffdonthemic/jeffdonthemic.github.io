
require 'json'
require 'date'

def post_contents(post)
  d = DateTime.parse(post['published_at'])
  <<~EOF
  ---
  layout: post
  title:  #{post['title']}
  description: #{description(post)}
  date: #{d.strftime('%Y-%m-%d %H:%M:%S')} +0300
  image:  '#{image(post['feature_image'])}'
  tags:   #{tags(post)}
  ---
  #{html_content(post['html'])}
  EOF
end

def description(post)
  str = post['plaintext']
  #remove all fo the html
  str.gsub!(/<\/?[^>]*>/, "")
  # remove all of the markdown
  str = str.sub(/\[(.*?)\]/, '')
  "#{str[0,75].delete("\n")}..."
end

def tags(post)
  d = DateTime.parse(post['published_at'])
  leave_date = Date.new(2014,6,15)
  
  tags = ["#{d.strftime('%Y')}"]
  tags.push(post['visibility']) unless post['visibility'].empty?

  tags
end

def html_content(c)
  c.gsub!('<!--kg-card-begin: markdown-->', '')
  c.gsub!('<!--kg-card-end: markdown-->', '')
  c.gsub!('http://blog.jeffdouglas.com/2014/06/11/its-official-im-a-serial-adopter/', 'its-official-were-serial-adopter')
  c.gsub!('loading="lazy"', '')
  

  # fix all of the images
  [1,2,3,4,5,6,7,8,9,10,11,12,'Apr','Aug','Jul','Jun','May','Sept'].each do |i|
    c.gsub!("__GHOST_URL__/content/images/2014/#{i}/", 'images/')
    c.gsub!("__GHOST_URL__/content/images/2015/#{i}/", 'images/')
  end

  c.gsub!('href="__GHOST_URL__', 'href="')

  c
end

def image(i)
  return random_stock_image if i.nil?

  if i.start_with?('__GHOST_URL__')
    "/images/#{i.split('/').last}"
  else
    i
  end
end

def random_stock_image
  "/images/stock/#{rand(13)}.jpg"
end

def write_post(post)
  d = DateTime.parse(post['published_at'])
  File.write("./_posts/#{d.strftime('%Y-%m-%d')}-#{post['slug']}.markdown", post_contents(post))
end

file = File.open("./ghost-conent-export.json").read
contents = JSON.parse(file)
posts = contents['db'][0]['data']['posts']

puts posts.length

posts[90..100].each do |post|
  if post['type'].eql?('post')
    puts "--- processing #{post['slug']}"
    write_post(post) 
  end
end

# write_post(posts[0])