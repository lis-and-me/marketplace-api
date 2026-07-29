module Admin
  module Brands
    class DestroyService
      def self.call(brand)
        if brand.destroy
          {
            success: true
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