require 'restclient'
require 'restclient/components'
require 'json'
require 'rack/cache'
require 'logger'


module Wego
  class WegoApi

    RestClient.enable Rack::CommonLogger, STDOUT
    RestClient.enable Rack::Cache

    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::DEBUG

    # Configuration defaults
    @@config = {
    :wego_api_url_prefix => "api.wego.com/flights/api/k",
    :version => '2',
    :api_key => 'b2af842a51f01435cdb7',
    :ts_code => '9e802',
    :base_headers => {content_type: :json, accept: :json},
    :locale => 'fr'
    }

    @valid_config_keys = @@config.keys

    # Configure through hash
    def self.configure(opts = {})
      opts.each { |k, v| @@config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
      @@config[:searches_url] = @@config[:wego_api_url_prefix]+'/'+@@config[:version]+'/searches'
      @@config[:fares_url] = @@config[:wego_api_url_prefix]+'/'+@@config[:version]+'/fares'
      @@config[:currencies_url] = @@config[:wego_api_url_prefix]+'/'+@@config[:version]+'/currencies'
      @@config[:base_params] = {api_key: @@config[:api_key], ts_code: @@config[:ts_code], locale: @@config[:locale]}
    end
    # Configure through yaml file
    def self.configure_with(path_to_yaml_file)
      begin
        config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
      rescue Psych::SyntaxError
        log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
        configure(config)
      end
    end

    #Configure defaults
    self.configure

    def self.config
      @@config
    end

    def self.logger
      @@logger
    end

    def initialize()
      puts "Wego api Initialized"
    end

    def search_trips(departure_code, arrival_code, outbound_date, inbound_date, adults_count)
      trips = [
          {
              departure_code: departure_code,
              arrival_code: arrival_code,
              outbound_date: outbound_date,
              inbound_date: inbound_date
          }
      ]
      postBody = {trips: trips, departure_city: true, arrival_city: true, adults_count: adults_count}
      tripResponse = postToWego(@@config[:searches_url],postBody)
      if(tripResponse.code == 200)
        sleep(10) #Or do something during that 10 sec.
        get_fares(tripResponse.id,tripResponse.trips[0].id)
      end
    end

    def get_fares(search_id, trip_id, filters = {}  )
      postBody = {
          id:               Random.new_seed,
          search_id:        search_id,
          trip_id:          trip_id,
          fares_query_type: 'route'
      }.merge(filters)
      postToWego(@@config[:fares_url],postBody)
    end

    def postToWego(url,postBody)
      response = RestClient.post(url, postBody.to_json, {params: @@config[:base_params]}.merge(@@config[:base_headers]))
      @@logger.debug(" response is :::\n #{response.dump}\n------------")
      response
    end

  end
end