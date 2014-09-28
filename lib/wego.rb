require 'restclient'
require 'restclient/components'
require 'rack/cache'
require 'logger'

module Wego

  RestClient.enable Rack::CommonLogger, STDOUT
  RestClient.enable Rack::Cache

  @logger = Logger.new(STDOUT)
  @logger.level = Logger::DEBUG

  # Configuration defaults
  @config = {
  :wego_api_url_prefix  => "api.wego.com/flights/api/k",
  :version              => 2,
  :api_key              => 'b2af842a51f01435cdb7',
  :ts_code              => '9e802',
  :base_headers         => {content_type: :json, accept: :json},
  :locale               => 'fr'
  }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    end
  end
  rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
      configure(config)

      def self.config
        @config[:searches_url]    = @config[:wego_api_url_prefix]+'/'+@config[:version]+'/searches'
        @config[:fares_url]       = @config[:wego_api_url_prefix]+'/'+@config[:version]+'/fares'
        @config[:currencies_url]  = @config[:wego_api_url_prefix]+'/'+@config[:version]+'/currencies'
        @config[:base_params]     = {api_key: @config[:api_key], ts_code: @config[:ts_code], locale: @config[:locale]}
        @config
      end

      def self.logger
        @logger
      end

end

require "wego/version"
require "./lib/wego/wego_api"





















