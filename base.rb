require 'rack'
require 'thin'

module Application
  class Base
    attr_reader :routes, :request
    def initialize 
      @routes = {}
    end

    def get(path, &handler)
      route('GET', path, &handler)
    end
    
    def post(path, &handler)
      route('POST', path, &handler)
    end

    def patch(path, &handler)
      route('PATCH', path, &handler)
    end

    def delete(path, &handler)
      route('DELETE', path, &handler)
    end

    def call(env)
      @request = Rack::Request.new(env)
      method = @request.request_method
      path = @request.path_info

      handler = @routes
                  .fetch(method, {})
                  .fetch(path, nil)
      
      if handler
        result =instance_eval(&handler)
        if result.class == String
          [200, {}, [result]]
        else
          result
        end
      else
        [404, {}, ["undefined route #{path} for #{method}"]]
      end

    end

    private

    def route(method, path, &handler)
      @routes[method] ||= {}
      @routes[method][path] = handler
    end

    def params
      @request.params
    end
  end

end

our_app = Application::Base.new

our_app.get '/hello' do
  "our params: #{params}"
end
our_app.post '/' do
  request.body
end

Rack::Handler::Thin.run(our_app)