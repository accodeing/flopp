require 'hanami/router'
require 'app/file_reference/controller'

dbconfig = {
  # ...
}

router = Hanami::Router.new

router.namespace 'api' do
  namespace 'v1' do
    patch '/test', to: FileReference::Controller::Update
    root to: ->(env) { [200, {}, ['API root']] }
  end
end

Rack::Server.start app: router, Port: 2300
