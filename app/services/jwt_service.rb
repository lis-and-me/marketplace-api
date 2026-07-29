class JwtService
  ALGORITHM = "HS256".freeze

  ACCESS_TOKEN_EXPIRATION = 15.minutes
  REFRESH_TOKEN_EXPIRATION = 30.days

  class << self
    def encode(payload, expires_at:)
      payload[:exp] = expires_at.to_i

      JWT.encode(
        payload,
        secret_key,
        ALGORITHM
      )
    end

    def decode(token)
      decoded = JWT.decode(
        token,
        secret_key,
        true,
        algorithm: ALGORITHM
      )

      decoded.first.with_indifferent_access
    rescue JWT::ExpiredSignature
      nil
    rescue JWT::DecodeError
      nil
    end

    def generate_access_token(user)
      encode(
        {
          user_id: user.id,
          role: user.role
        },
        expires_at: ACCESS_TOKEN_EXPIRATION.from_now
      )
    end

    def generate_refresh_token
      SecureRandom.hex(64)
    end

    private

    def secret_key
      ENV.fetch("JWT_SECRET_KEY")
    end
  end
end