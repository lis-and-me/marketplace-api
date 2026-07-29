module Admin
  module Users
    class UpdateService
      def self.call(user:, params:, actor:)
        new(
          user: user,
          params: params,
          actor: actor
        ).call
      end

      def initialize(user:, params:, actor:)
        @user = user
        @params = params
        @actor = actor
      end

      def call
        ActiveRecord::Base.transaction do
          validate_self_update!

          @user.update!(@params)

          @user
        end
      end

      private

      def validate_self_update!
        return unless @user.id == @actor.id

        if @params[:role].present? &&
           @params[:role].to_s != @user.role
          @user.errors.add(
            :role,
            "cannot be changed on your own account"
          )
        end

        if @params[:status].present? &&
           @params[:status].to_s != @user.status
          @user.errors.add(
            :status,
            "cannot be changed on your own account"
          )
        end

        if @user.errors.any?
          raise ActiveRecord::RecordInvalid.new(@user)
        end
      end
    end
  end
end