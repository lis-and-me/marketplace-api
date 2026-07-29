module Api
  module V1
    module Admin
      class AiController < Api::V1::BaseController
        def chat
          authorize :ai, :chat?

          result = Ai::AssistantService.call(
            message: params[:message]
          )

          render json: {
            answer: result[:answer],
            model: result[:model]
          }
        rescue ArgumentError => e
          render json: {
            error: e.message
          }, status: :unprocessable_entity
        rescue KeyError
          render json: {
            error: "OPENAI_API_KEY is not configured"
          }, status: :internal_server_error
        rescue StandardError => e
          Rails.logger.error(
            "[AI] #{e.class}: #{e.message}"
          )

          render json: {
            error: e.message
          }, status: :bad_gateway
        end
      end
    end
  end
end