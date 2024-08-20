# frozen_string_literal: true

require_relative "./messages"
require "binding_of_caller"

module SealDetective
  module Decorator
    def self.included(base)
      # TODO: would running it with `true` be significantly bad for performance? how about usefulness?
      base.public_instance_methods(false).each do
        method_object = base.instance_method(_1)
        base.undef_method(_1)
        extend_method(base, method_object)
      end
      base.singleton_methods(false).each do
        method_object = base.singleton_method(_1).unbind
        base.singleton_class.undef_method(_1)
        extend_method(base.singleton_class, method_object)
      end
    end

    def self.extend_method(base, method_object)
      # TODO: check if the right caller is added to Messages

      base.define_method(method_object.name) do |*args, **kwargs, &block|
        # puts "debtu defined", method_object.name
        sender = binding.of_caller(1).eval("self")
        SealDetective::Messages.add(sender: sender, receiver: self, method: method_object.name,
                                    arguments: [args, kwargs, block])
        method_object.bind(self).call(
          *args, **kwargs, &block
        )
      end
    end
  end
end
