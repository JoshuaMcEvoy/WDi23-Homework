require "sinatra"
require "sinatra/reloader"
require "sqlite3"

get '/' do
  erb :home
end


#INDEX
get '/butterflies' do
  @butterflies = query_db "SELECT * FROM butterflies"
  erb :butterflies_index
end

#NEW
get '/butterflies/new' do

  erb :butterflies_new
end

#CREATE
post '/butterflies' do
  # insert data from new butterfly into the database
  query_db "INSERT INTO butterflies (name, family, image) VALUES ('#{params["name"]}', '#{params['family']}', '#{params['image']}')"
  redirect to('butterflies')
end

#SHOW
get '/butterflies/:id' do


  # pass that butterfly to the template
  @butterfly = query_db "SELECT * FROM butterflies WHERE id=#{ params[:id] }"
  @butterfly = @butterfly.first #strip off the container
  erb :butterflies_show
end

#EDIT
get '/butterflies/:id/edit' do
  @butterfly = query_db "SELECT * FROM butterflies WHERE id=#{ params[:id] }"
  @butterfly = @butterfly.first
  erb :butterflies_edit
end

#UPDATE
post '/butterflies/:id' do
  query_db "UPDATE butterflies SET name='#{ params['name']}', family='#{ params['family']}', image='#{ params['image']}' WHERE id=#{ params[:id]}"
  redirect to("/butterflies/#{ params[:id] }")
end

#DESTROY
get '/butterflies/:id/delete' do
  query_db "DELETE FROM butterflies WHERE id=#{ params[:id] }"
  redirect to('/butterflies')
end



def query_db(sql)
  db = SQLite3::Database.new 'database.sqlite3'
  db.results_as_hash = true

  puts sql #optional but nice for bedugging

  results = db.execute sql
  db.close
  results #Implicit return
end
