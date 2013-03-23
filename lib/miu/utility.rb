module Miu
  module Utility
    module_function

    def adapt(klass, value)
      value ||= {}
      value.is_a?(klass) ? value : klass.new(value)
    end

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

    def modify_keys(hash, recursive = false, &block)
      hash = hash.dup
      if block
        hash.keys.each do |key|
          value = hash.delete(key)
          if recursive
            case value
            when ::Hash
              value = modify_keys(value, recursive, &block)
            when ::Array
              value = value.map { |v| v.is_a?(::Hash) ? modify_keys(v, recursive, &block) : v }
            end
          end
          key = block.call key
          hash[key] = value
        end
      end
      hash
    end

    def symbolize_keys(hash, recursive = false)
      modify_keys(hash, recursive) do |key|
        key.to_sym rescue key
      end
    end

    def underscorize_keys(hash, recursive = false)
      modify_keys(hash, recursive) do |key|
        key.gsub('-', '_') rescue key
      end
    end

    def optionify_keys(hash, recursive = false)
      modify_keys(hash, recursive) do |key|
        key.to_s.gsub('-', '_').to_sym rescue key
      end
    end
  end
end
