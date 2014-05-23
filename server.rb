require 'sinatra'
require 'shotgun'
require 'CSV'
require 'pry'
require 'redis'
require 'json'


def get_connection
  if ENV.has_key?("REDISCLOUD_URL")
    Redis.new(url: ENV["REDISCLOUD_URL"])
  else
    Redis.new
  end
end

def find_articles
  redis = get_connection
  serialized_articles = redis.lrange("slacker:articles", 0, -1)

  articles = []

  serialized_articles.each do |article|
    articles << JSON.parse(article, symbolize_names: true)
  end

  articles
end

def save_article(url, title, description)
  article = { url: url, title: title, description: description }

  redis = get_connection
  redis.rpush("slacker:articles", article.to_json)
end

def load_data(csv)
  master_data = []
  CSV.foreach(csv, headers: true, header_converters: :symbol) do |row|
    master_data << row
  end
  master_data
end

get '/' do
  @articles = load_data('articles_data.csv')
  erb :index
end

get '/articles' do
  erb :articles
end

post '/articles' do
  title = params["title"]
  url = params["url"]
  description = params["description"]

  CSV.open('articles_data.csv', 'a') do |csv|
    csv << [title, url, description]
  end

  redirect '/'

end
