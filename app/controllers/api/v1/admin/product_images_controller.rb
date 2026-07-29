module Api
  module V1
    module Admin
      class ProductImagesController < Api::V1::BaseController
        before_action :set_product
        before_action :set_image, only: %i[show update destroy]

        def index
          authorize ProductImage

          render json: @product.product_images.order(:position)
        end

        def show
          authorize @image

          render json: @image
        end

        def create
  authorize ProductImage

  upload = Products::Images::UploadService.call(
    file: params[:file]
  )

  image = Products::Images::CreateService.call(
    @product,
    {
      image_url: upload[:image_url],
      public_id: upload[:public_id],
      position: image_params[:position]
    }
  )

  render json: image,
         status: :created
rescue ActiveRecord::RecordInvalid => e
  render json: {
    errors: e.record.errors.full_messages
  }, status: :unprocessable_entity
end

        def update
          authorize @image

          image = Products::Images::UpdateService.call(
            @image,
            image_params
          )

          render json: image
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        def destroy
          authorize @image

          Products::Images::DestroyService.call(@image)

          head :no_content
        end

        private

        def set_product
          @product = Product.available.find(params[:product_id])
        end

        def set_image
          @image = @product.product_images.find(params[:id])
        end

     def image_params
  params.permit(
    :file,
    :position
  )
end
      end
    end
  end
end