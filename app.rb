require 'sinatra'
require 'dotenv/load'
require 'json'
require_relative 'src/database/schema'
require_relative 'src/routes/contacts_route'
require_relative 'src/routes/reminders_route'

set :port, ENV.fetch('PORT').to_i

get '/' do
    content_type :json
    {
        mensage: "API is running"
    }.to_json

end
