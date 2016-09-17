module Teth
  module Configurable
    def option(name, default=nil)
      singleton_class.send(:define_method, name) do |*args|
        if args.empty?
          v = instance_variable_get("@#{name}")
          return default if v.nil?
          v
        else
          instance_variable_set("@#{name}", args[0])
        end
      end
    end
  end
end
