require 'rest-client'
require 'json'

class EvolutionGoApi
  BASE_URL = ENV['EVOLUTION_API_URL'].to_s.chomp('/')

  def initialize
    @instance_token = ENV['EVOLUTION_INSTANCE_TOKEN']

    @headers = {
      accept: :json,
      content_type: :json,
      'apikey' => @instance_token
    }
  end

  def send_text(number, message)
    payload = {
      number: number,
      text: message
    }

    response = RestClient.post(
      "#{BASE_URL}/send/text",
      payload.to_json,
      @headers
    )

    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    {
      'error' => true,
      'status' => e.response&.code,
      'details' => e.response&.body
    }
  rescue StandardError => e
    {
      'error' => true,
      'details' => e.message
    }
  end
end