require "faraday"
require "sinatra"

configure :development do
  require "dotenv"
  Dotenv.load
end

configure do
  set :faraday, Faraday.new(ENV["IDOBATA_HOOK_URL"]) { |faraday|
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
  }
end

get "/:yo_callback_path" do
  halt 400 unless params[:username]
  halt 400 unless params[:yo_callback_path] == ENV["YO_CALLBACK_PATH"]

  begin
    settings.faraday.post(nil, source: "Yo from #{params[:username]}")
  rescue Faraday::ClientError
    halt 500
  end

  200
end
