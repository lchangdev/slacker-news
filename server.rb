require 'sinatra'
require 'shotgun'
require 'CSV'
require 'pry'

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
