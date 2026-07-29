module Admin
  module Brands
    class UpdateService
      def self.call(brand, params)
        if brand.update(params)
          {
            success: true,
            brand: brand
          }
        else
          {
            success: false,
            errors: brand.errors.full_messages
          }
        end
      end
    end
  end
end