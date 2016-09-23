module Backends
  module Msazure
    module Helpers
      module StorageParseHelper

        def parse_backend_obj(res)
          storage = ::Occi::Infrastructure::Storage.new

          storage.attributes['occi.core.id'] = res.send("id").gsub(/^\//,'')
          storage.attributes['occi.core.title'] = res.send("name")

          storage
        end
      end
    end
  end
end
