module Backends
  module Azure
    class Base
      API_VERSION = '1.0.0'
      FIXTURES = [:compute, :network, :storage].freeze
      FIXTURES_TPL = [:os_tpl, :resource_tpl].freeze

      # load helpers for JSON -> Collection conversion
      include Backends::Helpers::JsonCollectionHelper

      def initialize(delegated_user, options, server_properties, logger, dalli_cache)
        @delegated_user = Hashie::Mash.new(delegated_user)
        @options = Hashie::Mash.new(options)
        @server_properties = Hashie::Mash.new(server_properties)
        @logger = logger || Rails.logger
        @dalli_cache = dalli_cache
        @other_backends = {}
#        @azure_client = nil

        # establish connection with Azure
#        run_authn unless Rails.env.test? # disable early auth for tests


        path = @options.fixtures_dir || '' # TODO Remove eventually?
        read_fixtures(path)
      end

      def add_other_backend(backend_type, backend_instance)
        fail 'Type and instance must be provided!' unless backend_type && backend_instance
        @other_backends[backend_type] = backend_instance
      end

      private

      # load helpers for working with OCCI extensions
      include Backends::Helpers::ExtensionsHelper

      def read_fixtures(base_path)
        @logger.debug "[Backends] [Azure] Reading fixtures from #{base_path.to_s.inspect}"
        (FIXTURES + FIXTURES_TPL).each { |name| send "read_#{name}_fixtures", base_path }
      end

      FIXTURES.each do |fixture|
        class_eval %Q|
def read_#{fixture}_fixtures(path = '')
  #{fixture} = Rails.env.test? ? @#{fixture} : @dalli_cache.get('azure_#{fixture}')

  unless #{fixture}
    path = path_for_fixture_file(path, :#{fixture})
    @logger.debug "[Backends] [Azure] Reloading #{fixture} fixtures from '" + path.to_s + "'"
    #{fixture} = File.readable?(path) ? read_from_json(path).resources : Occi::Core::Resources.new
    save_#{fixture}_fixtures(#{fixture})
  end

  #{fixture}
end

def save_#{fixture}_fixtures(#{fixture})
  Rails.env.test? ? @#{fixture} = #{fixture} : @dalli_cache.set('azure_#{fixture}', #{fixture})
end

def drop_#{fixture}_fixtures(lite = true)
  if lite
    save_#{fixture}_fixtures(Occi::Core::Resources.new)
  else
    Rails.env.test? ? @#{fixture} = nil : @dalli_cache.delete('azure_#{fixture}')
  end
end
|
      end

      FIXTURES_TPL.each do |fixture_tpl|
        class_eval %Q|
def read_#{fixture_tpl}_fixtures(path = '')
  #{fixture_tpl} = Rails.env.test? ? @#{fixture_tpl} : @dalli_cache.get('azure_#{fixture_tpl}')

  unless #{fixture_tpl}
    path = path_for_fixture_file(path, :#{fixture_tpl})
    @logger.debug "[Backends] [Azure] Reloading #{fixture_tpl} fixtures from '" + path.to_s + "'"
    #{fixture_tpl} = File.readable?(path) ? read_from_json(path).mixins : Occi::Core::Mixins.new
    save_#{fixture_tpl}_fixtures(#{fixture_tpl})
  end

  #{fixture_tpl}
end

def save_#{fixture_tpl}_fixtures(#{fixture_tpl})
  Rails.env.test? ? @#{fixture_tpl} = #{fixture_tpl} : @dalli_cache.set('azure_#{fixture_tpl}', #{fixture_tpl})
end
|
      end

      def path_for_fixture_file(path, fixture_type)
        return path if path && path.to_s.end_with?('.json')
        path = @options.fixtures_dir if path.blank?

        fail Backends::Errors::ResourceRetrievalError, "Unable to read fixtures " \
             "from an unspecified directory!" if path.blank?
        fail Backends::Errors::ResourceRetrievalError, "Unable to read fixtures " \
             "for #{fixture_type.to_s.inspect}!" unless (FIXTURES + FIXTURES_TPL).include? fixture_type

        File.join(path, "#{fixture_type}.json")
      end


#      def run_authn
#        return if @azure_client
#
#        @resource_group = resource_group
#        @subscription_id = subscription_id
#        pub_ssh_key_path = File.expand_path('~/.ssh/id_rsa.pub') #TODO remove hard-coded key
#        raise ArgumentError.new("The path: #{pub_ssh_key_path} does not exist.") unless File.exist?(pub_ssh_key_path)
#        @pub_ssh_key = File.read(pub_ssh_key_path)
#        provider = MsRestAzure::ApplicationTokenProvider.new(
#            @options.tenant_id,
#            @options.client_id,
#            @options.client_secret)
#        credentials = MsRest::TokenCredentials.new(provider)
#        @azure_client = Azure::ARM::Resources::ResourceManagementClient.new(credentials)
#
#        fail Backends::Errors::AuthenticationError, 'Could not get an Azure client for the current user!' unless @azure_client
#        @azure_client.subscription_id = @options.subscription_id
#
#      end

    end
  end
end
