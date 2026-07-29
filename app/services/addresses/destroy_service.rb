module Addresses
  class DestroyService
    def self.call(...)
      new(...).call
    end

    def initialize(address:)
      @address = address
    end

    def call
      @address.destroy!
    end
  end
end