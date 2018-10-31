require 'hanami/router'
require 'app/file_reference/update'

router = Hanami::Router.new
router.namespace 'api' do
  namespace 'v1' do
    patch '/test', to: Update.new
    root to: ->(env) { [200, {}, ['API root']] }
  end
end

Rack::Server.start app: router, Port: 2300
