module Products
  module Images
    class CreateService
      def self.call(product, params)
        product.product_images.create!(params)
      end
    end
  end
end