module Addresses
  class UpdateService
    def self.call(...)
      new(...).call
    end

    def initialize(address:, params:)
      @address = address
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        unset_default_address if @params[:is_default]

        @address.update!(@params)

        @address
      end
    end

    private

    def unset_default_address
      @address.user.addresses
              .where(is_default: true)
              .where.not(id: @address.id)
              .update_all(is_default: false)
    end
  end
end