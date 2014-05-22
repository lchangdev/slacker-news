require 'sinatra'
require 'shotgun'
require 'CSV'

get '/' do
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

# post '/tasks' do
#   # Read the input from the form the user filled out
#   task = params['task_name']

#   # Open the "tasks" file and append the task
#   File.open('tasks', 'a') do |file|
#     file.puts(task)
#   end

#   # Send the user back to the home page which shows
#   # the list of tasks
#   redirect '/'
# end
# post '/articles' do
#   title = params["title"]
#   url = params["url"]
#   description = params["description"]

#   CSV.open [“articles_data.csv”, “a”) do |csv|
#     csv << [title, url, description]
#   end

#   redirect “/"

# end
