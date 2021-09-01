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

    def create_route_handler(verb:, route:, component: nil, &blck)
      meth = case verb
        when :POST, :post
          :post
        when :GET, :get
          :get
        else
          raise "invalid verb"
        end
      handler = component ? ->(_) { component } : blck
      Respond::SinatraMiddleware.send(:routes)[[verb, route]] = handler

      Respond.underlying_app.public_send meth, route do
        handler = Respond::SinatraMiddleware.send(:routes)[[verb, route]]
        Respond.to_html(handler.call(params))
      end
    end

    private_class_method def self.routes
                           @routes ||= {}
                         end
  end
end

Respond.middleware = Respond::SinatraMiddleware.new

at_exit { Respond.underlying_app.run! }
