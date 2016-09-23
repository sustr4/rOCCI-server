module Backends
  module Msazure
    module Helpers
      module NetworkParseHelper

        def parse_backend_obj(res)
          network = ::Occi::Infrastructure::Network.new

          network.attributes['occi.core.id'] = res.send("id").gsub(/^\//,'')
          network.attributes['occi.core.title'] = res.send("name")

          network
        end
      end
    end
  end
end
