module Products
  module Images
    class UpdateService
      def self.call(image, params)
        image.update!(params)
        image
      end
    end
  end
end