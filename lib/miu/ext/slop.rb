module Slop
  class AddressesOption < ArrayOption
    def call(value)
      super value || ''
    end

    def expects_argument?
      false
    end
  end
end
