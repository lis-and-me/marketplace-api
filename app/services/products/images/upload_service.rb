module Products
  module Images
    class UploadService
      def self.call(...)
        new(...).call
      end

      def initialize(file:)
        @file = file
      end

      def call
        result = Cloudinary::Uploader.upload(
          @file.tempfile.path,
          folder: "products"
        )

        {
          image_url: result["secure_url"],
          public_id: result["public_id"]
        }
      end
    end
  end
end