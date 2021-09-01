ENV["RACK_ENV"] ||= "development"

require "sinatra/base"
require "sinatra/reloader" if ENV["RACK_ENV"] == "development"
require "rack/contrib"
require_relative "../../respond/lib/respond"

module Respond
  class SinatraMiddleware
    def initialize
      Respond.underlying_app = Class.new(Sinatra::Base) do
        configure :development do
          if Object.const_defined? "Sinatra::Reloader"
            register Sinatra::Reloader
            dont_reload __FILE__
            also_reload $0
          end
        end
        use Rack::JSONBodyParser
      end
    end

    def create_route_handler(verb:, route:, component: nil)
      meth = case verb
        when :POST, :post
          :post
        when :GET, :get
          :get
        else
          raise "invalid verb"
        end

      Respond.underlying_app.public_send meth, route do
        component ||= yield(params)
        Respond.to_html(component)
      end
    end
  end
end

Respond.middleware = Respond::SinatraMiddleware.new

at_exit { Respond.underlying_app.run! }
