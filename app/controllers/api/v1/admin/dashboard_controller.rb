module Api
  module V1
    module Admin
      class DashboardController < Api::V1::BaseController
        def show
          authorize :dashboard, :show?

          stats = Dashboard::StatsService.call

render json: DashboardSerializer.new(stats).as_json
        end
      end
    end
  end
end