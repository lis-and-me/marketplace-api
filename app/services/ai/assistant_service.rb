require "faraday"
require "json"

module Ai
  class AssistantService
    API_BASE_URL =
      "https://generativelanguage.googleapis.com/v1beta/models"

   def self.call(message:, context:)
  new(message, context).call
end

def initialize(message, context)
  @message = message.to_s.strip
  @context = context
end
    def call
      raise ArgumentError, "Message is required" if @message.blank?

      context = @context

      response = connection.post(endpoint) do |request|
        request.headers["x-goog-api-key"] =
          ENV.fetch("GEMINI_API_KEY")

        request.headers["Content-Type"] =
          "application/json"

        request.body = {
          system_instruction: {
            parts: [
              {
                text: instructions
              }
            ]
          },
          contents: [
            {
              role: "user",
              parts: [
                {
                  text: build_input(context)
                }
              ]
            }
          ],
          generationConfig: {
            temperature: 0.2
          }
        }.to_json
      end

      body = JSON.parse(response.body)

      unless response.success?
        message =
          body.dig("error", "message") ||
          "Gemini API request failed"

        raise StandardError, message
      end

      {
        answer: extract_answer(body),
        model: model
      }
    end

    private

    def model
      ENV.fetch(
        "GEMINI_MODEL",
         "gemini-3.6-flash"
      )
    end

    def endpoint
      "#{API_BASE_URL}/#{model}:generateContent"
    end

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.options.timeout = 30
        faraday.options.open_timeout = 10
      end
    end

    def instructions
      <<~PROMPT
        Eres un asistente administrativo para un marketplace.

        Tu función es ayudar al administrador a analizar:
        - productos
        - inventario
        - pedidos
        - ventas
        - clientes
        - reseñas

        Responde siempre en español.

        Basa tus conclusiones únicamente en los datos reales del
        marketplace proporcionados por el sistema.

        No inventes ventas, productos, cantidades, usuarios ni
        estadísticas.

        Si los datos disponibles no permiten responder una pregunta,
        indícalo claramente.

        Da respuestas concisas, útiles y orientadas a la administración
        de la tienda.
      PROMPT
    end

    def build_input(context)
      <<~INPUT
        DATOS ACTUALES DEL MARKETPLACE:

        #{JSON.pretty_generate(context)}

        PREGUNTA DEL ADMINISTRADOR:

        #{@message}
      INPUT
    end

    def extract_answer(body)
      text = body
        .fetch("candidates", [])
        .flat_map do |candidate|
          candidate
            .fetch("content", {})
            .fetch("parts", [])
        end
        .filter_map { |part| part["text"] }
        .join("\n")
        .strip

      return text if text.present?

      raise StandardError,
            "Gemini returned no text response"
    end
  end
end