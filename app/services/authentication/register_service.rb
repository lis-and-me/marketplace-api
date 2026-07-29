module Authentication
  class RegisterService
    def self.call(params)
      user = User.new(
        name: params[:name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
        phone: params[:phone],
        role: :user,
        status: :active
      )

      return { success: false, errors: user.errors } unless user.save

      Cart.create!(user: user)

      access_token = JwtService.generate_access_token(user)
      refresh_token = JwtService.generate_refresh_token

      user.refresh_tokens.create!(
        token: refresh_token,
        expires_at: JwtService::REFRESH_TOKEN_EXPIRATION.from_now
      )

      {
        success: true,
        access_token: access_token,
        refresh_token: refresh_token,
        user: user
      }
    end
  end
end