require 'sinatra'

get '/hello' do
  "Our params: #{params}"
end

post '/' do
  request.body
end
