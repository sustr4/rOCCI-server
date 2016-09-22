module Backends
  module Msazure
    module Helpers
      module ComputeParseHelper

        def parse_backend_obj(res)
          compute = ::Occi::Infrastructure::Compute.new
#          os_tpl_mixin = get_resource_tpl(itype_to_term(backend_compute[:instance_type]))
#          if os_tpl_mixin
#            compute.mixins << os_tpl_mixin
#            compute.attributes['occi.compute.cores'] = os_tpl_mixin.attributes.occi_.compute_.cores.default
#            compute.attributes['occi.compute.memory'] = os_tpl_mixin.attributes.occi_.compute_.memory.default
#          else
#            compute.mixins << "http://schemas.ec2.aws.amazon.com/occi/infrastructure/resource_tpl##{itype_to_term(backend_compute[:instance_type])}"
#          end

#          compute.mixins << "#{@options.backend_scheme}/occi/infrastructure/os_tpl##{image_to_term(backend_compute)}"
#          compute.mixins << 'http://schemas.ec2.aws.amazon.com/occi/infrastructure/compute#aws_ec2_instance'

          compute.attributes['occi.core.id'] = res.send("id").gsub('^/','')
          compute.attributes['occi.core.title'] = res.send("name").gsub('^/','')
#          compute.attributes['occi.compute.architecture'] = (backend_compute[:architecture] == 'x86_64') ? 'x64' : 'x86'

#          compute.attributes['com.amazon.aws.ec2.reservation_id'] = reservation_id unless reservation_id.blank?
#          compute.attributes['com.amazon.aws.ec2.availability_zone'] = backend_compute[:placement][:availability_zone] unless backend_compute[:placement].blank?
#          compute.attributes['com.amazon.aws.ec2.state'] = backend_compute[:state][:name] unless backend_compute[:state].blank?
#          compute.attributes['com.amazon.aws.ec2.hypervisor'] = backend_compute[:hypervisor] unless backend_compute[:hypervisor].blank?
#          compute.attributes['com.amazon.aws.ec2.virtualization_type'] = backend_compute[:virtualization_type] unless backend_compute[:virtualization_type].blank?

          # include state information and available actions
#          result = parse_state(backend_compute)
#          compute.state = result.state
#          result.actions.each { |a| compute.actions << a }

          # include storage and network links
#          result = parse_links(backend_compute, compute)
#          result.each { |link| compute.links << link }

          compute
        end
      end
    end
  end
end
