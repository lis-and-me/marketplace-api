module Api
  module V1
    class AssistantController < BaseController
      def chat
        result = Ai::AssistantService.call(
          message: params.require(:message),
          context: Ai::CustomerContextService.call
        )

        render json: result
      end
    end
  end
end