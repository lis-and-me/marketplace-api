module Api
  module V1
    class AddressesController < BaseController
      before_action :set_address, only: %i[show update destroy]

      def index
        addresses = policy_scope(Current.user.addresses)

        render json: addresses
      end

      def show
        authorize @address

        render json: @address
      end

      def create
        authorize Address

        address = ::Addresses::CreateService.call(
          user: Current.user,
          params: address_params
        )

        render json: address,
               status: :created
      end

      def update
        authorize @address

        address = ::Addresses::UpdateService.call(
          address: @address,
          params: address_params
        )

        render json: address
      end

      def destroy
        authorize @address

        ::Addresses::DestroyService.call(
          address: @address
        )

        head :no_content
      end

      private

      def set_address
        @address = Current.user.addresses.find(params[:id])
      end

      def address_params
        params.require(:address).permit(
          :alias,
          :recipient,
          :street,
          :external_number,
          :internal_number,
          :neighborhood,
          :city,
          :state,
          :postal_code,
          :country,
          :references,
          :is_default
        )
      end
    end
  end
end