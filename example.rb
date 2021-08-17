require 'sinatra'

get '/hello' do
  "Our params: #{params}"
end