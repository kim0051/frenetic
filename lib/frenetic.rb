require 'addressable/uri'
require 'faraday'

require "frenetic/configuration"
require "frenetic/hal_json"
require "frenetic/resource"
require "frenetic/version"

class Frenetic

  class MissingAPIReference < StandardError; end

  extend Forwardable
  def_delegators :@connection, :get, :put, :post, :delete

  attr_reader  :connection
  alias_method :conn, :connection

  def initialize( config = {} )
    config      = Configuration.new( config )

    api_url     = Addressable::URI.parse( config[:url] )
    @root_url   = api_url.path

    @connection = Faraday.new( config ) do |builder|
      builder.use HalJson
      builder.request :basic_auth, config[:username], config[:password]
      builder.adapter :patron
    end
  end

  def schema
    @schema ||= load_schema
  end

private

  def load_schema
    if response = get( @root_url ) and response.success?
      @schema = response.body
    end
  end
end
