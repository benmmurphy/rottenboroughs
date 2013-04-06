require 'rack'
use Rack::Deflater
use Rack::Static,:urls => ["/"], :index => "index.html", :root => "build"

run Rack::URLMap.new( { "/" => Rack::Directory.new(".") })

