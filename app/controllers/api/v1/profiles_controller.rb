module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: {
          id: Current.user.id,
          name: Current.user.name,
          email: Current.user.email,
          role: Current.user.role
        }
      end
    end
  end
end