
require 'json'
require 'date'
require "down"
require "fileutils"

def post_contents(post)
  d = DateTime.parse(post['published_at'])
  <<~EOF
  ---
  layout: post
  title:  #{title(post['title'])}
  description: #{description(post)}
  date: #{d.strftime('%Y-%m-%d %H:%M:%S')} +0300
  image:  '#{image(post)}'
  tags:   #{tags(post)}
  ---
  #{html_content(post)}
  EOF
end

def title(str)
  str.gsub!(':', '-')
  str.gsub!('"', '')
  str
end

def description(post)
  str = post['plaintext']
  str.gsub!("\n", ' ')
  #remove all fo the html
  str.gsub!(/<\/?[^>]*>/, "")
  # remove all of the markdown
  str.gsub!(/\[.+?\]/, '')
  str.gsub!('"', '')
  str.gsub!("'", '')
  str.gsub!(':', '-')
  str.gsub!('“', '')
  str.gsub!('”', '')
  str.gsub!('.  ', '. ')
  str.gsub!('   ', ' ')
  str.gsub!('    ', ' ')  
  str[0,500]
end

def tags(post)
  d = DateTime.parse(post['published_at'])
  leave_date = Date.new(2014,6,15)
  
  tags = ["#{d.strftime('%Y')}"]
  tags.push(post['visibility']) unless post['visibility'].empty?

  tags
end

def html_content(post)
  if post['slug'].eql?('tutorial-build-your-first-lightning-component')
    return file = File.open("./html_snippets/#{post['slug']}.md").read
  end
  
  c = post['html']

  c.gsub!('<!--kg-card-begin: markdown-->', '')
  c.gsub!('<!--kg-card-end: markdown-->', '')
  c.gsub!('loading="lazy"', '')
  c.gsub!('&quot;', '"')
  c.gsub!('<pre><code>', '{% highlight js %}')
  c.gsub!('</code></pre>', '{% endhighlight %}')
  # fix tag brackets
  c.gsub!('&lt;', '<')
  c.gsub!('&gt;', '>')
  # double space to single space
  c.gsub!('  ', ' ')
  c.gsub!('   ', ' ')
  c.gsub!('&amp;', '&')
  c.gsub!('‘', "'")
  
  # fix all of the images
  [1,2,3,4,5,6,7,8,9,10,11,12,'Apr','Aug','Jul','Jun','May','Sept','02','03','04','05','06','07','08','09'].each do |i|
    c.gsub!("__GHOST_URL__/content/images/2014/#{i}/", 'images/')
    c.gsub!("__GHOST_URL__/content/images/2015/#{i}/", 'images/')
  end
  c.gsub!('href="__GHOST_URL__', 'href="')

  c
end

def image(post)
  i = post['feature_image']

  return random_stock_image(post['slug']) if i.nil?

  if i.start_with?('__GHOST_URL__')
    "/images/#{i.split('/').last}"
  else
    i
  end
end

def random_stock_image(slug)
  # tempfile = Down.download("https://picsum.photos/1024/683")
  # FileUtils.mv(tempfile.path, "./images/slugs/#{slug}.jpg")

  "/images/slugs/#{slug}.jpg"
end

def write_post(post)
  d = DateTime.parse(post['published_at'])
  File.write("./_posts/#{d.strftime('%Y-%m-%d')}-#{post['slug']}.markdown", post_contents(post))
end

file = File.open("./ghost-conent-export.json").read
contents = JSON.parse(file)
posts = contents['db'][0]['data']['posts']

posts.each do |post|
  if post['type'].eql?('post')# && post['slug'].eql?('tutorial-build-your-first-lightning-component')
    puts "--- processing #{post['slug']}"
    write_post(post) 
  end
end