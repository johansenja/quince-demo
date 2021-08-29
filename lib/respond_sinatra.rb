require_relative "../../respond/respond"

module Respond
  class SinatraMiddleware
    def initialize
      require "sinatra/base"
      Respond.middleware_app = Class.new(Sinatra::Base)
    end

    def create_route_handler(verb:, route:, component:)
      meth = case verb
        when :POST, :post
          :post
        when :GET, :get
          :get
        else
          raise "invalid verb"
        end

      Respond.middleware_app.public_send meth, route do
        to_html(component)
      end
    end
  end
end

Respond.use_middleware Respond::SinatraMiddleware

at_exit { Respond.middleware_app.run! }
