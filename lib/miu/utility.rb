module Miu
  module Utility
    module_function

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

    def modified_keys(hash)
      hash = hash.dup
      if block_given?
        hash.keys.each do |key|
          yield hash, key
        end
      end
      hash
    end

    def symbolized_keys(hash)
      modified_keys hash do |h, k|
        if k.is_a?(::String)
          h[k.to_sym] = h.delete(k)
        end
      end
    end

    def underscorize_keys(hash)
      modified_keys hash do |h, k|
        if k.is_a?(::String)
          h[k.to_sym] = h.delete(k)
          h[k.gsub('-', '_')] = h.delete(k)
        end
      end
    end
  end
end
