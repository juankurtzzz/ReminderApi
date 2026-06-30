require 'sinatra'
require 'rufus-scheduler'
require 'dotenv/load'
require 'json'
require_relative 'src/database/schema'
require_relative 'src/routes/contacts_route'
require_relative 'src/routes/reminders_route'
require_relative 'src/services/evolution_go_service'
require_relative 'src/jobs/reminder_job.rb'

set :port, ENV.fetch('PORT').to_i

scheduler = Rufus::Scheduler.new
scheduler.every '30s' do
  begin
    dispatch_pending_reminders
  rescue StandardError => e
    warn "[scheduler] erro ao disparar lembretes: #{e.message}"
  end
end

get '/' do
    content_type :json
    {
        mensage: "API is running"
    }.to_json

end
