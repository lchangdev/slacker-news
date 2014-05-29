require 'sinatra'
require 'pg'
require 'shotgun'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'articles')

    yield(connection)

  ensure
    connection.close
  end
end

def find_articles
  query = 'SELECT * FROM articles'

  db_connection do |conn|
    articles = conn.exec(query)
  end
end

def save_articles(title, url, description)
  query = "INSERT INTO articles (title, url, description, created_at)
          VALUES ($1, $2, $3, NOW())"
  db_connection do |conn|
    new_article = conn.exec_params(query, [title, url, description])
  end
end

def find_comments(article_id)

  id = params[:article_id]
  query = "SELECT comments.comment, comments.created_at AS time, articles.title
        FROM comments
          JOIN articles ON articles.id = comments.article_id
        WHERE articles.id = #{id}"
  db_connection do |conn|
    comments = conn.exec(query).to_a
  end

end

def save_comments(comment)
  #join articles and comments @ both ids
  id = params[:article_id]
  query = "INSERT INTO comments (article_id, comment, created_at)
          VALUES (#{id}, $1, NOW())"
  db_connection do |conn|
    new_comment = conn.exec_params(query, [comment])
  end
end

# GET REQUESTS

get '/articles' do
  @articles = find_articles

  erb :articles
end

get '/articles/:article_id/comments' do
  @comments = find_comments(params[:article_id])

  erb :comments
end

get '/new' do

  erb :new
end

post '/new' do
  save_articles(params["title"], params["url"], params["description"])


  redirect '/articles'
end

post '/articles/:article_id/comments' do
  save_comments(params[:article_id], params["comments"])

end
