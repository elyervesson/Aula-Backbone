require 'sinatra'
require 'json'
require 'active_record'

ActiveRecord::Base.include_root_in_json = false

class Post < ActiveRecord::Base
end

Post.establish_connection(
    :adapter => "sqlite3",
    :database => "data.db"
)

# Shows the index.html page, which contains the Backbone.js code
get '/' do
  File.read(File.join('public', 'index.html'))
end

# Get all the posts from the database
get '/posts' do
    content_type :json
    Post.all.to_json
end

# Get a post by id, from the database
get '/posts/:id' do
    content_type :json
    post = Post.find params[:id]
    post.to_json
end

# Create a new post
post '/posts' do
    content_type :json
    data = JSON.parse request.body.read

    post = Post.new
    post.title = data['title']
    post.text = data['text']

    post.save
    post.to_json
end

# Update an existing post
put '/posts/:id' do
    data = JSON.parse request.body.read

    post = Post.find params[:id]
    post.title = data['title']
    post.text = data['text']

    post.save
    post.to_json
end

# Remove an existing post
delete '/posts/:id' do
    post = Post.find params[:id]
    Post.destroy params[:id]
    post.to_json
end

Post.connection.close
