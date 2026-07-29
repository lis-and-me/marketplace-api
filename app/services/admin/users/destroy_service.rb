module Admin
  module Users
    class DestroyService
      def self.call(user:)
        ActiveRecord::Base.transaction do
          user.soft_delete!
        end
      end
    end
  end
end