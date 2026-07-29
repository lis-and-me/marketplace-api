module Products
  module Images
    class DestroyService
      def self.call(image)
        Cloudinary::Uploader.destroy(image.public_id)

        image.destroy!
      end
    end
  end
end