module Addresses
  class CreateService
    def self.call(...)
      new(...).call
    end

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        unset_default_address if @params[:is_default]

        @user.addresses.create!(@params)
      end
    end

    private

    def unset_default_address
      @user.addresses.where(is_default: true).update_all(is_default: false)
    end
  end
end